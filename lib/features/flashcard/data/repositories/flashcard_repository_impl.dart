library;

import '../../domain/entities/flashcard_folder.dart';
import '../../domain/entities/flashcard_set.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../datasources/flashcard_remote_datasource.dart';
import '../models/create_flashcard_request.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  final FlashcardRemoteDataSource _remoteDataSource;

  FlashcardRepositoryImpl({
    required FlashcardRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<FlashcardFolder> createFolder({
    required String name,
    String? description,
    required int order,
  }) async {
    try {
      final response = await _remoteDataSource.createFolder(
        name: name,
        description: description,
        order: order,
      );

      // Convert data model to domain entity
      return response.data.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<FlashcardFolder>> getFolders() async {
    try {
      final folders = await _remoteDataSource.getFolders();
      return folders.map((model) => model.toDomain()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FlashcardFolder> getFolderById(String id) async {
    try {
      final folder = await _remoteDataSource.getFolderById(id);
      return folder.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FlashcardFolder> updateFolder({
    required String id,
    String? name,
    String? description,
    int? order,
  }) async {
    try {
      final folder = await _remoteDataSource.updateFolder(
        id: id,
        name: name,
        description: description,
        order: order,
      );
      return folder.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteFolder(String id) async {
    try {
      await _remoteDataSource.deleteFolder(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<FlashcardSet>> getSetsInFolder(String folderId) async {
    try {
      final sets = await _remoteDataSource.getSetsInFolder(folderId);
      return sets.map((model) => model.toDomain()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Flashcard>> getCardsInSet(String setId) async {
    try {
      final cards = await _remoteDataSource.getCardsInSet(setId);
      return cards.map((model) => model.toDomain()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteFlashcardSet(String setId) async {
    try {
      await _remoteDataSource.deleteFlashcardSet(setId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> createFlashcard({
    required String folderId,
    required String setName,
    required List<CardRequest> cards,
  }) async {
    try {
      final response = await _remoteDataSource.createFlashcard(
        folderId: folderId,
        setName: setName,
        cards: cards,
      );
      
      // Return setId for further use
      return response.data.setId;
    } catch (e) {
      rethrow;
    }
  }
}
