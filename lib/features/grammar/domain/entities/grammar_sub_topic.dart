library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'grammar_sub_topic.freezed.dart';

@freezed
sealed class GrammarSubTopic with _$GrammarSubTopic {
  const GrammarSubTopic._();

  const factory GrammarSubTopic({
    required String slug,
    required String topicId,
    required String levelCode,
    required Map<String, String> title,
    required int order,
  }) = _GrammarSubTopic;

  String getTitleByLanguage(String lang) {
    return title[lang] ?? title['en'] ?? '';
  }
}
