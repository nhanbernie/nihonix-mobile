import 'package:formz/formz.dart';
import '../validation_errors.dart';

/// Password formz model for validation
class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    if (value.length < 6) return PasswordValidationError.tooShort;
    if (value.length < 8) return PasswordValidationError.weak;
    return null;
  }
}
