library;

import '../repositories/flashcard_repository.dart';
import '../../data/models/create_flashcard_request.dart';

class CreateFlashcardUseCase {
  final FlashcardRepository _repository;

  CreateFlashcardUseCase(this._repository);

  Future<String> call({
    required String folderId,
    required String setName,
    required List<CardRequest> cards,
  }) async {
    if (folderId.isEmpty) {
      throw ArgumentError('Folder ID cannot be empty');
    }
    if (setName.trim().isEmpty) {
      throw ArgumentError('Set name cannot be empty');
    }
    if (cards.isEmpty) {
      throw ArgumentError('Cards list cannot be empty');
    }

    return await _repository.createFlashcard(
      folderId: folderId,
      setName: setName,
      cards: cards,
    );
  }
}
