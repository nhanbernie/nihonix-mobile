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

        const SizedBox(height: 16),

        // Social login buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconButton(
              context,
              icon: _buildGoogleIcon(),
              onPressed: _handleGoogleLogin,
            ),
            const SizedBox(width: AppSizes.s16),
            _buildIconButton(
              context,
              icon: _buildFacebookIcon(),
              onPressed: _handleFacebookLogin,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        child: Center(child: icon),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.g_mobiledata,
          color: Color(0xFF4285F4), // Google blue
          size: 20,
        ),
      ),
    );
  }

  Widget _buildFacebookIcon() {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        color: Color(0xFF1877F2), // Facebook blue
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.facebook,
          color: Colors.white,
          size: 20,
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
