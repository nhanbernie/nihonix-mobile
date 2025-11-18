import '../repositories/flashcard_repository.dart';
import '../../data/models/update_flashcard_request.dart';

class UpdateFlashcardUseCase {
  final FlashcardRepository _repository;

  UpdateFlashcardUseCase(this._repository);

  Future<String> call({
    required String setId,
    required String setName,
    required List<UpdateFlashcardCardRequest> cards,
  }) async {
    // Validation
    if (setId.isEmpty) {
      throw ArgumentError('Set ID cannot be empty');
    }

    if (setName.trim().isEmpty) {
      throw ArgumentError('Set name cannot be empty');
    }

    if (cards.isEmpty) {
      throw ArgumentError('Cards list cannot be empty');
    }

    // Validate each card
    for (var i = 0; i < cards.length; i++) {
      final card = cards[i];

      if (card.front.text.trim().isEmpty) {
        throw ArgumentError('Card ${i + 1}: Front text cannot be empty');
      }

      if (card.back.text.trim().isEmpty) {
        throw ArgumentError('Card ${i + 1}: Back text cannot be empty');
      }

      if (card.order < 1) {
        throw ArgumentError('Card ${i + 1}: Order must be at least 1');
      }
    }

    return await _repository.updateFlashcard(
      setId: setId,
      setName: setName,
      cards: cards,
    );
  }
}
