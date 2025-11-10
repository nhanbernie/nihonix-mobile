library;

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'onboarding_api.g.dart';

@RestApi()
abstract class OnboardingApi {
  factory OnboardingApi(Dio dio, {String? baseUrl}) = _OnboardingApi;

  @PATCH('/users/me/level')
  Future<void> updateUserLevel(@Body() Map<String, String> body);
}

