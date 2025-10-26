import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/storage/welcome_preferences.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Future<void> _handleGetStarted(BuildContext context) async {
    final prefs = WelcomePreferences();
    await prefs.setNotFirstTime();

    if (context.mounted) {
      context.go(AppRouter.home);
    }
  }

  Future<void> _handleSkip(BuildContext context) async {
    final prefs = WelcomePreferences();
    await prefs.setNotFirstTime();

    if (context.mounted) {
      context.go(AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      // TRANSPARENT - Let gradient show through
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false, // Important!
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
                  AppColors.primary.withOpacity(0.03), // Ultra light orange gradient
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.s24,
                vertical: AppSizes.s32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSizes.s48),

                  // Headline text
                  Text(
                    'Empower\nYourself With\nQuick\nKnowledge',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: AppColors.textPrimary,
                        ),
                  ),

                  const SizedBox(height: AppSizes.s32),

                  // Floating Action Button
                  FloatingActionButton(
                    onPressed: () => _handleGetStarted(context),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.onPrimary,
                    ),
                  ),

                  const Spacer(),

                  // Skip button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => _handleSkip(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Skip',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.s16),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

/// Custom painter for decorative curved shapes
class _DecorativeCurvesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.08) // Ultra light orange curves
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
