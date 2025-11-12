library;

import 'package:dio/dio.dart';
import 'flashcard_api.dart';
import '../models/create_folder_request.dart';
import '../models/create_folder_response.dart';
import '../models/flashcard_folder_model.dart';
import '../models/flashcard_set_model.dart';
import '../models/flashcard_model.dart';

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
}
