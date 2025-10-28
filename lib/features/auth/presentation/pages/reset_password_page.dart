import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:formz/formz.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/validation/models/password.dart';
import '../../../../core/validation/validation_errors.dart';
import '../../../../shared/widgets/custom_input_field.dart';
import '../../../../shared/widgets/auth_form.dart';
import '../../../../shared/layouts/auth_layout.dart';

/// Reset password page
class ResetPasswordPage extends ConsumerStatefulWidget {
  final String? token;

  const ResetPasswordPage({
    super.key,
    this.token,
  });

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Formz model
  Password _password = const Password.pure();
  Password _confirmPassword = const Password.pure();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _password = Password.dirty(value);
    });
  }

  void _onConfirmPasswordChanged(String value) {
    setState(() {
      _confirmPassword = Password.dirty(value);
    });
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Xác nhận mật khẩu là bắt buộc';
    }
    if (value != _passwordController.text) {
      return 'Mật khẩu không khớp';
    }
    return null;
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    // TODO: Implement reset password logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng đặt lại mật khẩu đang phát triển!'),
      ),
    );
  }

  void _handleBackToLogin() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Đặt lại mật khẩu',
      subtitle: 'Nhập mật khẩu mới của bạn',
      illustrationPath: 'assets/images/login_illustration.png',
      showSocialLogin: false,
      child: AuthForm(
        formKey: _formKey,
        onSubmit: _handleResetPassword,
        submitButtonText: 'Đặt lại mật khẩu',
        isLoading: false,
        secondaryButtonText: 'Quay lại đăng nhập',
        onSecondaryPressed: _handleBackToLogin,
        children: [
          // Password field
          CustomInputField(
            controller: _passwordController,
            labelText: 'Mật khẩu mới',
            prefixIcon: Icons.lock,
            obscureText: true,
            validator: (value) => _password.error?.message,
            onChanged: _onPasswordChanged,
          ),

          // Confirm password field
          CustomInputField(
            controller: _confirmPasswordController,
            labelText: 'Xác nhận mật khẩu',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            validator: _validateConfirmPassword,
            onChanged: _onConfirmPasswordChanged,
          ),
        ],
      ),
    );
  }
}
