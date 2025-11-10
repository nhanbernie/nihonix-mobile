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
      print('🔵 [ProfileDataSource] Calling API updateProfile');
      print('🔵 [ProfileDataSource] User ID: $userId');
      print('🔵 [ProfileDataSource] Request: ${request.toJson()}');

      final response = await _api.updateProfile(userId, request);

      print('✅ [ProfileDataSource] API call successful');
      print('✅ [ProfileDataSource] Response: $response');

      // Parse response
      final updateProfileResponse = UpdateProfileResponse.fromJson(
        response as Map<String, dynamic>,
      );

      return updateProfileResponse;
    } on DioException catch (e) {
      print('❌ [ProfileDataSource] DioException: ${e.message}');
      print('❌ [ProfileDataSource] Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('❌ [ProfileDataSource] Unexpected error: $e');
      rethrow;
    }
  }

  /// Upload user avatar
  Future<UploadAvatarResponse> uploadAvatar({
    required File imageFile,
  }) async {
    try {
      print('🔵 [ProfileDataSource] Calling API uploadAvatar');
      print('🔵 [ProfileDataSource] Image path: ${imageFile.path}');

      // Create FormData with avatar file
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      // Call API using Dio directly
      final response = await _dio.post(
        '/users/me/avatar',
        data: formData,
      );

      print('✅ [ProfileDataSource] Avatar uploaded successfully');
      print('✅ [ProfileDataSource] Response: ${response.data}');

      // Parse response
      final uploadResponse = UploadAvatarResponse.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      print('✅ [ProfileDataSource] Avatar URL: ${uploadResponse.avatarUrl}');

      return uploadResponse;
    } on DioException catch (e) {
      print('❌ [ProfileDataSource] DioException: ${e.message}');
      print('❌ [ProfileDataSource] Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('❌ [ProfileDataSource] Unexpected error: $e');
      rethrow;
    }
  }
}
