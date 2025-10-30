library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'login_result.freezed.dart';

/// LoginResult chứa kết quả login với user và accessToken.
///
/// Tại sao cần LoginResult?
/// - AuthProvider cần accessToken để lưu vào state
/// - UseCase chỉ nên trả về domain entities, không phải data models
/// - Tách biệt concerns: User entity + accessToken string
@freezed
sealed class LoginResult with _$LoginResult {
  const factory LoginResult({
    required User user,
    required String accessToken,
  }) = _LoginResult;
}
