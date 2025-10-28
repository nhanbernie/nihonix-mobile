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
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background,
                    AppColors.primary.withOpacity(0.03),
                  ],
                ),
              ),
            ),

            // Decorative curved shapes (bottom right)
            Positioned(
              right: -50,
              bottom: size.height * 0.15,
              child: CustomPaint(
                size: Size(size.width * 0.8, size.height * 0.4),
                painter: _DecorativeCurvesPainter(),
              ),
            ),

            // Main content
            Positioned.fill(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.s24),
                  child: Column(
                    children: [
                      // Illustration
                      if (illustrationPath != null) ...[
                        Image.asset(
                          illustrationPath!,
                          height: 200,
                          fit: BoxFit.contain,
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

/// NOTE
class _DecorativeCurvesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    // First curve (top)
    final path1 = Path();
    path1.moveTo(0, size.height * 0.3);
    path1.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.25,
      size.width * 0.6,
      size.height * 0.35,
    );
    path1.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.42,
      size.width,
      size.height * 0.4,
    );
    path1.lineTo(size.width, size.height * 0.5);
    path1.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.52,
      size.width * 0.6,
      size.height * 0.45,
    );
    path1.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.35,
      0,
      size.height * 0.4,
    );
    path1.close();

    // Second curve (bottom)
    final path2 = Path();
    path2.moveTo(0, size.height * 0.6);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.55,
      size.width * 0.6,
      size.height * 0.65,
    );
    path2.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.72,
      size.width,
      size.height * 0.7,
    );
    path2.lineTo(size.width, size.height * 0.8);
    path2.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.82,
      size.width * 0.6,
      size.height * 0.75,
    );
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.65,
      0,
      size.height * 0.7,
    );
    path2.close();

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
