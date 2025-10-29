library;

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/auth_interceptor.dart'
    show IAuthRefreshService;
import '../../../../core/network/http_exceptions.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';
import '../models/reset_password_request.dart';
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

  // NOTE: nó tự động fromJson ở đây
  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      return await _api.login({
        'username': username,
        'password': password,
      });
    } on DioException {
      // AuthInterceptor đã map errors sang custom exceptions
      rethrow;
    }
  }

  Future<void> logout({required String refreshToken}) async {
    try {
      await _api.logout({'refreshToken': refreshToken});
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

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final body = {
        'username': username,
        'email': email,
        'password': password,
        if (fullName != null) 'full_name': fullName,
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

  Future<Map<String, dynamic>> verifyResetCode({required String code}) async {
    try {
      final response = await _api.verifyResetCode({'code': code});
      return {
        'valid': response.valid,
        'token': response.token,
      };
    } on DioException {
      rethrow;
    }
  }

  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    try {
      await _api.resetPassword(ResetPasswordRequest(
        token: token,
        password: password,
      ));
    } on DioException {
      rethrow;
    }
  }

  Future<void> resendCode({required String email}) async {
    try {
      await _api.resendCode({'email': email});
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
        'refreshToken': refreshToken,
      });

      return (
        accessToken: response['accessToken'] as String,
        refreshToken: response['refreshToken'] as String,
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
