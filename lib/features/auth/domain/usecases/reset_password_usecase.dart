import 'package:nihonix/features/auth/domain/entities/reset_password_request.dart';
import 'package:nihonix/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<void> call(ResetPasswordRequest request) async {
    await _repository.resetPassword(
      token: request.token,
      password: request.password,
    );
  }
}
