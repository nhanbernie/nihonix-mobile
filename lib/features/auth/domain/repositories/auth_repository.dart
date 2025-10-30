/// CONTRACT  giữa Domain và Data layer.
library;

import 'package:nihonix/features/auth/domain/entities/user.dart';
import 'package:nihonix/features/auth/domain/entities/login_result.dart';

/// Pattern: Repository Pattern
/// - Trừu tượng hóa data source (API, Local Storage...)
/// - Domain layer chỉ biết "cái gì", không biết "làm thế nào"
/// - Cho phép swap implementation dễ dàng (mock cho testing, API khác...)
abstract class AuthRepository {
  /// Returns:
  /// - Success: [LoginResult] object với user và accessToken
  /// - Failure: Throw exception (UnauthorizedException, NoInternetException...)
  ///
  /// Exceptions:
  /// - [UnauthorizedException]: Sai email/password
  /// - [NoInternetException]: Không có internet
  /// - [ServerException]: Lỗi server
  Future<LoginResult> login({
    required String username,
    required String password,
  });

  Future<void> logout({required String refreshToken});

  Future<User?> getCurrentUser();

  Future<bool> isLoggedIn();

  Future<User> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  });

  Future<void> forgotPassword({required String email});

  Future<Map<String, dynamic>> verifyResetCode({required String code});

  Future<void> resetPassword({
    required String token,
    required String password,
  });

  Future<void> resendCode({required String email});
}
