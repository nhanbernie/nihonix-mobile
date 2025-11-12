library;

import '../entities/flashcard_folder.dart';
import '../repositories/flashcard_repository.dart';

class UpdateFolderUseCase {
  final FlashcardRepository _repository;

  UpdateFolderUseCase(this._repository);

  Future<FlashcardFolder> call({
    required String id,
    String? name,
    String? description,
    int? order,
  }) async {
    if (id.isEmpty) {
      throw ArgumentError('Folder ID không được để trống');
    }

    if (name != null && name.trim().isEmpty) {
      throw ArgumentError('Tên folder không được để trống');
    }

    return await _repository.updateFolder(
      id: id,
      name: name?.trim(),
      description: description?.trim(),
      order: order,
    );
  }
}
