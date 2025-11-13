library;

import 'package:dio/dio.dart';
import 'flashcard_api.dart';
import '../models/create_folder_request.dart';
import '../models/create_folder_response.dart';
import '../models/flashcard_folder_model.dart';
import '../models/flashcard_set_model.dart';
import '../models/flashcard_model.dart';
import '../models/create_flashcard_request.dart';
import '../models/create_flashcard_response.dart';
import '../models/generate_flashcard_request.dart';
import '../models/update_flashcard_request.dart';

class FlashcardRemoteDataSource {
  final FlashcardApi _api;

  FlashcardRemoteDataSource(this._api);

  factory FlashcardRemoteDataSource.fromDio(Dio dio) {
    final api = FlashcardApi(dio);
    return FlashcardRemoteDataSource(api);
  }

  Future<CreateFolderResponse> createFolder({
    required String name,
    String? description,
    required int order,
  }) async {
    try {
      final request = CreateFolderRequest(
        name: name,
        description: description,
        order: order,
      );

      final response = await _api.createFolder(request);

      return response;
    } on DioException {
      // Rethrow Dio exception for repository to handle
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Get all folders
  Future<List<FlashcardFolderModel>> getFolders() async {
    try {
      final response = await _api.getFolders();
      return response.data;
    } on DioException {
      // Rethrow Dio exception for upstream handling
      rethrow;
    }
  }

  Future<FlashcardFolderModel> getFolderById(String id) async {
    try {
      final folder = await _api.getFolderById(id);
      return folder;
    } on DioException {
      rethrow;
    }
  }

  Future<FlashcardFolderModel> updateFolder({
    required String id,
    String? name,
    String? description,
    int? order,
  }) async {
    try {
      
      final request = <String, dynamic>{};
      if (name != null) request['name'] = name;
      if (description != null) request['description'] = description;
      if (order != null) request['order'] = order;
      final response = await _api.updateFolder(id, request);
      return response.data;
    } on DioException {
      rethrow;
    }
  }

  Future<void> deleteFolder(String id) async {
    try {
      await _api.deleteFolder(id);
    } on DioException {
      rethrow;
    }
  }

  /// Get all sets in a folder
  Future<List<FlashcardSetModel>> getSetsInFolder(String folderId) async {
    try {
      final response = await _api.getSetsInFolder(folderId);
      return response.data;
    } on DioException {
      rethrow;
    }
  }

  /// Get all cards in a set
  Future<List<FlashcardModel>> getCardsInSet(String setId) async {
    try {
      final response = await _api.getCardsInSet(setId);
      return response.data;
    } on DioException {
      rethrow;
    }
  }

  /// Delete a flashcard set
  Future<void> deleteFlashcardSet(String setId) async {
    try {
      await _api.deleteFlashcardSet(setId);
    } on DioException {
      rethrow;
    }
  }

  /// Create flashcard set with cards
  Future<CreateFlashcardResponse> createFlashcard({
    required String folderId,
    required String setName,
    required List<CardRequest> cards,
  }) async {
    try {
      final request = CreateFlashcardRequest(
        folderId: folderId,
        setName: setName,
        cards: cards,
      );
      final response = await _api.createFlashcard(request);
      return response;
    } on DioException {
      rethrow;
    }
  }

  /// Generate flashcard set with AI
  Future<CreateFlashcardResponse> generateFlashcard({
    required String folderId,
    required String setName,
    required String levelCode,
    required String difficulty,
    required String topic,
    required int count,
    String? customPrompt,
  }) async {
    try {
      final request = GenerateFlashcardRequest(
        folderId: folderId,
        setName: setName,
        levelCode: levelCode,
        difficulty: difficulty,
        topic: topic,
        count: count,
        customPrompt: customPrompt,
      );
      final response = await _api.generateFlashcard(request);
      return response;
    } on DioException {
      rethrow;
    }
  }

  /// Update flashcard set (can add/edit/delete cards in one request)
  Future<CreateFlashcardResponse> updateFlashcard({
    required String setId,
    required String setName,
    required List<UpdateFlashcardCardRequest> cards,
  }) async {
    try {
      final request = UpdateFlashcardRequest(
        setId: setId,
        setName: setName,
        cards: cards,
      );
      final response = await _api.updateFlashcard(request);
      return response;
    } on DioException {
      rethrow;
    }
  }
}
