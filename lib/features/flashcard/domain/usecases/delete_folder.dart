library;

import '../repositories/flashcard_repository.dart';

class DeleteFolderUseCase {
  final FlashcardRepository _repository;

  DeleteFolderUseCase(this._repository);

  Future<void> call(String folderId) async {
    if (folderId.isEmpty) {
      throw ArgumentError('Folder ID không được để trống');
    }

    return await _repository.deleteFolder(folderId);
  }
}
