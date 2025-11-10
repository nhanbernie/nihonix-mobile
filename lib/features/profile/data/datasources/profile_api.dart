library;

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/update_profile_request_model.dart';

part 'profile_api.g.dart';

/// Retrofit API Client for Profile endpoints
@RestApi()
abstract class ProfileApi {
  factory ProfileApi(Dio dio, {String? baseUrl}) = _ProfileApi;

  /// Update user profile
  /// 
  /// PUT /users/{id}
  @PUT('/users/{id}')
  Future<dynamic> updateProfile(
    @Path('id') String userId,
    @Body() UpdateProfileRequestModel request,
  );
}

