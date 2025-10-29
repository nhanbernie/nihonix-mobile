import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_code_response.freezed.dart';
part 'verify_code_response.g.dart';

@freezed
sealed class VerifyCodeResponse with _$VerifyCodeResponse {
  const factory VerifyCodeResponse({
    required bool valid,
    required String token,
  }) = _VerifyCodeResponse;

  factory VerifyCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeResponseFromJson(json);
}
