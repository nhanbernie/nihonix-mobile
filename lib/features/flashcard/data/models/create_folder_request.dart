library;

import 'package:json_annotation/json_annotation.dart';

part 'create_folder_request.g.dart';

@JsonSerializable()
class CreateFolderRequest {
  final String name;
  final String? description;
  final int order;

  CreateFolderRequest({
    required this.name,
    this.description,
    required this.order,
  });

  factory CreateFolderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFolderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFolderRequestToJson(this);
}
