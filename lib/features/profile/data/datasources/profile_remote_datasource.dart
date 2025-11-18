library;

import 'dart:io';
import 'package:dio/dio.dart';
import 'profile_api.dart';
import '../models/update_profile_request_model.dart';
import '../models/update_profile_response.dart';
import '../models/upload_avatar_response.dart';

/// Remote DataSource for Profile
///
/// Wrapper around ProfileApi to handle:
/// - API calls
/// - Response parsing
/// - Error handling
class ProfileRemoteDataSource {
  final ProfileApi _api;
  final Dio _dio;

  ProfileRemoteDataSource(this._api, this._dio);

  /// Factory constructor from Dio instance
  factory ProfileRemoteDataSource.fromDio(Dio dio) {
    final api = ProfileApi(dio);
    return ProfileRemoteDataSource(api, dio);
  }

  /// Update user profile
  Future<UpdateProfileResponse> updateProfile({
    required String userId,
    required UpdateProfileRequestModel request,
  }) async {
    try {
      final response = await _api.updateProfile(userId, request);

      // Parse response
      final updateProfileResponse = UpdateProfileResponse.fromJson(
        response as Map<String, dynamic>,
      );

      return updateProfileResponse;
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<UploadAvatarResponse> uploadAvatar({
    required File imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        '/users/me/avatar',
        data: formData,
      );

      final uploadResponse = UploadAvatarResponse.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      return uploadResponse;
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
