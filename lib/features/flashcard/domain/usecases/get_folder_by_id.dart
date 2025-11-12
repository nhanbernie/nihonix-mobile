library;

import '../entities/flashcard_folder.dart';
import '../repositories/flashcard_repository.dart';

class GetFolderByIdUseCase {
  final FlashcardRepository _repository;

  GetFolderByIdUseCase(this._repository);

  Future<FlashcardFolder> call(String folderId) async {
    if (folderId.isEmpty) {
      throw ArgumentError('Folder ID không được để trống');
    }

    return await _repository.getFolderById(folderId);
  }
}
