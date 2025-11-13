import 'package:dio/dio.dart';
import '../../domain/entities/vocab_folder.dart';
import '../../domain/entities/vocab_set_detail.dart';
import '../../domain/entities/vocab_item.dart';
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

  Future<VocabSetDetail> getVocabSetById(String id) async {
    try {
      final response = await _api.getVocabSetById(id);
      
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;
      
      // Parse topic
      final topicJson = data['topic'] as Map<String, dynamic>;
      final topic = VocabSetTopic(
        id: topicJson['id'] as String? ?? '',
        slug: topicJson['slug'] as String? ?? '',
        levelCode: topicJson['level_code'] as String? ?? '',
        title: Map<String, String>.from(topicJson['title'] as Map? ?? {}),
        iconSvg: topicJson['icon_svg'] as String?,
        iconType: topicJson['icon_type'] as String? ?? '',
        iconCode: topicJson['icon_code'] as int?,
        order: topicJson['order'] as int? ?? 0,
      );
      
      // Parse items
      final itemsList = data['items'] as List<dynamic>? ?? [];
      final items = itemsList.map((item) {
        final json = item as Map<String, dynamic>;
        
        // Parse examples
        final examplesList = json['examples'] as List<dynamic>? ?? [];
        final examples = examplesList.map((ex) {
          final exJson = ex as Map<String, dynamic>;
          return VocabExample(
            sentenceJp: exJson['sentence_jp'] as String? ?? '',
            sentenceRomaji: exJson['sentence_romaji'] as String? ?? '',
            sentenceVi: exJson['sentence_vi'] as String? ?? '',
            sentenceEn: exJson['sentence_en'] as String? ?? '',
          );
        }).toList();

        return VocabItem(
          slug: json['slug'] as String? ?? '',
          vocabularySetId: json['vocabulary_set_id'] as String? ?? '',
          levelCode: json['level_code'] as String? ?? '',
          romaji: json['romaji'] as String? ?? '',
          kanji: json['kanji'] as String? ?? '',
          kana: json['kana'] as String? ?? '',
          meaning: Map<String, String>.from(json['meaning'] as Map? ?? {}),
          wordType: json['word_type'] as String? ?? '',
          title: json['title'] as String?,
          examples: examples,
          order: json['order'] as int? ?? 0,
        );
      }).toList();
      
      return VocabSetDetail(
        id: data['id'] as String? ?? '',
        topicId: data['topic_id'] as String? ?? '',
        slug: data['slug'] as String? ?? '',
        title: Map<String, String>.from(data['title'] as Map? ?? {}),
        description: data['description'] as String?,
        order: data['order'] as int? ?? 0,
        createdAt: DateTime.tryParse(data['created_at'] as String? ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(data['updated_at'] as String? ?? '') ?? DateTime.now(),
        topic: topic,
        items: items,
      );
    } on DioException catch (e) {
      throw Exception('Failed to fetch vocab set detail: ${e.message}');
    }
  }
}

