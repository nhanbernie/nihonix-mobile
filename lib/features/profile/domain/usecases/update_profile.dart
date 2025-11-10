library;

import '../entities/update_profile_request.dart';
import '../repositories/profile_repository.dart';
import '../../../auth/domain/entities/user.dart';

/// Use Case: Update User Profile
/// 
/// Business logic:
/// - Validate input data
/// - Call repository to update profile
/// - Return updated user
class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<User> call({
    required String userId,
    required UpdateProfileRequest request,
  }) async {
    // Business validation
    if (request.username?.isEmpty ?? false) {
      throw ArgumentError('Username cannot be empty');
    }
    
    if (request.email?.isEmpty ?? false) {
      throw ArgumentError('Email cannot be empty');
    }
    
    if (request.fullName?.isEmpty ?? false) {
      throw ArgumentError('Full name cannot be empty');
    }

    // Delegate to repository
    return await _repository.updateProfile(
      userId: userId,
      request: request,
    );
  }
}

