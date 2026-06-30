library;

import '../repositories/flashcard_repository.dart';

class GenerateFlashcardUseCase {
  final FlashcardRepository _repository;

  GenerateFlashcardUseCase(this._repository);

  Future<String> call({
    required String folderId,
    required String setName,
    required String levelCode,
    required String difficulty,
    required String topic,
    required int count,
    String? customPrompt,
  }) async {
    if (folderId.isEmpty) {
      throw ArgumentError('Folder ID cannot be empty');
    }
    if (setName.trim().isEmpty) {
      throw ArgumentError('Set name cannot be empty');
    }
    if (levelCode.trim().isEmpty) {
      throw ArgumentError('Level code cannot be empty');
    }
    if (difficulty.trim().isEmpty) {
      throw ArgumentError('Difficulty cannot be empty');
    }
    if (topic.trim().isEmpty) {
      throw ArgumentError('Topic cannot be empty');
    }
    if (count <= 0) {
      throw ArgumentError('Count must be greater than 0');
    }

    return await _repository.generateFlashcard(
      folderId: folderId,
      setName: setName,
      levelCode: levelCode,
      difficulty: difficulty,
      topic: topic,
      count: count,
      customPrompt: customPrompt,
    );
  }
}
