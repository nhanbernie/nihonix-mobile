library;

import 'package:json_annotation/json_annotation.dart';

part 'generate_flashcard_request.g.dart';

@JsonSerializable()
class GenerateFlashcardRequest {
  @JsonKey(name: 'folder_id')
  final String folderId;

  @JsonKey(name: 'set_name')
  final String setName;

  @JsonKey(name: 'level_code')
  final String levelCode;

  final String difficulty;

  final String topic;

  final int count;

  @JsonKey(name: 'custom_prompt')
  final String? customPrompt;

  const GenerateFlashcardRequest({
    required this.folderId,
    required this.setName,
    required this.levelCode,
    required this.difficulty,
    required this.topic,
    required this.count,
    this.customPrompt,
  });

  factory GenerateFlashcardRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateFlashcardRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateFlashcardRequestToJson(this);
}
