import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:formz/formz.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/validation/models/email.dart';
import '../../../../core/validation/validation_errors.dart';
import '../../../../shared/widgets/custom_input_field.dart';
import '../../../../shared/widgets/auth_form.dart';
import '../../../../shared/layouts/auth_layout.dart';

/// Forgot password page
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  // Formz model
  Email _email = const Email.pure();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    setState(() {
      _email = Email.dirty(value);
    });
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    // TODO: Implement forgot password logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng quên mật khẩu đang phát triển!'),
      ),
    );
  }

  void _handleBackToLogin() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Quên mật khẩu',
      subtitle: 'Nhập email để nhận mã đặt lại mật khẩu',
      illustrationPath: 'assets/images/login_illustration.png',
      showSocialLogin: false,
      child: AuthForm(
        formKey: _formKey,
        onSubmit: _handleForgotPassword,
        submitButtonText: 'Gửi mã',
        isLoading: false,
        secondaryButtonText: 'Quay lại đăng nhập',
        onSecondaryPressed: _handleBackToLogin,
        children: [
          // Email field
          CustomInputField(
            controller: _emailController,
            labelText: AppStrings.email,
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => _email.error?.message,
            onChanged: _onEmailChanged,
          ),
        ],
      ),
    );
  }
}
