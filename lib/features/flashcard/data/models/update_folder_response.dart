library;

import 'package:json_annotation/json_annotation.dart';
import 'flashcard_folder_model.dart';

part 'update_folder_response.g.dart';

/// Update Folder Response Model
@JsonSerializable()
class UpdateFolderResponse {
  final bool success;
  final String message;
  final FlashcardFolderModel data;
  final dynamic errors;
  final int statusCode;

  UpdateFolderResponse({
    required this.success,
    required this.message,
    required this.data,
    this.errors,
    required this.statusCode,
  });

  factory UpdateFolderResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateFolderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFolderResponseToJson(this);
}
