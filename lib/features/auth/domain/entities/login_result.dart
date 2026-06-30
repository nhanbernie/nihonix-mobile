library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'login_result.freezed.dart';

@freezed
sealed class LoginResult with _$LoginResult {
  const factory LoginResult({
    required User user,
    required String accessToken,
  }) = _LoginResult;
}
