/// CONTRACT  giữa Domain và Data layer.
library;

import 'package:nihonix/features/auth/domain/entities/user.dart';
import 'package:nihonix/features/auth/domain/entities/login_result.dart';

abstract class AuthRepository {
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
