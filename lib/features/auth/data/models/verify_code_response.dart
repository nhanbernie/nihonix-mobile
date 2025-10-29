// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'verify_code_response.freezed.dart';
// part 'verify_code_response.g.dart';

class VerifyCodeResponse {
  final bool valid;
  final String token;

  const VerifyCodeResponse({
    required this.valid,
    required this.token,
  });

  factory VerifyCodeResponse.fromJson(Map<String, dynamic> json) {
    // Parse từ nested data field
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw FormatException('Missing data field in verify code response');
    }

    return VerifyCodeResponse(
      valid: data['valid'] as bool? ?? false,
      token: data['token'] as String? ?? '',
    );
  }
}
