import 'package:formz/formz.dart';
import '../validation_errors.dart';

/// Reset code formz model for validation
class ResetCode extends FormzInput<String, ResetCodeValidationError> {
  const ResetCode.pure() : super.pure('');
  const ResetCode.dirty([super.value = '']) : super.dirty();

  @override
  ResetCodeValidationError? validator(String value) {
    if (value.isEmpty) return ResetCodeValidationError.empty;
    if (value.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return ResetCodeValidationError.invalid;
    }
    return null;
  }
}
