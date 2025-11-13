import 'package:json_annotation/json_annotation.dart';
import 'card_content_model.dart';

part 'update_flashcard_request.g.dart';

@JsonSerializable()
class UpdateFlashcardRequest {
  @JsonKey(name: 'set_id')
  final String setId;

  @JsonKey(name: 'set_name')
  final String setName;

  final List<UpdateFlashcardCardRequest> cards;

  UpdateFlashcardRequest({
    required this.setId,
    required this.setName,
    required this.cards,
  });

  factory UpdateFlashcardRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateFlashcardRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFlashcardRequestToJson(this);
}

@JsonSerializable()
class UpdateFlashcardCardRequest {
  // id là optional - nếu có thì update, không có thì tạo mới
  final String? id;

  final CardContentModel front;
  final CardContentModel back;
  final int order;

  UpdateFlashcardCardRequest({
    this.id,
    required this.front,
    required this.back,
    required this.order,
  });

  factory UpdateFlashcardCardRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateFlashcardCardRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFlashcardCardRequestToJson(this);
}
