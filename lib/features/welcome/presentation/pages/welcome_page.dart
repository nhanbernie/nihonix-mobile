import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/storage/welcome_preferences.dart';
import '../widgets/welcome_slide_1.dart';
import '../widgets/welcome_slide_2.dart';
import '../widgets/welcome_slide_3.dart';
import '../widgets/page_indicator.dart';
import '../widgets/test_slide.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleFinish() async {
    final prefs = WelcomePreferences();
    await prefs.setNotFirstTime();

    if (mounted) {
      context.go(AppRouter.home);
    }
  }

  void _handleNext() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _handleFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLastPage = _currentPage == _totalPages - 1;
    
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
                child: Column(
                children: [
                  // PageView with slides
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: const [
                        // TestSlide(title: 'Slide 1', color: Colors.blue),
                        // TestSlide(title: 'Slide 2', color: Colors.green),
                        // TestSlide(title: 'Slide 3', color: Colors.orange),
                        WelcomeSlide1(),
                        WelcomeSlide2(),
                        WelcomeSlide3(),
                      ],
                    ),
                  ),

                  // Page Indicator
                  PageIndicator(
                    currentPage: _currentPage,
                    pageCount: _totalPages,
                  ),

                  const SizedBox(height: AppSizes.s32),

                  // Bottom navigation bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s24,
                      vertical: AppSizes.s16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Skip button
                        TextButton(
                          onPressed: _handleFinish,
                          child: Text(
                            'Skip',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),

                        // Next/Get Started button (with icon + text)
                        ElevatedButton.icon(
                          onPressed: _handleNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: const Size(0, 48),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: isLastPage
                              ? const Icon(Icons.check, size: 20)
                              : const Icon(Icons.arrow_forward, size: 20),
                          label: Text(
                            isLastPage ? 'Get Started' : 'Next',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
