library;

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_response.dart';
import '../../../auth/data/models/user_model.dart';
import 'converters/user_api_response_converter.dart';

part 'onboarding_api.g.dart';

@RestApi()
abstract class OnboardingApi {
  factory OnboardingApi(Dio dio, {String? baseUrl}) = _OnboardingApi;

  @PATCH('/users/me/level')
  @UserApiResponseConverter()
  Future<ApiResponse<UserModel>> updateUserLevel(@Body() Map<String, String> body);
}

