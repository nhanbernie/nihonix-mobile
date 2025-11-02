import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_sizes.dart';

class TopicCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const TopicCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Neumorphism colors - giống bottom nav bar
    const neuBgColorLight = Color.fromARGB(255, 243, 243, 243);
    const neuBgColorDark = Color(0xFF2A2A2A);
    const neuLightShadowLight = Color(0xFFFFFFFF);
    const neuLightShadowDark = Color(0xFF3A3A3A);
    const neuDarkShadowLight = Color(0xFFBCBCBC);
    const neuDarkShadowDark = Color(0xFF1A1A1A);
    const neuIconColorLight = Color(0xFF4D4D4D);
    const neuIconColorDark = Color(0xFF9E9E9E);

    final neuBgColor = isDark ? neuBgColorDark : neuBgColorLight;
    final neuLightShadow = isDark ? neuLightShadowDark : neuLightShadowLight;
    final neuDarkShadow = isDark ? neuDarkShadowDark : neuDarkShadowLight;
    final neuIconColor = isDark ? neuIconColorDark : neuIconColorLight;

    return Container(
      decoration: BoxDecoration(
        color: neuBgColor,
        borderRadius: BorderRadius.circular(20),
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
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.s16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: neuIconColor,
                  size: 32,
                ),
                const SizedBox(height: AppSizes.s8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: neuIconColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

