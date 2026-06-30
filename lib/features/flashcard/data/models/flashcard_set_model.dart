import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/flashcard_set.dart';

part 'flashcard_set_model.g.dart';

@JsonSerializable()
class FlashcardSetModel {
  final String id;
  final String name;
  @JsonKey(name: 'folder_id')
  final String folderId;
  final int order;
  @JsonKey(name: 'card_count')
  final int cardCount;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  FlashcardSetModel({
    required this.id,
    required this.name,
    required this.folderId,
    required this.order,
    required this.cardCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FlashcardSetModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardSetModelFromJson(json);

  Map<String, dynamic> toJson() => _$FlashcardSetModelToJson(this);

  // Mapper to domain entity
  FlashcardSet toDomain() {
    return FlashcardSet(
      id: id,
      name: name,
      folderId: folderId,
      order: order,
      cardCount: cardCount,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
