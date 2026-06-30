import 'package:json_annotation/json_annotation.dart';
import 'card_content_model.dart';
import '../../domain/entities/flashcard.dart';

part 'flashcard_model.g.dart';

@JsonSerializable()
class FlashcardModel {
  final String id;
  final String? slug;
  @JsonKey(name: 'folder_id')
  final String folderId;
  @JsonKey(name: 'set_id')
  final String? setId;
  final CardContentModel front;
  final CardContentModel back;
  final int order;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  FlashcardModel({
    required this.id,
    this.slug,
    required this.folderId,
    this.setId,
    required this.front,
    required this.back,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FlashcardModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardModelFromJson(json);

  Map<String, dynamic> toJson() => _$FlashcardModelToJson(this);

  // Mapper to domain entity
  Flashcard toDomain() {
    return Flashcard(
      id: id,
      slug: slug,
      folderId: folderId,
      setId: setId,
      front: CardContent(
        text: front.text,
        type: front.type,
        meaning: front.meaning,
      ),
      back: CardContent(
        text: back.text,
        type: back.type,
        meaning: back.meaning,
      ),
      order: order,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
