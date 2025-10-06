library;

import 'package:nihonix/features/auth/domain/entities/user.dart';
import 'package:nihonix/features/auth/domain/repositories/auth_repository.dart';

/// Use Case: Thực hiện login operation.
/// Responsibility:
/// - Validate input (nếu cần business validation)
/// - Gọi repository để thực hiện login
/// - Transform data nếu cần
/// - Return result hoặc throw exception
///
/// Pattern: Callable class với operator call()
class LoginUseCase {
  final AuthRepository _repository;

  /// Constructor injection - nhận repository từ DI container.
  LoginUseCase(this._repository);

  /// Execute login operation.
  ///
  /// Pattern: operator call() cho phép gọi class như function:
  /// ```dart
  /// final loginUseCase = LoginUseCase(repository);
  /// final user = await loginUseCase(email: 'a@b.com', password: '123');
  /// // Thay vì: await loginUseCase.execute(...)
  /// ```
  ///
  /// Parameters:
  /// - [email]: Email address
  /// - [password]: Plain text password (sẽ được hash ở backend)
  ///
  /// Returns: [User] object nếu thành công
  ///
  /// Throws:
  /// - [UnauthorizedException]: Sai credentials
  /// - [NoInternetException]: Không có internet
  /// - [ServerException]: Lỗi server
  Future<User> call({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email và password không được để trống');
    }

    if (!email.contains('@')) {
      throw ArgumentError('Email không hợp lệ');
    }

    if (password.length < 6) {
      throw ArgumentError('Mật khẩu phải có ít nhất 6 ký tự');
    }

    return await _repository.login(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }
}
