import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_request.freezed.dart';

@freezed
sealed class ResetPasswordRequest with _$ResetPasswordRequest {
  const factory ResetPasswordRequest({
    required String token,
    required String password,
  }) = _ResetPasswordRequest;
}
