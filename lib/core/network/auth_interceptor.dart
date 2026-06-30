import 'dart:async';
import 'package:dio/dio.dart';
import 'http_exceptions.dart';
import 'api_response.dart';
import '../storage/token_store.dart';

/// Kiểm tra kết nối mạng (implementation sẽ dùng connectivity_plus).
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Callback dùng khi refresh token thất bại để app điều hướng về màn login.
typedef OnUnauthorized = Future<void> Function();

/// Endpoint & logic refresh token (gọi API thực).
///
/// Note: Interface này khác với AuthRemoteDataSource trong features/auth/data/datasources/.
/// Interface này chỉ dùng cho AuthInterceptor, còn AuthRemoteDataSource trong features là full API client.
abstract class IAuthRefreshService {
  /// Trả về cặp token mới khi refresh thành công.
  Future<({String accessToken, String refreshToken})> refreshToken(
    String refreshToken,
  );
}

/// Cho phép cấu hình danh sách path không gắn Bearer, và path liên quan auth.
class AuthPathsConfig {
  final List<String> excludedPaths;
  final String refreshPath;

  AuthPathsConfig({
    required this.excludedPaths,
    required this.refreshPath,
  });
}

class AuthInterceptor extends Interceptor {
  final TokenStore _tokenStore;
  final NetworkInfo _networkInfo;
  final IAuthRefreshService _authRemote;
  final OnUnauthorized _onUnauthorized;
  final AuthPathsConfig _paths;
  final List<String> _retryIdempotentMethods;
  final int _maxRetries;

  /// Reference to Dio instance for retrying requests
  Dio? _dio;

  /// Completer để implement single-flight pattern cho refresh token.
  /// Đảm bảo chỉ có 1 refresh request được thực hiện tại một thời điểm.
  Completer<void>? _refreshCompleter;

  /// Debounce flag để tránh gọi onUnauthorized() nhiều lần.
  bool _hasCalledUnauthorized = false;

  AuthInterceptor({
    required TokenStore tokenStore,
    required NetworkInfo networkInfo,
    required IAuthRefreshService authRemote,
    required OnUnauthorized onUnauthorized,
    required AuthPathsConfig paths,
    List<String> retryIdempotentMethods = const ['GET', 'HEAD', 'OPTIONS'],
    int maxRetries = 2,
  })  : _tokenStore = tokenStore,
        _networkInfo = networkInfo,
        _authRemote = authRemote,
        _onUnauthorized = onUnauthorized,
        _paths = paths,
        _retryIdempotentMethods = retryIdempotentMethods,
        _maxRetries = maxRetries;

  /// Set Dio instance for retrying requests
  void setDio(Dio dio) {
    _dio = dio;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // 2. Kiểm tra kết nối mạng trước khi gửi request
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        return handler.reject(
          DioException(
            requestOptions: options,
            error: NoInternetException(),
          ),
        );
      }

