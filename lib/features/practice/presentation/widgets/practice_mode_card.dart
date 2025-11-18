import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_sizes.dart';

class PracticeModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const PracticeModeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
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

    final neuBgColor = isDark ? neuBgColorDark : neuBgColorLight;
    final neuLightShadow = isDark ? neuLightShadowDark : neuLightShadowLight;
    final neuDarkShadow = isDark ? neuDarkShadowDark : neuDarkShadowLight;

    return Container(
      decoration: BoxDecoration(
        color: neuBgColor,
        borderRadius: BorderRadius.circular(30),
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
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.s16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 40,
                  ),
                ),
                const SizedBox(height: AppSizes.s12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4D4D4D),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF808080),
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
