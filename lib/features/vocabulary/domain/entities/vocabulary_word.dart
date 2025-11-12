library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary_word.freezed.dart';

@freezed
class VocabularyWord with _$VocabularyWord {
  const VocabularyWord._();

  const factory VocabularyWord({
    required String id,
    required String word,
    required String meaning,
    required String pronunciation,
    String? example,
    String? translation,
    @Default(false) bool isMastered,
  }) = _VocabularyWord;
}
