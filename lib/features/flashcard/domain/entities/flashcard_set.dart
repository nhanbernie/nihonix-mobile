library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard_set.freezed.dart';

@freezed
sealed class FlashcardSet with _$FlashcardSet {
  const FlashcardSet._();

  const factory FlashcardSet({
    required String id,
    required String name,
    required String folderId,
    required int order,
    required int cardCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _FlashcardSet;
}
