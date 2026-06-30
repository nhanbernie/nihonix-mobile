library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'grammar_pattern.freezed.dart';

@freezed
sealed class GrammarPattern with _$GrammarPattern {
  const GrammarPattern._();

  const factory GrammarPattern({
    required String slug,
    required String grammarSubTopicSlug,
    required String topicSlug,
    required String levelCode,
    required String patternJp,
    required String patternRomaji,
    required Map<String, String> explanation,
    required List<UsageExample> usageExamples,
    required Map<String, dynamic> conjugationRules,
    required String levelDifficulty,
    required List<String> grammarPoints,
    required int order,
  }) = _GrammarPattern;

  String getExplanation(String lang) {
    return explanation[lang] ?? explanation['en'] ?? '';
  }
}

@freezed
sealed class UsageExample with _$UsageExample {
  const factory UsageExample({
    required String sentenceJp,
    required String sentenceRomaji,
    required String sentenceVi,
    required String sentenceEn,
  }) = _UsageExample;
}
