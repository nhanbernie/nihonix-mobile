import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/l10n/locale_keys.dart';

/// Social login buttons widget
class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
              child: Text(
                LocaleKeys.auth_or_sign_in_with.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),

        const SizedBox(height: AppSizes.s24),

        // Social login buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              context,
              icon: Icons.g_mobiledata,
              label: 'Google',
              onPressed: _handleGoogleLogin,
            ),
            const SizedBox(width: AppSizes.s16),
            _buildSocialButton(
              context,
              icon: Icons.facebook,
              label: 'Facebook',
              onPressed: _handleFacebookLogin,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
        ),
      ),
    );
  }

  void _handleGoogleLogin() {
    // TODO: Implement Google login
    debugPrint('Google login pressed');
  }

  void _handleFacebookLogin() {
    // TODO: Implement Facebook login
    debugPrint('Facebook login pressed');
  }
}
