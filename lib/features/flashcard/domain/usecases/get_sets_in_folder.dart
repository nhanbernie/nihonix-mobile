library;

import '../entities/flashcard_set.dart';
import '../repositories/flashcard_repository.dart';

class GetSetsInFolderUseCase {
  final FlashcardRepository _repository;

  GetSetsInFolderUseCase(this._repository);

  Future<List<FlashcardSet>> call(String folderId) async {
    if (folderId.isEmpty) {
      throw ArgumentError('Folder ID không được để trống');
    }

    return await _repository.getSetsInFolder(folderId);
  }
}
