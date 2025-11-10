library;

import 'package:dio/dio.dart';
import 'profile_api.dart';
import '../models/update_profile_request_model.dart';
import '../models/update_profile_response.dart';

/// Remote DataSource for Profile
/// 
/// Wrapper around ProfileApi to handle:
/// - API calls
/// - Response parsing
/// - Error handling
class ProfileRemoteDataSource {
  final ProfileApi _api;

  ProfileRemoteDataSource(this._api);

  /// Factory constructor from Dio instance
  factory ProfileRemoteDataSource.fromDio(Dio dio) {
    final api = ProfileApi(dio);
    return ProfileRemoteDataSource(api);
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
}

