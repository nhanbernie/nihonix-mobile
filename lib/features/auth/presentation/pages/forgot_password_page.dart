import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/core/validation/models/email.dart';
import 'package:nihonix/core/validation/validation_errors.dart';
import 'package:nihonix/shared/layouts/auth_layout.dart';
import 'package:nihonix/shared/widgets/custom_button.dart';
import 'package:nihonix/shared/widgets/custom_input_field.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import '../providers/forgot_password_provider.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  Email _email = const Email.pure();

  @override
  void initState() {
    super.initState();
    // Reset state khi vào lại trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(forgotPasswordProvider.notifier).reset();
    });
  }

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

  Future<void> _handleSendCode() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(forgotPasswordProvider.notifier).sendResetCode(_email.value);
  }

  void _handleBackToLogin() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordState = ref.watch(forgotPasswordProvider);

    // Navigate to verify code page after successful send
    ref.listen(forgotPasswordProvider, (previous, next) {
      if (next.isCodeSent) {
        context.go('${AppRoutes.verifyCode}?email=${_email.value}');
      }
    });

    return Scaffold(
      body: AuthLayout(
        title: 'Quên mật khẩu',
        subtitle: forgotPasswordState.isCodeSent
            ? 'Mã xác thực đã được gửi đến email của bạn'
            : 'Nhập email của bạn để nhận mã xác thực',
        illustrationPath: null,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email input
              CustomInputField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Nhập email của bạn',
                keyboardType: TextInputType.emailAddress,
                onChanged: _onEmailChanged,
                validator: (value) {
                  if (_email.error == EmailValidationError.empty) {
                    return 'Email không được để trống';
                  } else if (_email.error == EmailValidationError.invalid) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
                enabled: !forgotPasswordState.isCodeSent,
              ),
              const SizedBox(height: AppSizes.s24),

              // Send code button
              CustomButton(
                onPressed:
                    forgotPasswordState.isLoading ? null : _handleSendCode,
                isLoading: forgotPasswordState.isLoading,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.8),
                ),
                child: Text(
                  forgotPasswordState.isCodeSent
                      ? 'Gửi lại mã'
                      : 'Gửi mã xác thực',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.s16),

              // Back to login
              TextButton(
                onPressed: _handleBackToLogin,
                child: const Text(
                  'Quay lại đăng nhập',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ),

              // Error message
              if (forgotPasswordState.error != null)
                Container(
                  margin: const EdgeInsets.only(top: AppSizes.s16),
                  padding: const EdgeInsets.all(AppSizes.s12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    border: Border.all(color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Text(
                    forgotPasswordState.error!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Success message
              if (forgotPasswordState.isCodeSent)
                Container(
                  margin: const EdgeInsets.only(top: AppSizes.s16),
                  padding: const EdgeInsets.all(AppSizes.s12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    border:
                        Border.all(color: AppColors.success.withOpacity(0.3)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
