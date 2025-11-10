library;

import 'dart:io';
import '../../domain/entities/update_profile_request.dart';
import '../../../auth/domain/entities/user.dart';

/// Domain Repository Interface
abstract class ProfileRepository {
  /// Update user profile
  /// 
  /// PUT /api/users/{id}
  /// 
  /// Returns updated User entity
  Future<User> updateProfile({
    required String userId,
    required UpdateProfileRequest request,
  });

  /// Upload user avatar
  /// 
  /// POST /api/users/me/avatar
  /// 
  /// Returns avatar URL
  Future<String> uploadAvatar({
    required File imageFile,
  });
}
