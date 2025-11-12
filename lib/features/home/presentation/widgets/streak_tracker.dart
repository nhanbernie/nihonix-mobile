import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';

class StreakTracker extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final List<bool> weekProgress; // 7 days, true = completed

  const StreakTracker({
    super.key,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.weekProgress = const [true, true, true, false, false, false, false],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    // Neumorphism colors for container
    const neuBgColorLight = Color.fromARGB(255, 243, 243, 243);
    const neuBgColorDark = Color(0xFF2A2A2A);
    const neuLightShadowLight = Color(0xFFFFFFFF);
    const neuLightShadowDark = Color(0xFF3A3A3A);
    const neuDarkShadowLight = Color(0xFFBCBCBC);
    const neuDarkShadowDark = Color(0xFF1A1A1A);

    final neuBgColor = isDark ? neuBgColorDark : neuBgColorLight;
    final neuLightShadow = isDark ? neuLightShadowDark : neuLightShadowLight;
    final neuDarkShadow = isDark ? neuDarkShadowDark : neuDarkShadowLight;

    return Container(
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        color: neuBgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          // Dark shadow (bottom-right)
          BoxShadow(
            color: neuDarkShadow,
            blurRadius: 10,
            offset: const Offset(4, 4),
            spreadRadius: 0,
          ),
          // Light shadow (top-left)
          BoxShadow(
            color: neuLightShadow,
            blurRadius: 10,
            offset: const Offset(-4, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Streak Tracker',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Keep it going! 🔥',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.s20),

          // Current & Longest Streak
          Row(
            children: [
              Expanded(
                child: _StreakStat(
                  label: 'Current',
                  value: currentStreak,
                  icon: Icons.local_fire_department_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: _StreakStat(
                  label: 'Longest',
                  value: longestStreak,
                  icon: Icons.emoji_events_rounded,
                  color: AppColors.accent4,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.s20),

          // Week Progress
          Text(
            'This Week',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: AppSizes.s12),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              final isCompleted = index < weekProgress.length && weekProgress[index];
              final isToday = index == 3; // Example: Thursday is today

              return _DayCircle(
                day: days[index],
                isCompleted: isCompleted,
                isToday: isToday,
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StreakStat extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const _StreakStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Neumorphism colors
    const neuBgColorLight = Color.fromARGB(255, 243, 243, 243);
    const neuBgColorDark = Color(0xFF2A2A2A);
    const neuLightShadowLight = Color(0xFFFFFFFF);
    const neuLightShadowDark = Color(0xFF3A3A3A);
    const neuDarkShadowLight = Color(0xFFBCBCBC);
    const neuDarkShadowDark = Color(0xFF1A1A1A);
    const neuTextColorLight = Color(0xFF4D4D4D);
    const neuTextColorDark = Color(0xFF9E9E9E);

    final neuBgColor = isDark ? neuBgColorDark : neuBgColorLight;
    final neuLightShadow = isDark ? neuLightShadowDark : neuLightShadowLight;
    final neuDarkShadow = isDark ? neuDarkShadowDark : neuDarkShadowLight;
    final neuTextColor = isDark ? neuTextColorDark : neuTextColorLight;

    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: neuBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Dark shadow (bottom-right)
          BoxShadow(
            color: neuDarkShadow,
            blurRadius: 8,
            offset: const Offset(3, 3),
            spreadRadius: 0,
          ),
          // Light shadow (top-left)
          BoxShadow(
            color: neuLightShadow,
            blurRadius: 8,
            offset: const Offset(-3, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: AppSizes.s8),
          Text(
            '$value days',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: neuTextColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: neuTextColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCircle extends StatelessWidget {
  final String day;
  final bool isCompleted;
  final bool isToday;

  const _DayCircle({
    required this.day,
    required this.isCompleted,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Neumorphism colors for incomplete days
    const neuBgColorLight = Color.fromARGB(255, 243, 243, 243);
    const neuBgColorDark = Color(0xFF2A2A2A);
    const neuTextColorLight = Color(0xFF4D4D4D);
    const neuTextColorDark = Color(0xFF9E9E9E);

    final neuBgColor = isDark ? neuBgColorDark : neuBgColorLight;
    final neuTextColor = isDark ? neuTextColorDark : neuTextColorLight;

    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.primary
                : neuBgColor,
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(
                    color: AppColors.primary,
                    width: 2,
                  )
                : null,
            boxShadow: isCompleted
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 18,
                  )
                : Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: neuTextColor.withValues(alpha: 0.5),
                    ),
                  ),
          ),
        ),
        if (isToday) ...[
          const SizedBox(height: 4),
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }
}