      // 2. Gắn Bearer token nếu path không nằm trong excludedPaths
      if (!_isExcludedPath(options.path)) {
        final accessToken = await _tokenStore.readAccessToken();
        if (accessToken != null && accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        } else {}
      } else {}

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
        ),
      );
    }
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    try {
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;

        if (!data.containsKey('success') || !data.containsKey('message')) {
          response.data = ApiResponseSuccess.create(
            data: data,
            message: 'Success',
            statusCode: response.statusCode,
          ).toJson((data) => data);
        }
      }

      handler.next(response);
    } catch (e) {
      handler.next(response);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;

    if (statusCode == 401 && !_isRefreshPath(path)) {
      try {
        await _handleTokenRefresh();

        // Refresh thành công → replay request với token mới
        final newAccessToken = await _tokenStore.readAccessToken();
        if (newAccessToken != null) {
          err.requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';

          // Replay request bằng Dio instance có interceptor
          if (_dio != null) {
            final response = await _dio!.fetch(err.requestOptions);
            return handler.resolve(response);
          } else {
            // Fallback nếu Dio chưa được set
            final response = await Dio().fetch(err.requestOptions);
            return handler.resolve(response);
          }
        } else {
          print('[AuthInterceptor] No access token after refresh');
        }
      } catch (refreshError) {
        print('[AuthInterceptor] Token refresh failed: $refreshError');
        // Refresh thất bại → clear token và gọi onUnauthorized
        await _handleRefreshFailure();
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: UnauthorizedException(
              requestOptions: err.requestOptions,
              data: err.response?.data,
            ),
          ),
        );
      }
    }

    // 2. Xử lý 401 từ refresh endpoint → không retry, coi như failed
    if (statusCode == 401 && _isRefreshPath(path)) {
      await _handleRefreshFailure();
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: UnauthorizedException(
            requestOptions: err.requestOptions,
            data: err.response?.data,
          ),
        ),
      );
    }

    // 3. Retry logic cho idempotent requests với lỗi tạm thời
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;
      if (retryCount < _maxRetries) {
        await _delayBeforeRetry(retryCount);

        err.requestOptions.extra['retryCount'] = retryCount + 1;
        try {
          if (_dio != null) {
            final response = await _dio!.fetch(err.requestOptions);
            return handler.resolve(response);
          } else {
            final response = await Dio().fetch(err.requestOptions);
            return handler.resolve(response);
          }
        } catch (retryError) {}
      }
    }

    // 4. Map DioException sang custom exceptions
    final customException = _mapToCustomException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        error: customException,
        type: err.type,
      ),
    );
  }

  // ==========================================================================
  // PRIVATE HELPER METHODS
  // ==========================================================================

  /// Xử lý refresh token với single-flight pattern.
  /// Nếu đang có refresh đang chạy, các request khác sẽ đợi.
  /// Điều này tránh race condition khi nhiều request cùng nhận 401.
  Future<void> _handleTokenRefresh() async {
    // Nếu đang có refresh đang chạy, đợi nó hoàn thành
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      return _refreshCompleter!.future;
    }

    // Tạo completer mới cho refresh này
    _refreshCompleter = Completer<void>();

    try {
      // Lấy refresh token từ store
      final refreshToken = await _tokenStore.readRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw UnauthorizedException(message: 'Không tìm thấy refresh token');
      }

      // Gọi API refresh token
      final tokens = await _authRemote.refreshToken(refreshToken);
      // Lưu token mới vào store
      await _tokenStore.saveAccessToken(tokens.accessToken);
      await _tokenStore.saveRefreshToken(tokens.refreshToken);

      _refreshCompleter!.complete();
    } catch (e) {
      _refreshCompleter!.completeError(e);
      rethrow;
    }
  }

  /// Clear token và gọi onUnauthorized callback (debounced).
  Future<void> _handleRefreshFailure() async {
    await _tokenStore.clear();

    // Debounce: chỉ gọi onUnauthorized 1 lần
    if (!_hasCalledUnauthorized) {
      _hasCalledUnauthorized = true;
      await _onUnauthorized();

      // Reset flag sau 2 giây để cho phép gọi lại nếu cần
      Future.delayed(const Duration(seconds: 2), () {
        _hasCalledUnauthorized = false;
      });
    }
  }

  /// Kiểm tra xem có nên retry request này không.
  /// Chỉ retry với:
  /// - Idempotent methods (GET, HEAD, OPTIONS)
  /// - Lỗi tạm thời (timeout, 5xx)
  bool _shouldRetry(DioException err) {
    final method = err.requestOptions.method.toUpperCase();
    final statusCode = err.response?.statusCode;

    // Chỉ retry idempotent methods
    if (!_retryIdempotentMethods.contains(method)) {
      return false;
    }

    // Retry với timeout errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return true;
    }

    // Retry với 5xx server errors
    if (statusCode != null && statusCode >= 500 && statusCode < 600) {
      return true;
    }

    return false;
  }

  /// Exponential backoff delay trước khi retry.
  /// Attempt 0: 200ms
  /// Attempt 1: 600ms
  /// Attempt 2: 1400ms
  Future<void> _delayBeforeRetry(int retryCount) async {
    final delayMs = 200 * (1 << retryCount) + 200 * retryCount;
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  /// Kiểm tra xem path có nằm trong danh sách excluded không.
  bool _isExcludedPath(String path) {
    return _paths.excludedPaths.any((excluded) => path.contains(excluded));
  }

  /// Kiểm tra xem path có phải là refresh endpoint không.
  bool _isRefreshPath(String path) {
    return path.contains(_paths.refreshPath);
  }

  /// Map DioException sang custom exceptions với message thân thiện.
  HttpException _mapToCustomException(DioException err) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;
    final requestOptions = err.requestOptions;

    // Extract message từ response nếu có
    String? extractedMessage;
    dynamic errors;
    int? responseStatusCode;

    if (data is Map<String, dynamic>) {
      // Kiểm tra nếu response đã có format ApiResponse
      if (data.containsKey('success') && data.containsKey('message')) {
        extractedMessage = data['message'] as String?;
        errors = data['errors'];
        responseStatusCode = data['statusCode'] as int?;
      } else {
        // Fallback cho response cũ
        extractedMessage = data['message'] as String? ??
            data['error'] as String? ??
            data['msg'] as String?;
        errors = data['errors'] ?? data['validation_errors'];
        responseStatusCode = statusCode;
      }
    }

    // Handle specific status codes
    if (statusCode == 400) {
      return BadRequestException(
        message: extractedMessage,
        requestOptions: requestOptions,
        data: errors ?? data,
      );
    } else if (statusCode == 401) {
      return UnauthorizedException(
        message: extractedMessage,
        requestOptions: requestOptions,
        data: errors ?? data,
      );
    } else if (statusCode == 403) {
      return ForbiddenException(
        message: extractedMessage,
        requestOptions: requestOptions,
        data: errors ?? data,
      );
    } else if (statusCode == 404) {
      return NotFoundException(
        message: extractedMessage,
        requestOptions: requestOptions,
        data: errors ?? data,
      );
    } else if (statusCode == 408) {
      return RequestTimeoutException(
        message: extractedMessage,
        requestOptions: requestOptions,
      );
    } else if (statusCode != null && statusCode >= 500 && statusCode < 600) {
      return ServerException(
        message: extractedMessage,
        statusCode: responseStatusCode ?? statusCode,
        requestOptions: requestOptions,
        data: errors ?? data,
      );
    }

    // Handle timeout errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return RequestTimeoutException(
        requestOptions: requestOptions,
      );
    }

    // Handle connection errors (có thể do network)
    if (err.type == DioExceptionType.connectionError) {
      return NoInternetException();
    }

    return UnknownHttpException(
      message: extractedMessage ?? err.message,
      statusCode: responseStatusCode ?? statusCode,
      requestOptions: requestOptions,
      data: errors ?? data,
    );
  }
}
