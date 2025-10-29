import 'package:nihonix/features/auth/domain/entities/forgot_password_request.dart';
import 'package:nihonix/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<void> call(ForgotPasswordRequest request) async {
    await _repository.forgotPassword(email: request.email);
  }
}
