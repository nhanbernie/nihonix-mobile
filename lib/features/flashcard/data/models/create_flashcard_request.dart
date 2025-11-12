library;

import 'package:json_annotation/json_annotation.dart';

part 'create_flashcard_request.g.dart';

@JsonSerializable()
class CreateFlashcardRequest {
  @JsonKey(name: 'folder_id')
  final String folderId;
  
  @JsonKey(name: 'set_name')
  final String setName;
  
  final List<CardRequest> cards;

  const CreateFlashcardRequest({
    required this.folderId,
    required this.setName,
    required this.cards,
  });

  factory CreateFlashcardRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFlashcardRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFlashcardRequestToJson(this);
}

@JsonSerializable()
class CardRequest {
  final CardContentRequest front;
  final CardContentRequest back;
  final int order;

  const CardRequest({
    required this.front,
    required this.back,
    required this.order,
  });

  factory CardRequest.fromJson(Map<String, dynamic> json) =>
      _$CardRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CardRequestToJson(this);
}

@JsonSerializable()
class CardContentRequest {
  final String text;
  final String? meaning;
  final String type;

  const CardContentRequest({
    required this.text,
    this.meaning,
    this.type = 'text',
  });

  factory CardContentRequest.fromJson(Map<String, dynamic> json) =>
      _$CardContentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CardContentRequestToJson(this);
}
