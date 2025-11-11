library;

import '../../domain/entities/flashcard_folder.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../datasources/flashcard_remote_datasource.dart';

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
}
