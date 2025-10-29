import 'package:formz/formz.dart';
import '../validation_errors.dart';

/// Reset token formz model for validation
class ResetToken extends FormzInput<String, ResetTokenValidationError> {
  const ResetToken.pure() : super.pure('');
  const ResetToken.dirty([super.value = '']) : super.dirty();

  @override
  ResetTokenValidationError? validator(String value) {
    if (value.isEmpty) return ResetTokenValidationError.empty;
    if (value.length < 10) return ResetTokenValidationError.invalid;
    return null;
  }
}
