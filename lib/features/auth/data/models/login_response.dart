library;

import 'package:flutter/foundation.dart';
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
  ///
  /// API Response structure:
  /// {
  ///   "success": true,
  ///   "message": "...",
  ///   "data": {
  ///     "user": { "id": 1, "username": "...", "email": "...", "full_name": "..." },
  ///     "accessToken": "...",
  ///     "refreshToken": "..."
  ///   },
  ///   "errors": null,
  ///   "statusCode": 200
  /// }
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    debugPrint('🔍 [LoginResponse] Parsing JSON: $json');

    // Lấy data object từ response
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw FormatException('Data field is null in login response');
    }

    debugPrint('🔍 [LoginResponse] Data object: $data');

    // Lấy user object từ data
    final userData = data['user'] as Map<String, dynamic>?;
    if (userData == null) {
      throw FormatException('User data is null in login response');
    }

    debugPrint('🔍 [LoginResponse] User data: $userData');

    // Lấy tokens từ data (API dùng accessToken, refreshToken chứ không phải access_token, refresh_token)
    final accessToken = data['accessToken'] as String? ?? '';
    final refreshToken = data['refreshToken'] as String? ?? '';

    debugPrint(
        '🔍 [LoginResponse] Access token: ${accessToken.substring(0, 20)}...');
    debugPrint(
        '🔍 [LoginResponse] Refresh token: ${refreshToken.substring(0, 20)}...');

    return LoginResponse(
      user: UserModel.fromJson(userData),
      accessToken: accessToken,
      refreshToken: refreshToken,
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
