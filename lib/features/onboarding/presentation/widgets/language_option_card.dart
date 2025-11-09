import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';

class LanguageOptionCard extends StatelessWidget {
  final String flag;
  final String languageName;
  final String languageCode;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageOptionCard({
    super.key,
    required this.flag,
    required this.languageName,
    required this.languageCode,
    required this.isSelected,
    required this.onTap,
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
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s24,
            vertical: AppSizes.s20,
          ),
          decoration: BoxDecoration(
            color: isSelected ? null : neuBgColor,
            gradient: isSelected
                ? const LinearGradient(
                    colors: [
                      Color(0xFFFF8A3D), // Primary cam
                      Color(0xFFFF7028), // Cam đậm hơn
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
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
              // Flag emoji
              Text(
                flag,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: AppSizes.s20),
              
              // Language name
              Expanded(
                child: Text(
                  languageName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppColors.onBackgroundDark
                                : AppColors.onBackground),
                      ),
                ),
              ),
              
              // Check icon if selected
              if (isSelected)
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

