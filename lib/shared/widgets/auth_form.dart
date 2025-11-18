import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';
import 'custom_button.dart';

/// Reusable auth form widget
class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final VoidCallback onSubmit;
  final String submitButtonText;
  final bool isLoading;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final Widget? additionalContent;

  const AuthForm({
    super.key,
    required this.formKey,
    required this.children,
    required this.onSubmit,
    required this.submitButtonText,
    this.isLoading = false,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.additionalContent,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form fields
          ...children.map((child) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.s16),
                child: child,
              )),

          const SizedBox(height: AppSizes.s24),

          // Submit button
          CustomButton(
            onPressed: isLoading ? null : onSubmit,
            isLoading: isLoading,
            child: Text(submitButtonText),
          ),

          // Secondary button
          if (secondaryButtonText != null && onSecondaryPressed != null) ...[
            const SizedBox(height: AppSizes.s16),
            OutlinedButton(
              onPressed: isLoading ? null : onSecondaryPressed,
              child: Text(secondaryButtonText!),
            ),
          ],

          // Additional content
          if (additionalContent != null) ...[
            const SizedBox(height: AppSizes.s16),
            additionalContent!,
          ],
        ],
      ),
    );
  }
}
