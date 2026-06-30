import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:nihonix/core/network/auth_interceptor.dart';
import 'package:nihonix/core/network/network_info.dart';
import 'package:nihonix/core/storage/token_store.dart';
import 'package:nihonix/features/auth/data/datasources/auth_remote_datasource.dart'
    as auth_ds;

class ApiClient {
  late final Dio dio;
  final TokenStore _tokenStore;

  ApiClient({
    required String baseUrl,
    required OnUnauthorized onUnauthorized,
    TokenStore? tokenStore,
    NetworkInfo? networkInfo,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 20),
  }) : _tokenStore = tokenStore ?? SecureTokenStore() {
    // 1. Tạo Dio riêng cho auth API (KHÔNG có AuthInterceptor)
    final authDio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    ));

    // 2. Tạo dependencies
    final authRemote = auth_ds.AuthRemoteDataSource.fromDio(authDio);
    final netInfo = networkInfo ?? ConnectivityNetworkInfo();

    // 3. Create Dio
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
    final authInterceptor = AuthInterceptor(
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
    );

    dio.interceptors.add(authInterceptor);

    // Set Dio instance sau khi thêm vào interceptors
    authInterceptor.setDio(dio);

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

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _tokenStore.saveAccessToken(accessToken);
    await _tokenStore.saveRefreshToken(refreshToken);
  }

  Future<void> clearTokens() async {
    await _tokenStore.clear();
  }

  Future<bool> get isAuthenticated async {
    final accessToken = await _tokenStore.readAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
}
