import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Slide 1: Hero with Image
/// Focus: Brand introduction with welcome image
class WelcomeSlide1 extends StatelessWidget {
  const WelcomeSlide1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s24,
            vertical: AppSizes.s32,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSizes.s48),

              // Large welcome image
              Image.asset(
                'assets/images/welcome_illustration.png.png',
                height: 280,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: AppSizes.s48),

              // Title
              Text(
                'Master\nJapanese\nLanguage',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      color: AppColors.textPrimary,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.s24),

              // Description
              Text(
                'Start your journey to fluency with\ninteractive lessons and real-world practice',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.s48),
            ],
          ),
        ),
      ),
    );
  }
}

