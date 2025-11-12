import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';

class MilestoneCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int current;
  final int total;
  final VoidCallback? onTap;

  const MilestoneCard({
    super.key,
    required this.icon,
    required this.title,
    required this.current,
    required this.total,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Neumorphism colors - giống TopicCard
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

    return AspectRatio(
      aspectRatio: 1.0, // Square cards for 2x2 grid
      child: Container(
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon in top right
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: neuTextColor,
                    ),
                  ),
                  const SizedBox(height: AppSizes.s4),
                  // Progress
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$current',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: neuTextColor,
                        ),
                      ),
                      Text(
                        '/$total',
                        style: TextStyle(
                          fontSize: 18,
                          color: neuTextColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

