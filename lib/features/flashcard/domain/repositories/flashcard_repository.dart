library;

import '../entities/flashcard_folder.dart';
import '../entities/flashcard_set.dart';

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
}
