library;

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
}

