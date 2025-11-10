import 'package:json_annotation/json_annotation.dart';

part 'upload_avatar_response.g.dart';

/// Response model khi upload avatar thành công
@JsonSerializable()
class UploadAvatarResponse {
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;

  UploadAvatarResponse({
    required this.avatarUrl,
  });

  factory UploadAvatarResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadAvatarResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadAvatarResponseToJson(this);
}
