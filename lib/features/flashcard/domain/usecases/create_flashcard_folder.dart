library;

import '../entities/flashcard_folder.dart';
import '../repositories/flashcard_repository.dart';

class CreateFlashcardFolderUseCase {
  final FlashcardRepository _repository;

  CreateFlashcardFolderUseCase(this._repository);

  Future<FlashcardFolder> call({
    required String name,
    String? description,
    required int order,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Folder name cannot be empty');
    }

    if (order < 1) {
      throw ArgumentError('Order must be at least 1');
    }

    return await _repository.createFolder(
      name: name.trim(),
      description: description?.trim(),
      order: order,
    );
  }
}
