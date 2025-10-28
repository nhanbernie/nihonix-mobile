library;

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/auth_interceptor.dart'
    show IAuthRefreshService;
import '../../../../core/network/http_exceptions.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';
import 'auth_api.dart';

part 'auth_remote_datasource.g.dart';

/// Riverpod Provider cho AuthRemoteDataSource.
/// Dependency injection: Auto inject Dio instance.
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  // TODO: Inject Dio instance from dioProvider
  // Example: final dio = ref.watch(dioProvider);
  throw UnimplementedError('Cần inject Dio instance từ DI container');
}

class AuthRemoteDataSource implements IAuthRefreshService {
  final AuthApi _api;

  AuthRemoteDataSource(this._api);

  /// Convenience constructor từ Dio.
  factory AuthRemoteDataSource.fromDio(Dio dio) {
    return AuthRemoteDataSource(AuthApi(dio));
  }

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      return await _api.login(request);
    } on DioException {
      // AuthInterceptor đã map errors sang custom exceptions
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _api.logout();
    } on DioException {
      rethrow;
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      return await _api.getCurrentUser();
    } on DioException {
      rethrow;
    }
  }

  Future<LoginResponse> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final body = {
        'email': email,
        'password': password,
        'name': name,
      };
      return await _api.register(body);
    } on DioException {
      rethrow;
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _api.forgotPassword({'email': email});
    } on DioException {
      rethrow;
    }
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _api.resetPassword({
        'token': token,
        'new_password': newPassword,
      });
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<({String accessToken, String refreshToken})> refreshToken(
    String refreshToken,
  ) async {
    try {
      final response = await _api.refreshToken({
        'refresh_token': refreshToken,
      });

      return (
        accessToken: response['access_token']!,
        refreshToken: response['refresh_token']!,
      );
    } on DioException catch (e) {
      // Nếu refresh thất bại, throw UnauthorizedException
      throw UnauthorizedException(
        message: 'Không thể làm mới phiên đăng nhập',
        requestOptions: e.requestOptions,
        data: e.response?.data,
      );
    }
  }
}
