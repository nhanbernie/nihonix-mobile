import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary.freezed.dart';

@freezed
sealed class Vocabulary with _$Vocabulary {
  const factory Vocabulary({
    required String word,
    required String hiragana,
    required String romaji,
    required String meaning,
    String? exampleSentence,
  }) = _Vocabulary;
}
