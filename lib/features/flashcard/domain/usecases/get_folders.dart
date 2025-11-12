library;

import '../entities/flashcard_folder.dart';
import '../repositories/flashcard_repository.dart';

class GetFoldersUseCase {
  final FlashcardRepository _repository;

  GetFoldersUseCase(this._repository);

  Future<List<FlashcardFolder>> call() async {
    return await _repository.getFolders();
  }
}
