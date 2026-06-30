// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'reset_password_request.freezed.dart';
// part 'reset_password_request.g.dart';

class ResetPasswordRequest {
  final String token;
  final String password;

  const ResetPasswordRequest({
    required this.token,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'password': password,
    };
  }
}
