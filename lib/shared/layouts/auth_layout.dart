import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_sizes.dart';
import '../../features/auth/presentation/widgets/social_login_buttons.dart';

/// Auth layout with gradient background and illustration
class AuthLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool showSocialLogin;
  final String? illustrationPath;
  final Widget? bottomContent;

  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showSocialLogin = false,
    this.illustrationPath,
    this.bottomContent,
  });

  @override
  Widget build(BuildContext context) {
    final hasIllustration = illustrationPath != null;
    final colorScheme = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: colorScheme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: colorScheme.brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            colorScheme.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Decorative element
            Positioned(
              right: -30,
              bottom: 200,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: _buildContent(context, hasIllustration),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool hasIllustration) {
    final content = Column(
      mainAxisSize: hasIllustration ? MainAxisSize.max : MainAxisSize.min,
      children: [
        // Illustration
        if (hasIllustration) ...[
          _buildIllustration(),
          const SizedBox(height: AppSizes.s32),
        ],

        // Header
        _buildHeader(context),

        // Form content
        child,

        const SizedBox(height: AppSizes.s24),

        // Social login
        if (showSocialLogin) const SocialLoginButtons(),

        // Bottom content
        if (bottomContent != null) ...[
          const SizedBox(height: AppSizes.s24),
          bottomContent!,
        ],
      ],
    );

    if (hasIllustration) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: content,
      );
    }

    // Center content when no illustration, but allow scrolling when keyboard appears
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.s24),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(child: content),
      ),
    );
  }

  Widget _buildIllustration() {
    return SizedBox(
      width: 160,
      height: 160,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.s16),
        child: Image.asset(
          illustrationPath!,
          fit: BoxFit.cover,
          cacheWidth: 320,
          cacheHeight: 320,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          title,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.s8),
        Text(
          subtitle,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.s32),
      ],
    );
  }
}
