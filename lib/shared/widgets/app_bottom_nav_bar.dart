import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_strings.dart';
import 'package:nihonix/core/router/route_constants.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.lesson);
        break;
      case 2:
        context.go(AppRoutes.flashcard);
        break;
      case 3:
        context.go(AppRoutes.practice);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: bottomPadding + 16, // SafeArea bottom + extra space for shadow
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavItem(context, 0, Icons.home_rounded, AppStrings.home),
          const SizedBox(width: 8),
          _buildNavItem(context, 1, Icons.menu_book_rounded, AppStrings.lesson),
          const SizedBox(width: 8),
          _buildNavItem(context, 2, Icons.style_rounded, AppStrings.flashcard),
          const SizedBox(width: 8),
          _buildNavItem(
              context, 3, Icons.psychology_rounded, AppStrings.practice),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isSelected = currentIndex == index;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Neomorphism colors - khai báo cụ thể
    const neuBgColorLight = Color.fromARGB(255, 243, 243, 243);
    const neuBgColorDark = Color(0xFF2A2A2A);
    const neuLightShadowLight = Color(0xFFFFFFFF);
    const neuLightShadowDark = Color(0xFF3A3A3A);
    const neuDarkShadowLight = Color(0xFFBCBCBC);
    const neuDarkShadowDark = Color(0xFF1A1A1A);
    // const neuBorderColorLight = Color(0xFFCECECE);
    // const neuBorderColorDark = Color(0xFF353535);
    const neuIconColorLight = Color(0xFF4D4D4D);
    const neuIconColorDark = Color(0xFF9E9E9E);

    final neuBgColor = isDark ? neuBgColorDark : neuBgColorLight;
    final neuLightShadow = isDark ? neuLightShadowDark : neuLightShadowLight;
    final neuDarkShadow = isDark ? neuDarkShadowDark : neuDarkShadowLight;
    // final neuBorderColor = isDark ? neuBorderColorDark : neuBorderColorLight;
    final neuIconColor = isDark ? neuIconColorDark : neuIconColorLight;

    return GestureDetector(
      onTap: () => _navigate(context, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
            : const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : neuBgColor,
          borderRadius: BorderRadius.circular(50),
          // border: isSelected
          //     ? null
          //     : Border.all(
          //         color: neuBorderColor,
          //         width: 2,
          //       ),
          boxShadow: isSelected
              ? [
                  // Outer glow for selected - giảm shadow
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ]
              : [
                  // Neomorphism shadow - dark shadow (bottom-right)
                  BoxShadow(
                    color: neuDarkShadow,
                    blurRadius: 10,
                    offset: const Offset(4, 4),
                    spreadRadius: 0,
                  ),
                  // Neomorphism shadow - light shadow (top-left)
                  BoxShadow(
                    color: neuLightShadow,
                    blurRadius: 10,
                    offset: const Offset(-4, -4),
                    spreadRadius: 0,
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon với scale animation
            AnimatedScale(
              scale: isSelected ? 1.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutBack,
              child: Icon(
                icon,
                color: isSelected ? AppColors.onPrimary : neuIconColor,
                size: 24,
              ),
            ),
            // Text với animated size và fade
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              child: isSelected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8),
                        AnimatedOpacity(
                          opacity: isSelected ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          child: Text(
                            label,
                            style: const TextStyle(
                              color: AppColors.onPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
