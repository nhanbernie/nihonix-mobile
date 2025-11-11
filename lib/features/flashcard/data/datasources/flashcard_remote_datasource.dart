library;

import 'package:dio/dio.dart';
import 'flashcard_api.dart';
import '../models/create_folder_request.dart';
import '../models/create_folder_response.dart';
import '../models/flashcard_folder_model.dart';

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
      print('🔵 [FlashcardDataSource] Calling API createFolder');
      print('🔵 [FlashcardDataSource] Request: name=$name, description=$description, order=$order');

      final request = CreateFolderRequest(
        name: name,
        description: description,
        order: order,
      );

      final response = await _api.createFolder(request);

      print('✅ [FlashcardDataSource] API call successful');
      print('✅ [FlashcardDataSource] Response: ${response.toJson()}');

      return response;
    } on DioException catch (e) {
      print('❌ [FlashcardDataSource] DioException: ${e.message}');
      print('❌ [FlashcardDataSource] Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('❌ [FlashcardDataSource] Unexpected error: $e');
      rethrow;
    }
  }

  /// Get all folders
  Future<List<FlashcardFolderModel>> getFolders() async {
    try {
      print('🔵 [FlashcardDataSource] Calling API getFolders');
      
      final response = await _api.getFolders();

      print('✅ [FlashcardDataSource] Got ${response.data.length} folders');

      return response.data;
    } on DioException catch (e) {
      print('❌ [FlashcardDataSource] DioException: ${e.message}');
      rethrow;
    }
  }

  Future<FlashcardFolderModel> getFolderById(String id) async {
    try {
      print('🔵 [FlashcardDataSource] Calling API getFolderById: $id');
      
      final folder = await _api.getFolderById(id);

      print('✅ [FlashcardDataSource] Got folder: ${folder.name}');

      return folder;
    } on DioException catch (e) {
      print('❌ [FlashcardDataSource] DioException: ${e.message}');
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
      print('🔵 [FlashcardDataSource] Calling API updateFolder: $id');
      
      final request = <String, dynamic>{};
      if (name != null) request['name'] = name;
      if (description != null) request['description'] = description;
      if (order != null) request['order'] = order;

      final folder = await _api.updateFolder(id, request);

      print('✅ [FlashcardDataSource] Folder updated');

      return folder;
    } on DioException catch (e) {
      print('❌ [FlashcardDataSource] DioException: ${e.message}');
      rethrow;
    }
  }

  Future<void> deleteFolder(String id) async {
    try {
      print('🔵 [FlashcardDataSource] Calling API deleteFolder: $id');
      
      await _api.deleteFolder(id);

      print('✅ [FlashcardDataSource] Folder deleted');
    } on DioException catch (e) {
      print('❌ [FlashcardDataSource] DioException: ${e.message}');
      rethrow;
    }
  }
}
