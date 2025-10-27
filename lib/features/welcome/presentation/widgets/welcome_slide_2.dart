import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Slide 2: Features Grid
/// Focus: Study anywhere features
class WelcomeSlide2 extends StatelessWidget {
  const WelcomeSlide2({super.key});

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
              const SizedBox(height: AppSizes.s32),

              // Title
              Text(
                'Study\nAnywhere\nAnytime',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      color: AppColors.textPrimary,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.s48),

              // Feature icons grid
              Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _FeatureIcon(
                icon: Icons.mobile_friendly,
                label: 'Mobile',
                color: AppColors.primary,
              ),
              _FeatureIcon(
                icon: Icons.cloud_sync,
                label: 'Cloud Sync',
                color: AppColors.primary,
              ),
              _FeatureIcon(
                icon: Icons.offline_bolt,
                label: 'Offline',
                color: AppColors.primary,
              ),
            ],
          ),

          const SizedBox(height: AppSizes.s48),

          // Feature list
          _FeatureItem(
            icon: Icons.check_circle,
            text: 'Learn at your own pace',
          ),
          const SizedBox(height: AppSizes.s16),
          _FeatureItem(
            icon: Icons.check_circle,
            text: 'Offline mode available',
          ),
          const SizedBox(height: AppSizes.s16),
          _FeatureItem(
            icon: Icons.check_circle,
            text: 'Sync across all devices',
          ),

          const SizedBox(height: AppSizes.s48),
            ],
          ),
        ),
      ),
    );
  }
}

/// Feature icon widget
class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FeatureIcon({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            size: 40,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

/// Feature item widget
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

