library;

import 'package:nihonix/features/auth/domain/entities/login_result.dart';
import 'package:nihonix/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<LoginResult> call({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      throw ArgumentError('Username và password không được để trống');
    }

    if (password.length < 6) {
      throw ArgumentError('Mật khẩu phải có ít nhất 6 ký tự');
    }

    return await _repository.login(
      username: username.trim(),
      password: password,
    );
  }
}
