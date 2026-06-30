import 'package:easy_localization/easy_localization.dart';

/// Validation error types for formz models
enum UsernameValidationError {
  empty,
  tooShort,
  invalid,
}

enum EmailValidationError {
  empty,
  invalid,
}

enum PasswordValidationError {
  empty,
  tooShort,
  weak,
}

enum FullNameValidationError {
  empty,
  tooShort,
}

enum ResetCodeValidationError {
  empty,
  invalid,
}

enum ResetTokenValidationError {
  empty,
  invalid,
}

/// Extension methods to get error messages using easy_localization
extension UsernameValidationErrorExtension on UsernameValidationError {
  String get message {
    switch (this) {
      case UsernameValidationError.empty:
        return 'auth.username_required'.tr();
      case UsernameValidationError.tooShort:
        return 'auth.username_too_short'.tr();
      case UsernameValidationError.invalid:
        return 'auth.username_invalid'.tr();
    }
  }
}

extension EmailValidationErrorExtension on EmailValidationError {
  String get message {
    switch (this) {
      case EmailValidationError.empty:
        return 'auth.email_required'.tr();
      case EmailValidationError.invalid:
        return 'auth.email_invalid'.tr();
    }
  }
}

extension PasswordValidationErrorExtension on PasswordValidationError {
  String get message {
    switch (this) {
      case PasswordValidationError.empty:
        return 'auth.password_required'.tr();
      case PasswordValidationError.tooShort:
        return 'auth.password_too_short'.tr();
      case PasswordValidationError.weak:
        return 'auth.password_weak'.tr();
    }
  }
}

extension FullNameValidationErrorExtension on FullNameValidationError {
  String get message {
    switch (this) {
      case FullNameValidationError.empty:
        return 'auth.full_name_required'.tr();
      case FullNameValidationError.tooShort:
        return 'auth.full_name_too_short'.tr();
    }
  }
}

extension ResetCodeValidationErrorExtension on ResetCodeValidationError {
  String get message {
    switch (this) {
      case ResetCodeValidationError.empty:
        return 'auth.reset_code_required'.tr();
      case ResetCodeValidationError.invalid:
        return 'auth.reset_code_invalid'.tr();
    }
  }
}

extension ResetTokenValidationErrorExtension on ResetTokenValidationError {
  String get message {
    switch (this) {
      case ResetTokenValidationError.empty:
        return 'auth.reset_token_required'.tr();
      case ResetTokenValidationError.invalid:
        return 'auth.reset_token_invalid'.tr();
    }
  }
}
