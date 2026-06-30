library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_profile_request.freezed.dart';

/// Domain Entity: Update Profile Request
@freezed
sealed class UpdateProfileRequest with _$UpdateProfileRequest {
  const factory UpdateProfileRequest({
    String? username,
    String? email,
    String? fullName,
    String? language,
  }) = _UpdateProfileRequest;
}
