import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/validation/models/reset_code.dart';
import '../../../../core/validation/validation_errors.dart';
import '../../../../shared/widgets/custom_input_field.dart';
import '../../../../shared/widgets/auth_form.dart';
import '../../../../shared/layouts/auth_layout.dart';

/// Verify reset code page
class VerifyResetCodePage extends ConsumerStatefulWidget {
  const VerifyResetCodePage({super.key});

  @override
  ConsumerState<VerifyResetCodePage> createState() =>
      _VerifyResetCodePageState();
}

class _VerifyResetCodePageState extends ConsumerState<VerifyResetCodePage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  // Formz model
  ResetCode _resetCode = const ResetCode.pure();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onCodeChanged(String value) {
    setState(() {
      _resetCode = ResetCode.dirty(value);
    });
  }

  Future<void> _handleVerifyCode() async {
    if (!_formKey.currentState!.validate()) return;

    // TODO: Implement verify code logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng xác thực mã đang phát triển!'),
      ),
    );
  }

  void _handleResendCode() {
    // TODO: Implement resend code logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng gửi lại mã đang phát triển!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Xác thực mã',
      subtitle: 'Nhập mã 6 chữ số đã được gửi đến email của bạn',
      illustrationPath: 'assets/images/login_illustration.png',
      showSocialLogin: false,
      child: AuthForm(
        formKey: _formKey,
        onSubmit: _handleVerifyCode,
        submitButtonText: 'Xác thực',
        isLoading: false,
        secondaryButtonText: 'Gửi lại mã',
        onSecondaryPressed: _handleResendCode,
        children: [
          // Reset code field
          CustomInputField(
            controller: _codeController,
            labelText: 'Mã xác thực',
            prefixIcon: Icons.security,
            keyboardType: TextInputType.number,
            maxLength: 6,
            validator: (value) => _resetCode.error?.message,
            onChanged: _onCodeChanged,
          ),
        ],
      ),
    );
  }
}
