/// CONTRACT  giữa Domain và Data layer.
library;

import 'package:nihonix/features/auth/domain/entities/user.dart';

/// Pattern: Repository Pattern
/// - Trừu tượng hóa data source (API, Local Storage...)
/// - Domain layer chỉ biết "cái gì", không biết "làm thế nào"
/// - Cho phép swap implementation dễ dàng (mock cho testing, API khác...)
abstract class AuthRepository {
  /// Returns:
  /// - Success: [User] object
  /// - Failure: Throw exception (UnauthorizedException, NoInternetException...)
  ///
  /// Exceptions:
  /// - [UnauthorizedException]: Sai email/password
  /// - [NoInternetException]: Không có internet
  /// - [ServerException]: Lỗi server
  Future<User> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<User?> getCurrentUser();

  Future<bool> isLoggedIn();

  Future<User> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  });

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });
}
