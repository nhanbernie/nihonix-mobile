import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_code_request.freezed.dart';

@freezed
sealed class VerifyCodeRequest with _$VerifyCodeRequest {
  const factory VerifyCodeRequest({
    required String email,
    required String code,
  }) = _VerifyCodeRequest;
}
