import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:nihonix/core/network/auth_interceptor.dart';
import 'package:nihonix/core/network/network_info.dart';
import 'package:nihonix/core/storage/token_store.dart';
import 'package:nihonix/features/auth/data/datasources/auth_remote_datasource.dart';

/// API Client chính của app với AuthInterceptor đã được cấu hình.
///
/// Sử dụng:
/// ```dart
/// final apiClient = ApiClient(
///   baseUrl: 'https://api.example.com',
///   onUnauthorized: () async => navigateToLogin(),
/// );
///
/// // Gọi API
/// final response = await apiClient.dio.get('/users/me');
/// ```
class ApiClient {
  late final Dio dio;
  final HiveTokenStore _tokenStore;

  ApiClient({
    required String baseUrl,
    required OnUnauthorized onUnauthorized,
    HiveTokenStore? tokenStore,
    NetworkInfo? networkInfo,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 20),
  }) : _tokenStore = tokenStore ?? HiveTokenStore() {
    // 1. Tạo Dio riêng cho auth API (KHÔNG có AuthInterceptor)
    final authDio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    ));

    // 2. Tạo dependencies
    final authRemote = AuthRemoteDataSourceImpl(authDio);
    final netInfo = networkInfo ?? ConnectivityNetworkInfo();

    // 3. Tạo Dio chính với AuthInterceptor
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // 4. Thêm AuthInterceptor
    dio.interceptors.add(
      AuthInterceptor(
        tokenStore: _tokenStore,
        networkInfo: netInfo,
        authRemote: authRemote,
        onUnauthorized: onUnauthorized,
        paths: AuthPathsConfig(
          excludedPaths: [
            '/auth/login',
            '/auth/register',
            '/auth/refresh',
            '/public',
          ],
          refreshPath: '/auth/refresh',
        ),
      ),
    );

    // 5. Thêm logging trong debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }

  /// Lưu tokens sau khi login thành công
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _tokenStore.saveAccessToken(accessToken);
    await _tokenStore.saveRefreshToken(refreshToken);
  }

  /// Clear tokens khi logout
  Future<void> clearTokens() async {
    await _tokenStore.clear();
  }

  /// Kiểm tra xem user đã login chưa
  Future<bool> get isAuthenticated async {
    final accessToken = await _tokenStore.readAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
}
