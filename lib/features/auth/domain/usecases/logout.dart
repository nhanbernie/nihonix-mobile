library;

import 'package:nihonix/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<void> call({required String refreshToken}) async {
    await _repository.logout(refreshToken: refreshToken);
  }
}
