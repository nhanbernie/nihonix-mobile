import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';

class LevelCard extends StatelessWidget {
  final String code;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback? onTap;

  const LevelCard({
    super.key,
    required this.code,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.isSelected,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Neumorphism colors
    const neuBgColorLight = Color.fromARGB(255, 243, 243, 243);
    const neuBgColorDark = Color(0xFF2A2A2A);
    final neuBgColor = isDark ? neuBgColorDark : neuBgColorLight;

    final neuDarkShadow = isDark
        ? Colors.black.withOpacity(0.5)
        : Colors.black.withOpacity(0.2);
    final neuLightShadow = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.white.withOpacity(0.8);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppSizes.s20),
          decoration: BoxDecoration(
            color: isSelected ? null : neuBgColor,
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      color,
                      color.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(24),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    // Dark shadow (bottom-right)
                    BoxShadow(
                      color: neuDarkShadow,
                      blurRadius: 10,
                      offset: const Offset(4, 4),
                    ),
                    // Light shadow (top-left)
                    BoxShadow(
                      color: neuLightShadow,
                      blurRadius: 10,
                      offset: const Offset(-4, -4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(AppSizes.s12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: isSelected ? Colors.white : color,
                ),
              ),
              const SizedBox(width: AppSizes.s16),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                    ? AppColors.onBackgroundDark
                                    : AppColors.onBackground),
                          ),
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? Colors.white.withOpacity(0.9)
                                : (isDark
                                    ? AppColors.onBackgroundDark.withOpacity(0.7)
                                    : AppColors.onBackground.withOpacity(0.7)),
                          ),
                    ),
                  ],
                ),
              ),

              // Loading or check icon
              if (isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

