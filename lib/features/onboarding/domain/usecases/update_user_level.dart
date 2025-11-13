import '../../../auth/domain/entities/user.dart';
import '../repositories/onboarding_repository.dart';

class UpdateUserLevel {
  final OnboardingRepository repository;

  UpdateUserLevel(this.repository);
  
  /// Returns updated User object on success
  /// Throws exception on failure
  Future<User> call(String levelCode) async {
    return await repository.updateUserLevel(levelCode);
  }
}

