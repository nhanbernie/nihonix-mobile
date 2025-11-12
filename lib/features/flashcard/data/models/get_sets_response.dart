import 'package:json_annotation/json_annotation.dart';
import 'flashcard_set_model.dart';

part 'get_sets_response.g.dart';

@JsonSerializable()
class GetSetsResponse {
  final bool success;
  final String message;
  final List<FlashcardSetModel> data;
  final dynamic errors;
  final int statusCode;

  GetSetsResponse({
    required this.success,
    required this.message,
    required this.data,
    this.errors,
    required this.statusCode,
  });

  factory GetSetsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetSetsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetSetsResponseToJson(this);
}
