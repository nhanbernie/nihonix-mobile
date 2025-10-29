library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'login_response.freezed.dart';

@freezed
sealed class LoginResponse with _$LoginResponse {
  const LoginResponse._();

  const factory LoginResponse({
    required UserModel user,
    required String accessToken,
    required String refreshToken,
  }) = _LoginResponse;

  /// Factory constructor từ JSON với custom mapping.
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // Kiểm tra null trước khi ép kiểu
    final userData = json['user'];
    if (userData == null) {
      throw FormatException('User data is null in login response');
    }

    return LoginResponse(
      user: UserModel.fromJson(userData as Map<String, dynamic>),
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
    );
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}
