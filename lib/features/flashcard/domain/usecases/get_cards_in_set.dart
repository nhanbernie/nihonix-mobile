library;

import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

class GetCardsInSetUseCase {
  final FlashcardRepository _repository;

  GetCardsInSetUseCase(this._repository);

  Future<List<Flashcard>> call(String setId) async {
    if (setId.isEmpty) {
      throw ArgumentError('Set ID không được để trống');
    }

    return await _repository.getCardsInSet(setId);
  }
}
