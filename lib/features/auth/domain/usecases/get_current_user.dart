library;

import 'package:nihonix/features/auth/domain/entities/user.dart';
import 'package:nihonix/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<User?> call() async {
    return await _repository.getCurrentUser();
  }
}
