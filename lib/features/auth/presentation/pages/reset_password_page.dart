import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/core/validation/models/password.dart';
import 'package:nihonix/core/validation/validation_errors.dart';
import 'package:nihonix/shared/layouts/auth_layout.dart';
import 'package:nihonix/shared/widgets/custom_button.dart';
import 'package:nihonix/shared/widgets/custom_input_field.dart';
import '../providers/forgot_password_provider.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  Password _password = const Password.pure();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
    // No need to store confirm password state
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    if (value != _password.value) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(forgotPasswordProvider.notifier)
        .resetPassword(_password.value);
  }

  void _handleBackToLogin() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordState = ref.watch(forgotPasswordProvider);

    // NOTE: handle later
    // Navigate to login page when password is reset
    ref.listen(forgotPasswordProvider, (previous, next) {
      if (next.isPasswordReset) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mật khẩu đã được đặt lại thành công!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(AppRoutes.login);
      }
    });

    return Scaffold(
      body: AuthLayout(
        title: 'Đặt lại mật khẩu',
        subtitle: 'Nhập mật khẩu mới của bạn',
        illustrationPath: null,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // New password input
              CustomInputField(
                controller: _passwordController,
                labelText: 'Mật khẩu mới',
                hintText: 'Nhập mật khẩu mới',
                obscureText: _obscurePassword,
                onChanged: _onPasswordChanged,
                validator: (value) {
                  if (_password.error == PasswordValidationError.empty) {
                    return 'Mật khẩu không được để trống';
                  } else if (_password.error ==
                      PasswordValidationError.tooShort) {
                    return 'Mật khẩu quá ngắn';
                  } else if (_password.error == PasswordValidationError.weak) {
                    return 'Mật khẩu quá yếu';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: AppSizes.s16),

              // Confirm password input
              CustomInputField(
                controller: _confirmPasswordController,
                labelText: 'Xác nhận mật khẩu',
                hintText: 'Nhập lại mật khẩu mới',
                obscureText: _obscureConfirmPassword,
                onChanged: _onConfirmPasswordChanged,
                validator: _validateConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: AppSizes.s32),

              // Reset password button
              CustomButton(
                onPressed:
                    forgotPasswordState.isLoading ? null : _handleResetPassword,
                isLoading: forgotPasswordState.isLoading,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.8),
                ),
                child: const Text(
                  'Đặt lại mật khẩu',
                  style: TextStyle(
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
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),

              // Error message
              if (forgotPasswordState.error != null)
                Container(
                  margin: const EdgeInsets.only(top: AppSizes.s16),
                  padding: const EdgeInsets.all(AppSizes.s12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3)),
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
            ],
          ),
        ),
      ),
    );
  }
}
