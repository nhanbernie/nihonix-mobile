import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard.freezed.dart';

@freezed
sealed class CardContent with _$CardContent {
  const CardContent._();

  const factory CardContent({
    required String text,
    required String type,
    String? meaning,
  }) = _CardContent;
}

@freezed
sealed class Flashcard with _$Flashcard {
  const Flashcard._();

  const factory Flashcard({
    required String id,
    String? slug,
    required String folderId,
    required String setId,
    required CardContent front,
    required CardContent back,
    required int order,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Flashcard;
}
