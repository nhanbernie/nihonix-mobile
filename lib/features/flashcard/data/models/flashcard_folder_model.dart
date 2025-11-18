library;

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/flashcard_folder.dart';

part 'flashcard_folder_model.g.dart';

/// Flashcard Folder Model (Data Layer)
///
/// Data transfer object for API communication
@JsonSerializable()
class FlashcardFolderModel {
  final String id;
  final String slug;
  final String name;
  final String description;
  final int order;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  FlashcardFolderModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FlashcardFolderModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardFolderModelFromJson(json);

  Map<String, dynamic> toJson() => _$FlashcardFolderModelToJson(this);

  /// Convert model to domain entity
  FlashcardFolder toDomain() {
    return FlashcardFolder(
      id: id,
      slug: slug,
      name: name,
      description: description,
      order: order,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  /// Convert domain entity to model
  factory FlashcardFolderModel.fromDomain(FlashcardFolder folder) {
    return FlashcardFolderModel(
      id: folder.id,
      slug: folder.slug,
      name: folder.name,
      description: folder.description,
      order: folder.order,
      createdAt: folder.createdAt.toIso8601String(),
      updatedAt: folder.updatedAt.toIso8601String(),
    );
  }
}
