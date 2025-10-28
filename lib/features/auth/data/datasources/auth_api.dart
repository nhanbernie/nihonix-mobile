library;

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';

part 'auth_api.g.dart';

/// Retrofit sẽ auto generate implementation class _AuthApi.
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/auth/login')
  Future<LoginResponse> login(@Body() LoginRequest body);

  @POST('/auth/logout')
  Future<void> logout();

  @GET('/auth/me')
  Future<UserModel> getCurrentUser();

  @POST('/auth/register')
  Future<LoginResponse> register(@Body() Map<String, dynamic> body);

  @POST('/auth/forgot-password')
  Future<void> forgotPassword(@Body() Map<String, String> body);

  @POST('/auth/reset-password')
  Future<void> resetPassword(@Body() Map<String, String> body);

  @POST('/auth/refresh')
  Future<Map<String, String>> refreshToken(@Body() Map<String, String> body);
}
