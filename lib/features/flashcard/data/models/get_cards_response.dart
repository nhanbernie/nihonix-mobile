import 'package:json_annotation/json_annotation.dart';
import 'flashcard_model.dart';

part 'get_cards_response.g.dart';

@JsonSerializable()
class GetCardsResponse {
  final bool success;
  final String message;
  final List<FlashcardModel> data;
  final dynamic errors;
  final int statusCode;

  GetCardsResponse({
    required this.success,
    required this.message,
    required this.data,
    this.errors,
    required this.statusCode,
  });

  factory GetCardsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCardsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetCardsResponseToJson(this);
}
