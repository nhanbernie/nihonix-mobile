import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
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
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        body: Stack(
          children: [
            // Simplified background
            Container(
              color: AppColors.background,
            ),

            // Simplified decorative element (removed CustomPaint for performance)
            Positioned(
              right: -30,
              bottom: size.height * 0.2,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),

            // Main content
            Positioned.fill(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.s24),
                  child: Column(
                    children: [
                      // Illustration with cache
                      if (illustrationPath != null) ...[
                        // SizedBox(
                        //   height: 250,
                        //   child: Image.asset(
                        //     illustrationPath!,
                        //     fit: BoxFit.contain,
                        //     cacheWidth: 400, // Cache for performance
                        //     cacheHeight: 250,
                        //   ),
                        // ),
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(AppSizes.s16),
                        //   child: AspectRatio(
                        //     aspectRatio: 1/1,
                        //     child: Image.asset(
                        //       illustrationPath!,
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          width: 160, 
                          height: 160, 
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppSizes.s16),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Image.asset(
                                illustrationPath!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSizes.s32),
                      ],

                      // Title & Subtitle
                      Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.s8),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppSizes.s32),

                      // Form Content
                      child,

                      const SizedBox(height: AppSizes.s24),

                      // Social Login
                      if (showSocialLogin) const SocialLoginButtons(),

                      // Bottom content
                      if (bottomContent != null) ...[
                        const SizedBox(height: AppSizes.s24),
                        bottomContent!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
