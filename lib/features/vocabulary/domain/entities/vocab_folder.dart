library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocab_folder.freezed.dart';

@freezed
class VocabFolder with _$VocabFolder {
  const VocabFolder._();

  const factory VocabFolder({
    required String id,
    required String name,
    required String topicName,
    required int wordCount,
    required DateTime createdAt,
    String? description,
    String? prompt,
    @Default(false) bool isAiGenerated,
  }) = _VocabFolder;

  String get displayWordCount => '$wordCount ${wordCount == 1 ? 'word' : 'words'}';
}
