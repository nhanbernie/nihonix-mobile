library;

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/update_profile_request_model.dart';

part 'profile_api.g.dart';

@RestApi()
abstract class ProfileApi {
  factory ProfileApi(Dio dio, {String? baseUrl}) = _ProfileApi;

  @PUT('/users/{id}')
  Future<dynamic> updateProfile(
    @Path('id') String userId,
    @Body() UpdateProfileRequestModel request,
  );

  // Upload avatar - using FormData directly via Dio
  // Not using @POST annotation because Retrofit doesn't support MultipartFile well
}
