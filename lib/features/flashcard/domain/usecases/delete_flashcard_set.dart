library;

import '../repositories/flashcard_repository.dart';

class DeleteFlashcardSetUseCase {
  final FlashcardRepository _repository;

  DeleteFlashcardSetUseCase(this._repository);

  Future<void> call(String setId) async {
    if (setId.isEmpty) {
      throw ArgumentError('Set ID cannot be empty');
    }

    return await _repository.deleteFlashcardSet(setId);
  }
}
