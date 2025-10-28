import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Slide 3: Track Progress
/// Focus: Achievement and CTA
class WelcomeSlide3 extends StatelessWidget {
  const WelcomeSlide3({super.key});

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

              // Trophy icon
              Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 70,
              color: Colors.amber,
            ),
          ),

          const SizedBox(height: AppSizes.s48),

          // Title
          Text(
            'Track Your\nProgress',
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
            'Monitor your learning journey and\ncelebrate your achievements',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSizes.s48),

          // Progress demo
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // color: AppColors.primary.withOpacity(0.05),
              color: AppColors.primary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Learning Progress',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '50%',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.5,
                    minHeight: 8,
                    backgroundColor: AppColors.neutralGreyLight,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.s32),

          // Achievement stats
          _StatItem(icon: Icons.local_fire_department, text: '7 Day Streak'),
          const SizedBox(height: AppSizes.s12),
          _StatItem(icon: Icons.star, text: '15 Achievements'),
          const SizedBox(height: AppSizes.s12),
          _StatItem(icon: Icons.trending_up, text: '80% Completion'),

          const SizedBox(height: AppSizes.s48),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stat item widget
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _StatItem({
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
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

