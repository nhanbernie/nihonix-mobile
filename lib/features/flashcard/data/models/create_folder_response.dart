library;

import 'package:json_annotation/json_annotation.dart';
import 'flashcard_folder_model.dart';

part 'create_folder_response.g.dart';

@JsonSerializable()
class CreateFolderResponse {
  final bool success;
  final String message;
  final FlashcardFolderModel data;
  final dynamic errors;
  
  @JsonKey(name: 'statusCode')
  final int statusCode;

  CreateFolderResponse({
    required this.success,
    required this.message,
    required this.data,
    this.errors,
    required this.statusCode,
  });

  factory CreateFolderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateFolderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFolderResponseToJson(this);
}
