import 'package:formz/formz.dart';
import '../validation_errors.dart';

/// Username formz model for validation
class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) return UsernameValidationError.empty;
    if (value.length < 3) return UsernameValidationError.tooShort;
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return UsernameValidationError.invalid;
    }
    return null;
  }
}
