import 'package:dio/dio.dart';
import '../../domain/entities/vocab_folder.dart';
import 'vocab_set_api.dart';

class VocabSetRemoteDataSource {
  final VocabSetApi _api;

  VocabSetRemoteDataSource(this._api);

  Future<List<VocabFolder>> getVocabSetsByTopic(String topicId) async {
    try {
      final response = await _api.getVocabSetsByTopic(topicId);
      
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as List<dynamic>?;
      
      if (data == null) {
        return [];
      }
      
      // Map API response to VocabFolder
      return data.map((item) {
        final json = item as Map<String, dynamic>;
        final title = json['title'] as Map<String, dynamic>?;
        
        return VocabFolder(
          id: json['id'] as String? ?? '',
          name: title?['en'] as String? ?? title?['vi'] as String? ?? 'Untitled',
          topicName: '', // Not in API response
          wordCount: json['items_count'] as int? ?? 0,
          createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
          description: json['description'] as String?,
          isAiGenerated: true,
        );
      }).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch vocab sets: ${e.message}');
    }
  }
}

