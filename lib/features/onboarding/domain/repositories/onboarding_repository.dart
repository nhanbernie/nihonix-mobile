abstract class OnboardingRepository {
  /// [levelCode] - The level code (BEGINNER, N5, N4, N3, N2, N1)
  Future<void> updateUserLevel(String levelCode);
}

