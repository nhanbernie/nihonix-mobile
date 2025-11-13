import 'package:dio/dio.dart';
import '../../domain/entities/grammar_generate_result.dart';
import 'grammar_generate_api.dart';

class GrammarGenerateRemoteDataSource {
  final GrammarGenerateApi _api;

  GrammarGenerateRemoteDataSource(this._api);

  Future<GrammarGenerateResult> generateGrammarPatterns({
    required String grammarSubTopicSlug,
    required String levelCode,
    required int count,
    String? customPrompt,
  }) async {
    try {
      final response = await _api.generateGrammarPatterns(
        body: {
          'grammar_sub_topic_slug': grammarSubTopicSlug,
          'level_code': levelCode,
          'count': count,
          if (customPrompt != null && customPrompt.isNotEmpty)
            'custom_prompt': customPrompt,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;

      // Parse patterns
      final patternsList = data['patterns'] as List<dynamic>? ?? [];
      final patterns = patternsList.map((item) {
        final json = item as Map<String, dynamic>;

        // Parse usage examples
        final examplesList = json['usage_examples'] as List<dynamic>? ?? [];
        final examples = examplesList.map((ex) {
          final exJson = ex as Map<String, dynamic>;
          return GeneratedExample(
            sentenceJp: exJson['sentence_jp'] as String? ?? '',
            sentenceRomaji: exJson['sentence_romaji'] as String? ?? '',
            sentenceVi: exJson['sentence_vi'] as String? ?? '',
            sentenceEn: exJson['sentence_en'] as String? ?? '',
          );
        }).toList();

        return GrammarPatternGenerated(
          slug: json['slug'] as String? ?? '',
          grammarSubTopicSlug: json['grammar_sub_topic_slug'] as String? ?? '',
          topicSlug: json['topic_slug'] as String? ?? '',
          levelCode: json['level_code'] as String? ?? '',
          patternJp: json['pattern_jp'] as String? ?? '',
          patternRomaji: json['pattern_romaji'] as String? ?? '',
          explanation: Map<String, String>.from(json['explanation'] as Map? ?? {}),
          usageExamples: examples,
          conjugationRules: Map<String, dynamic>.from(json['conjugation_rules'] as Map? ?? {}),
          levelDifficulty: json['level_difficulty'] as String? ?? '',
          grammarPoints: List<String>.from(json['grammar_points'] as List? ?? []),
          order: json['order'] as int? ?? 0,
        );
      }).toList();

      return GrammarGenerateResult(
        grammarSubTopicSlug: data['grammar_sub_topic_slug'] as String? ?? '',
        levelCode: data['level_code'] as String? ?? '',
        count: data['count'] as int? ?? 0,
        patterns: patterns,
      );
    } on DioException catch (e) {
      throw Exception('Failed to generate grammar patterns: ${e.message}');
    }
  }
}

