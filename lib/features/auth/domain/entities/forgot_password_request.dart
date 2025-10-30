import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_request.freezed.dart';

@freezed
sealed class ForgotPasswordRequest with _$ForgotPasswordRequest {
  const factory ForgotPasswordRequest({
    required String email,
  }) = _ForgotPasswordRequest;
}
