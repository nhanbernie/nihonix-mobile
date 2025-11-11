library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard_folder.freezed.dart';

@freezed
sealed class FlashcardFolder with _$FlashcardFolder {
  const FlashcardFolder._();

  const factory FlashcardFolder({
    required String id,
    required String slug,
    required String name,
    required String description,
    required int order,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _FlashcardFolder;
}
