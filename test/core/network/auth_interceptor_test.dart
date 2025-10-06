import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nihonix/core/network/auth_interceptor.dart';
import 'package:nihonix/core/network/http_exceptions.dart';

// ============================================================================
// MOCK IMPLEMENTATIONS
// ============================================================================

class MockTokenStore implements TokenStore {
  String? _accessToken;
  String? _refreshToken;

  @override
  Future<String?> readAccessToken() async => _accessToken;

  @override
  Future<String?> readRefreshToken() async => _refreshToken;

  @override
  Future<void> saveAccessToken(String token) async {
    _accessToken = token;
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    _refreshToken = token;
  }

  @override
  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
  }
}

class MockNetworkInfo implements NetworkInfo {
  bool _isConnected = true;

  @override
  Future<bool> get isConnected async => _isConnected;

  void setConnected(bool value) {
    _isConnected = value;
  }
}

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  bool shouldFail = false;
  int callCount = 0;

  @override
  Future<({String accessToken, String refreshToken})> refreshToken(
    String refreshToken,
  ) async {
    callCount++;
    if (shouldFail) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/refresh'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          statusCode: 401,
        ),
      );
    }
    return (
      accessToken: 'new_access_token',
      refreshToken: 'new_refresh_token',
    );
  }

  void reset() {
    shouldFail = false;
    callCount = 0;
  }
}

// ============================================================================
// TESTS
// ============================================================================

