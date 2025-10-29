library;

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/login_response.dart';
import '../models/user_model.dart';

part 'auth_api.g.dart';

/// Retrofit sẽ auto generate implementation class _AuthApi.
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/auth/register')
  Future<UserModel> register(@Body() Map<String, dynamic> body);

  @POST('/auth/login')
  Future<LoginResponse> login(@Body() Map<String, dynamic> body);

  @POST('/auth/refresh')
  Future<Map<String, String>> refreshToken(@Body() Map<String, String> body);

  @POST('/auth/logout')
  Future<Map<String, String>> logout(@Body() Map<String, String> body);

  @POST('/auth/me')
  Future<UserModel> getCurrentUser();

  @POST('/auth/forgot-password')
  Future<Map<String, String>> forgotPassword(@Body() Map<String, String> body);

  @POST('/auth/verify-reset-code')
  Future<Map<String, String>> verifyResetCode(@Body() Map<String, String> body);

  @POST('/auth/reset-password')
  Future<Map<String, String>> resetPassword(@Body() Map<String, String> body);

  @POST('/auth/resend-code')
  Future<Map<String, String>> resendCode(@Body() Map<String, String> body);
}
