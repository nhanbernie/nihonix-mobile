import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';

class OtpInputField extends StatelessWidget {
  final String? Function(String?)? validator;
  final void Function(String) onChanged;
  final void Function(String) onCompleted;
  final TextEditingController? controller;
  final bool enabled;

  const OtpInputField({
    super.key,
    this.validator,
    required this.onChanged,
    required this.onCompleted,
    this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        fieldHeight: 56,
        fieldWidth: 48,
        activeFillColor: AppColors.primary.withValues(alpha: 0.1),
        inactiveFillColor: Colors.grey[100]!,
        selectedFillColor: AppColors.primary.withValues(alpha: 0.2),
        activeColor: AppColors.primary,
        inactiveColor: Colors.grey[300]!,
        selectedColor: AppColors.primary,
        borderWidth: 1.5,
      ),
      enableActiveFill: true,
      onChanged: onChanged,
      onCompleted: onCompleted,
      validator: validator,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