void main() {
  late Dio dio;
  late MockTokenStore tokenStore;
  late MockNetworkInfo networkInfo;
  late MockAuthRemoteDataSource authRemote;
  late bool onUnauthorizedCalled;
  late AuthInterceptor interceptor;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    tokenStore = MockTokenStore();
    networkInfo = MockNetworkInfo();
    authRemote = MockAuthRemoteDataSource();
    onUnauthorizedCalled = false;

    interceptor = AuthInterceptor(
      tokenStore: tokenStore,
      networkInfo: networkInfo,
      authRemote: authRemote,
      onUnauthorized: () async {
        onUnauthorizedCalled = true;
      },
      paths: AuthPathsConfig(
        excludedPaths: ['/auth/login', '/auth/refresh'],
        refreshPath: '/auth/refresh',
      ),
    );

    dio.interceptors.add(interceptor);
  });

  group('AuthInterceptor - Token Attachment', () {
    test('should attach Bearer token to normal requests', () async {
      // Arrange
      await tokenStore.saveAccessToken('test_token_123');

      // Act & Assert
      final options = RequestOptions(path: '/users/me');
      final handler = _MockRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer test_token_123');
      expect(handler.nextCalled, true);
    });

    test('should NOT attach token to excluded paths', () async {
      // Arrange
      await tokenStore.saveAccessToken('test_token_123');

      // Act
      final options = RequestOptions(path: '/auth/login');
      final handler = _MockRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      // Assert
      expect(options.headers['Authorization'], isNull);
      expect(handler.nextCalled, true);
    });

    test('should NOT attach token when no token available', () async {
      // Act
      final options = RequestOptions(path: '/users/me');
      final handler = _MockRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      // Assert
      expect(options.headers['Authorization'], isNull);
      expect(handler.nextCalled, true);
    });
  });

  group('AuthInterceptor - Network Check', () {
    test('should throw NoInternetException when offline', () async {
      // Arrange
      networkInfo.setConnected(false);

      // Act
      final options = RequestOptions(path: '/users/me');
      final handler = _MockRequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      // Assert
      expect(handler.rejectCalled, true);
      expect(handler.rejectedError?.error, isA<NoInternetException>());
    });
  });

  group('AuthInterceptor - 401 Handling', () {
    test('should refresh token and replay request on 401', () async {
      // Arrange
      await tokenStore.saveAccessToken('old_token');
      await tokenStore.saveRefreshToken('refresh_token');

      final error = DioException(
        requestOptions: RequestOptions(path: '/users/me'),
        response: Response(
          requestOptions: RequestOptions(path: '/users/me'),
          statusCode: 401,
        ),
      );

      // Act
      final handler = _MockErrorInterceptorHandler();
      await interceptor.onError(error, handler);

      // Assert
      expect(authRemote.callCount, 1);
      expect(await tokenStore.readAccessToken(), 'new_access_token');
      expect(await tokenStore.readRefreshToken(), 'new_refresh_token');
    });

    test('should call onUnauthorized when refresh fails', () async {
      // Arrange
      await tokenStore.saveAccessToken('old_token');
      await tokenStore.saveRefreshToken('refresh_token');
      authRemote.shouldFail = true;

      final error = DioException(
        requestOptions: RequestOptions(path: '/users/me'),
        response: Response(
          requestOptions: RequestOptions(path: '/users/me'),
          statusCode: 401,
        ),
      );

      // Act
      final handler = _MockErrorInterceptorHandler();
      await interceptor.onError(error, handler);

      // Assert
      expect(onUnauthorizedCalled, true);
      expect(await tokenStore.readAccessToken(), isNull);
      expect(await tokenStore.readRefreshToken(), isNull);
    });

    test('should NOT retry when 401 from refresh endpoint', () async {
      // Arrange
      await tokenStore.saveAccessToken('old_token');
      await tokenStore.saveRefreshToken('refresh_token');

      final error = DioException(
        requestOptions: RequestOptions(path: '/auth/refresh'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          statusCode: 401,
        ),
      );

      // Act
      final handler = _MockErrorInterceptorHandler();
      await interceptor.onError(error, handler);

      // Assert
      expect(authRemote.callCount, 0); // Should NOT call refresh
      expect(onUnauthorizedCalled, true);
    });
  });

  group('AuthInterceptor - Exception Mapping', () {
    test('should map 400 to BadRequestException', () async {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/users'),
        response: Response(
          requestOptions: RequestOptions(path: '/users'),
          statusCode: 400,
          data: {'message': 'Invalid input'},
        ),
      );

      // Act
      final handler = _MockErrorInterceptorHandler();
      await interceptor.onError(error, handler);

      // Assert
      expect(handler.rejectCalled, true);
      expect(handler.rejectedError?.error, isA<BadRequestException>());
    });

    test('should map 403 to ForbiddenException', () async {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/admin'),
        response: Response(
          requestOptions: RequestOptions(path: '/admin'),
          statusCode: 403,
        ),
      );

      // Act
      final handler = _MockErrorInterceptorHandler();
      await interceptor.onError(error, handler);

      // Assert
      expect(handler.rejectCalled, true);
      expect(handler.rejectedError?.error, isA<ForbiddenException>());
    });

    test('should map 404 to NotFoundException', () async {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/users/999'),
        response: Response(
          requestOptions: RequestOptions(path: '/users/999'),
          statusCode: 404,
        ),
      );

      // Act
      final handler = _MockErrorInterceptorHandler();
      await interceptor.onError(error, handler);

      // Assert
      expect(handler.rejectCalled, true);
      expect(handler.rejectedError?.error, isA<NotFoundException>());
    });

    test('should map 5xx to ServerException', () async {
      // Arrange
      final error = DioException(
        requestOptions: RequestOptions(path: '/users'),
        response: Response(
          requestOptions: RequestOptions(path: '/users'),
          statusCode: 500,
        ),
      );

      // Act
      final handler = _MockErrorInterceptorHandler();
      await interceptor.onError(error, handler);

      // Assert
      expect(handler.rejectCalled, true);
      expect(handler.rejectedError?.error, isA<ServerException>());
    });
  });
}

// ============================================================================
// MOCK HANDLERS
// ============================================================================

class _MockRequestInterceptorHandler extends RequestInterceptorHandler {
  bool nextCalled = false;
  bool rejectCalled = false;
  DioException? rejectedError;

  @override
  void next(RequestOptions requestOptions) {
    nextCalled = true;
  }

  @override
  void reject(DioException error, [bool newState = false]) {
    rejectCalled = true;
    rejectedError = error;
  }
}

class _MockErrorInterceptorHandler extends ErrorInterceptorHandler {
  bool resolveCalled = false;
  bool rejectCalled = false;
  Response? resolvedResponse;
  DioException? rejectedError;

  @override
  void resolve(Response response) {
    resolveCalled = true;
    resolvedResponse = response;
  }

  @override
  void reject(DioException error, [bool newState = false]) {
    rejectCalled = true;
    rejectedError = error;
  }
}
