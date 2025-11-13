library;

import '../entities/flashcard_folder.dart';
import '../entities/flashcard_set.dart';
import '../entities/flashcard.dart';
import '../../data/models/create_flashcard_request.dart';
import '../../data/models/update_flashcard_request.dart';

abstract class FlashcardRepository {
  Future<FlashcardFolder> createFolder({
    required String name,
    String? description,
    required int order,
  });

  Future<List<FlashcardFolder>> getFolders();

  Future<FlashcardFolder> getFolderById(String id);

  Future<FlashcardFolder> updateFolder({
    required String id,
    String? name,
    String? description,
    int? order,
  });

  Future<void> deleteFolder(String id);

  Future<List<FlashcardSet>> getSetsInFolder(String folderId);

  Future<List<Flashcard>> getCardsInSet(String setId);

  Future<void> deleteFlashcardSet(String setId);

  Future<String> createFlashcard({
    required String folderId,
    required String setName,
    required List<CardRequest> cards,
  });

  Future<String> generateFlashcard({
    required String folderId,
    required String setName,
    required String levelCode,
    required String difficulty,
    required String topic,
    required int count,
    String? customPrompt,
  });

  Future<String> updateFlashcard({
    required String setId,
    required String setName,
    required List<UpdateFlashcardCardRequest> cards,
  });
}
