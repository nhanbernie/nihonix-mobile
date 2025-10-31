import 'package:nihonix/features/auth/domain/entities/verify_code_request.dart';
import 'package:nihonix/features/auth/domain/repositories/auth_repository.dart';

class VerifyCodeUseCase {
  final AuthRepository _repository;

  VerifyCodeUseCase(this._repository);

  Future<Map<String, dynamic>> call(VerifyCodeRequest request) async {
    final result = await _repository.verifyResetCode(
      code: request.code,
    );

    return result;
  }
}
