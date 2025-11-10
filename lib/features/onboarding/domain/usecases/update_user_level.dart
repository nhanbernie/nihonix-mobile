import '../repositories/onboarding_repository.dart';

class UpdateUserLevel {
  final OnboardingRepository repository;

  UpdateUserLevel(this.repository);
  /// Returns Future<void> on success
  /// Throws exception on failure
  Future<void> call(String levelCode) async {
    return await repository.updateUserLevel(levelCode);
  }
}

