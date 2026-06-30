import 'package:formz/formz.dart';
import '../validation_errors.dart';

/// Full name formz model for validation
class FullName extends FormzInput<String, FullNameValidationError> {
  const FullName.pure() : super.pure('');
  const FullName.dirty([super.value = '']) : super.dirty();

  @override
  FullNameValidationError? validator(String value) {
    if (value.isEmpty) return FullNameValidationError.empty;
    if (value.length < 2) return FullNameValidationError.tooShort;
    return null;
  }
}
