library;

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/update_profile_request.dart';

part 'update_profile_request_model.freezed.dart';
part 'update_profile_request_model.g.dart';

/// Data Model: Update Profile Request
@freezed
sealed class UpdateProfileRequestModel with _$UpdateProfileRequestModel {
  const UpdateProfileRequestModel._();

  const factory UpdateProfileRequestModel({
    String? username,
    String? email,
    @JsonKey(name: 'full_name') String? fullName,
    String? language,
  }) = _UpdateProfileRequestModel;

  /// From JSON
  factory UpdateProfileRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestModelFromJson(json);

  /// From Domain Entity
  factory UpdateProfileRequestModel.fromDomain(UpdateProfileRequest request) {
    return UpdateProfileRequestModel(
      username: request.username,
      email: request.email,
      fullName: request.fullName,
      language: request.language,
    );
  }

  /// To Domain Entity
  UpdateProfileRequest toDomain() {
    return UpdateProfileRequest(
      username: username,
      email: email,
      fullName: fullName,
      language: language,
    );
  }
}

