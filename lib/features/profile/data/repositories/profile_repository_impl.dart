library;

import 'dart:io';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/update_profile_request.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/update_profile_request_model.dart';

/// Repository Implementation
/// 
/// Implements ProfileRepository interface
/// Delegates to ProfileRemoteDataSource
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<User> updateProfile({
    required String userId,
    required UpdateProfileRequest request,
  }) async {
    try {
      // Convert domain entity to data model
      final requestModel = UpdateProfileRequestModel.fromDomain(request);

      // Call remote data source
      final response = await _remoteDataSource.updateProfile(
        userId: userId,
        request: requestModel,
      );

      // Convert data model to domain entity
      return response.user.toDomain();
    } catch (e) {
      print('❌ [ProfileRepository] Error updating profile: $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadAvatar({
    required File imageFile,
  }) async {
    try {
      // Call remote data source
      final response = await _remoteDataSource.uploadAvatar(
        imageFile: imageFile,
      );

      // Return avatar URL
      return response.avatarUrl;
    } catch (e) {
      print('❌ [ProfileRepository] Error uploading avatar: $e');
      rethrow;
    }
  }
}
