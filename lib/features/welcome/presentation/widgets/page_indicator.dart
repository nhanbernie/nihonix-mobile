import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_colors.dart';

/// Page indicator (dots) widget
class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => _Dot(
          isActive: index == currentPage,
        ),
      ),
    );
  }
}

/// Single dot widget
class _Dot extends StatelessWidget {
  final bool isActive;

  const _Dot({
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.neutralGreyLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
