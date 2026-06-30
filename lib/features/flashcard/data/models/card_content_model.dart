import 'package:json_annotation/json_annotation.dart';

part 'card_content_model.g.dart';

@JsonSerializable()
class CardContentModel {
  final String text;
  final String type;
  final String? meaning;

  CardContentModel({
    required this.text,
    required this.type,
    this.meaning,
  });

  factory CardContentModel.fromJson(Map<String, dynamic> json) =>
      _$CardContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardContentModelToJson(this);
}
