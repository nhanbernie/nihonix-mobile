library;

import 'package:json_annotation/json_annotation.dart';
import 'flashcard_model.dart';

part 'create_flashcard_response.g.dart';

@JsonSerializable()
class CreateFlashcardResponse {
  final bool success;
  final String message;
  final CreateFlashcardData data;
  final dynamic errors;
  @JsonKey(name: 'statusCode')
  final int statusCode;

  const CreateFlashcardResponse({
    required this.success,
    required this.message,
    required this.data,
    this.errors,
    required this.statusCode,
  });

  factory CreateFlashcardResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateFlashcardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFlashcardResponseToJson(this);
}

@JsonSerializable()
class CreateFlashcardData {
  @JsonKey(name: 'set_id')
  final String setId;

  @JsonKey(name: 'set_name')
  final String setName;

  final int created;

  final List<FlashcardModel> cards;

  const CreateFlashcardData({
    required this.setId,
    required this.setName,
    required this.created,
    required this.cards,
  });

  factory CreateFlashcardData.fromJson(Map<String, dynamic> json) =>
      _$CreateFlashcardDataFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFlashcardDataToJson(this);
}
