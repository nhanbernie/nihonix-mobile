import 'package:dio/dio.dart';
import '../../domain/entities/vocab_generate_result.dart';
import '../../domain/entities/vocab_item.dart';
import 'vocab_generate_api.dart';

class VocabGenerateRemoteDataSource {
  final VocabGenerateApi _api;

  VocabGenerateRemoteDataSource(this._api);

  Future<VocabGenerateResult> generateVocabularyItems({
    required String topicId,
    required String levelCode,
    required int count,
    String? customPrompt,
  }) async {
    try {
      final response = await _api.generateVocabularyItems({
        'topic_id': topicId,
        'level_code': levelCode,
        'count': count,
        if (customPrompt != null && customPrompt.isNotEmpty)
          'custom_prompt': customPrompt,
      });

      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;

      // Parse items
      final itemsList = data['items'] as List<dynamic>;
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

      return VocabGenerateResult(
        setId: data['set_id'] as String? ?? '',
        setSlug: data['set_slug'] as String? ?? '',
        setTitle: Map<String, String>.from(data['set_title'] as Map? ?? {}),
        topicId: data['topic_id'] as String? ?? '',
        levelCode: data['level_code'] as String? ?? '',
        requestedCount: data['requested_count'] as int? ?? 0,
        generatedCount: data['generated_count'] as int? ?? 0,
        items: items,
      );
    } on DioException catch (e) {
      throw Exception('Failed to generate vocabulary: ${e.message}');
    }
  }
}
