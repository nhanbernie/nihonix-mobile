import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/storage/welcome_preferences.dart';

/// Splash Screen với animation
/// - Hiển thị logo và tên app
/// - Decorative icons học tập theme
/// - Duration: 4 giây
/// - Auto navigate đến Welcome hoặc Home
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _floatController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSplashSequence();
  }

  void _setupAnimations() {
    // Fade animation (0-1s)
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Scale animation (0-1s)
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    // Float animation (loop, starts after 1s)
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();

    // Start floating animation after 1s
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _floatController.repeat(reverse: true);
      }
    });
  }

  Future<void> _startSplashSequence() async {
    // Wait 4 seconds
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    // Check if first time to determine where to go
    final prefs = WelcomePreferences();
    final isFirstTime = await prefs.isFirstTime();

    if (!mounted) return;

    // Navigate - Router redirect will handle protection
    if (isFirstTime) {
      context.go(AppRouter.welcome);
    } else {
      context.go(AppRouter.home);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _floatController.dispose();
    super.dispose();
  }

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
                    AppColors.primary.withOpacity(0.15),
                  ],
                ),
              ),
            ),

            // Decorative icon - Top left
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Positioned(
                  left: size.width * 0.1,
                  top: size.height * 0.15,
                  child: Transform.translate(
                    offset: Offset(0, _floatAnimation.value * 0.5),
                    child: Opacity(
                      opacity: _fadeAnimation.value * 0.6,
                      child: Icon(
                        Icons.lightbulb_outline,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Decorative icon - Top right
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Positioned(
                  right: size.width * 0.15,
                  top: size.height * 0.2,
                  child: Transform.translate(
                    offset: Offset(0, -_floatAnimation.value * 0.3),
                    child: Opacity(
                      opacity: _fadeAnimation.value * 0.5,
                      child: Icon(
                        Icons.star_outline,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Decorative icon - Bottom left
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Positioned(
                  left: size.width * 0.15,
                  bottom: size.height * 0.25,
                  child: Transform.translate(
                    offset: Offset(0, _floatAnimation.value * 0.4),
                    child: Opacity(
                      opacity: _fadeAnimation.value * 0.5,
                      child: Icon(
                        Icons.auto_stories_outlined,
                        size: 35,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Decorative icon - Bottom right
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Positioned(
                  right: size.width * 0.1,
                  bottom: size.height * 0.2,
                  child: Transform.translate(
                    offset: Offset(0, -_floatAnimation.value * 0.6),
                    child: Opacity(
                      opacity: _fadeAnimation.value * 0.6,
                      child: Icon(
                        Icons.translate,
                        size: 38,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main icon with scale animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Icon(
                        Icons.school,
                        size: 100,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // App name with fade and slide
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _fadeController,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          AppStrings.appName,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                letterSpacing: 1.5,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tagline
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Learn Japanese, Unlock Opportunities',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
