import '../../../auth/domain/entities/user.dart';

abstract class OnboardingRepository {
  /// [levelCode] - The level code (BEGINNER, N5, N4, N3, N2, N1)
  /// Returns updated User object
  Future<User> updateUserLevel(String levelCode);
}

