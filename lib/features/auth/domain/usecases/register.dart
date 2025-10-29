import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// RegisterUseCase với Clean Architecture pattern.
///
/// Responsibilities:
/// - Validate input parameters
/// - Delegate business logic to AuthRepository
/// - Handle domain exceptions
/// - Return User entity (not Model)
///
/// Pattern 2025: Single responsibility, dependency injection via constructor.
class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  /// Register user với username, email, password và fullName.
  ///
  /// Parameters:
  /// - username: Tên đăng nhập (required, min 3 chars)
  /// - email: Email hợp lệ (required)
  /// - password: Mật khẩu (required, min 6 chars)
  /// - fullName: Tên đầy đủ (optional)
  ///
  /// Returns: User entity nếu thành công
  /// Throws: Domain exceptions nếu có lỗi
  Future<User> call({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    // Validate input parameters
    if (username.trim().isEmpty) {
      throw ArgumentError('Username không được để trống');
    }
    if (username.trim().length < 3) {
      throw ArgumentError('Username phải có ít nhất 3 ký tự');
    }
    if (email.trim().isEmpty) {
      throw ArgumentError('Email không được để trống');
    }
    if (!_isValidEmail(email.trim())) {
      throw ArgumentError('Email không hợp lệ');
    }
    if (password.isEmpty) {
      throw ArgumentError('Mật khẩu không được để trống');
    }
    if (password.length < 6) {
      throw ArgumentError('Mật khẩu phải có ít nhất 6 ký tự');
    }

    // Delegate to repository
    return await _repository.register(
      username: username.trim(),
      email: email.trim(),
      password: password,
      fullName: fullName?.trim(),
    );
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
