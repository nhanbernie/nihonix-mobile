library;

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/data/models/user_model.dart';

part 'update_profile_response.freezed.dart';

/// Data Model: Update Profile Response
@freezed
sealed class UpdateProfileResponse with _$UpdateProfileResponse {
  const UpdateProfileResponse._();

  const factory UpdateProfileResponse({
    required UserModel user,
  }) = _UpdateProfileResponse;

  /// From JSON
  ///
  /// API Response structure:
  /// {
  ///   "success": true,
  ///   "message": "Cập nhật thành công",
  ///   "data": { user object },
  ///   "errors": null,
  ///   "statusCode": 200
  /// }
  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    // Lấy data object từ response
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw FormatException('Data field is null in update profile response');
    }

    return UpdateProfileResponse(
      user: UserModel.fromJson(data),
    );
  }
}
