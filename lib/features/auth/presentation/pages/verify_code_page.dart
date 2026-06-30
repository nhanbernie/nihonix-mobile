import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/shared/layouts/auth_layout.dart';
import 'package:nihonix/shared/widgets/custom_button.dart';
import '../providers/forgot_password_provider.dart';
import '../widgets/otp_input_field.dart';

class VerifyCodePage extends ConsumerStatefulWidget {
  final String email;

  const VerifyCodePage({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends ConsumerState<VerifyCodePage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  String _otpCode = '';

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onOtpChanged(String value) {
    setState(() {
      _otpCode = value;
    });
  }

  void _onOtpCompleted(String value) {
    _handleVerifyCode();
  }

  Future<void> _handleVerifyCode() async {
    if (_otpCode.length != 6) return;

    await ref.read(forgotPasswordProvider.notifier).verifyCode(_otpCode);
  }

  Future<void> _handleResendCode() async {
    await ref.read(forgotPasswordProvider.notifier).sendResetCode(widget.email);
  }

  void _handleBackToLogin() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordState = ref.watch(forgotPasswordProvider);

    // Navigate to reset password page when code is verified
    ref.listen(forgotPasswordProvider, (previous, next) {
      if (next.isCodeVerified) {
        context.go(AppRoutes.resetPassword);
      }
    });

    return Scaffold(
      body: AuthLayout(
        title: 'Xác thực mã',
        subtitle: 'Nhập mã 6 chữ số đã được gửi đến\n${widget.email}',
        illustrationPath: null,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // OTP Input
              OtpInputField(
                controller: _otpController,
                onChanged: _onOtpChanged,
                onCompleted: _onOtpCompleted,
                enabled: !forgotPasswordState.isLoading,
              ),
              const SizedBox(height: AppSizes.s32),

              // Verify button
              CustomButton(
                onPressed: forgotPasswordState.isLoading || _otpCode.length != 6
                    ? null
                    : _handleVerifyCode,
                isLoading: forgotPasswordState.isLoading,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.8),
                ),
                child: const Text(
                  'Xác thực',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.s16),

              // Resend code button
              TextButton(
                onPressed:
                    forgotPasswordState.isLoading ? null : _handleResendCode,
                child: const Text(
                  'Gửi lại mã',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.s8),

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
