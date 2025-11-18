import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_sizes.dart';

class FolderCard extends StatelessWidget {
  final String folderName;
  final VoidCallback? onTap;

  const FolderCard({
    super.key,
    required this.folderName,
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

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.s12),
      decoration: BoxDecoration(
        color: neuBgColor,
        borderRadius: BorderRadius.circular(12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s12,
              vertical: AppSizes.s12,
            ),
            child: Row(
              children: [
                // Folder Icon
                Icon(
                  Icons.folder_rounded,
                  color: Colors.orange.shade400,
                  size: 28,
                ),
                const SizedBox(width: AppSizes.s12),
                // Folder Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        folderName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: neuTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Folder',
                        style: TextStyle(
                          fontSize: 12,
                          color: neuTextColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: neuTextColor.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
