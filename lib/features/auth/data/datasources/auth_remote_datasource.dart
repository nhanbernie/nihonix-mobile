import 'package:dio/dio.dart';
import 'package:nihonix/core/network/auth_interceptor.dart';
import 'package:nihonix/core/network/http_exceptions.dart';

/// Implementation của AuthRemoteDataSource để gọi API refresh token.
///
/// Lưu ý: Dio instance này KHÔNG được có AuthInterceptor để tránh vòng lặp.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<({String accessToken, String refreshToken})> refreshToken(
    String refreshToken,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      // Parse response theo format API của bạn
      final data = response.data as Map<String, dynamic>;

      return (
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
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
