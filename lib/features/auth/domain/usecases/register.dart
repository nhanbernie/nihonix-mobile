import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<User> call({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
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

    return await _repository.register(
      username: username.trim(),
      email: email.trim(),
      password: password,
      fullName: fullName?.trim(),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
