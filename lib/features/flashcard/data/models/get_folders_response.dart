import 'package:json_annotation/json_annotation.dart';
import 'flashcard_folder_model.dart';

part 'get_folders_response.g.dart';

@JsonSerializable()
class GetFoldersResponse {
  final bool success;
  final String message;
  final List<FlashcardFolderModel> data;
  final dynamic errors;
  final int statusCode;

  GetFoldersResponse({
    required this.success,
    required this.message,
    required this.data,
    this.errors,
    required this.statusCode,
  });

  factory GetFoldersResponse.fromJson(Map<String, dynamic> json) =>
      _$GetFoldersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetFoldersResponseToJson(this);
}
