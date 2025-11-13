import 'package:dio/dio.dart';
import '../../domain/entities/grammar_sub_topic.dart';
import '../../domain/entities/grammar_pattern.dart';
import 'grammar_api.dart';

class GrammarRemoteDataSource {
  final GrammarApi _api;

  GrammarRemoteDataSource(this._api);

  Future<List<GrammarSubTopic>> getGrammarSubTopics({
    String? levelCode,
    String? topicId,
  }) async {
    try {
      final response = await _api.getGrammarSubTopics(
        levelCode: levelCode,
        topicId: topicId,
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as List<dynamic>?;

      if (data == null) {
        return [];
      }

      // Map API response to GrammarSubTopic
      return data.map((item) {
        final json = item as Map<String, dynamic>;
        return GrammarSubTopic(
          slug: json['slug'] as String? ?? '',
          topicId: json['topic_id'] as String? ?? '',
          levelCode: json['level_code'] as String? ?? '',
          title: Map<String, String>.from(json['title'] as Map? ?? {}),
          order: json['order'] as int? ?? 0,
        );
      }).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch grammar sub-topics: ${e.message}');
    }
  }

  Future<List<GrammarPattern>> getGrammarPatterns(String grammarSubTopicSlug) async {
    try {
      final response = await _api.getGrammarPatterns(
        grammarSubTopicSlug: grammarSubTopicSlug,
      );

      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as List<dynamic>?;

      if (data == null) {
        return [];
      }

      // Map API response to GrammarPattern
      return data.map((item) {
        final json = item as Map<String, dynamic>;
        
        // Parse usage examples
        final examplesList = json['usage_examples'] as List<dynamic>? ?? [];
        final examples = examplesList.map((ex) {
          final exJson = ex as Map<String, dynamic>;
          return UsageExample(
            sentenceJp: exJson['sentence_jp'] as String? ?? '',
            sentenceRomaji: exJson['sentence_romaji'] as String? ?? '',
            sentenceVi: exJson['sentence_vi'] as String? ?? '',
            sentenceEn: exJson['sentence_en'] as String? ?? '',
          );
        }).toList();

        return GrammarPattern(
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
    } on DioException catch (e) {
      throw Exception('Failed to fetch grammar patterns: ${e.message}');
    }
  }
}

