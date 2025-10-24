import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFFFF6B35);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Background
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onBackgroundDark = Color(0xFFFFFFFF);

  // Surface
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color onSurface = Color(0xFF000000);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);

  // Accent
  static const Color accent1 = Color(0xFFDCC1FF);
  static const Color accent2 = Color(0xFFF5F378);
  static const Color accent3 = Color(0xFF4EF4A5);
  static const Color onAccent = Color(0xFF000000);

  // Semantic
  static const Color error = Color(0xFFFF3B30);
  static const Color onError = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF4EF4A5);
  static const Color onSuccess = Color(0xFF000000);

  static const Color warning = Color(0xFFF5F378);
  static const Color onWarning = Color(0xFF000000);

  // Neutral
  static const Color neutral = Color(0xFF000000);
  static const Color neutralLight = Color(0xFFFFFFFF);
  static const Color neutralGrey = Color(0xFF808080);
  static const Color neutralGreyLight = Color(0xFFE0E0E0);
  static const Color neutralGreyDark = Color(0xFF404040);

  // Legacy aliases
  static const Color white = neutralLight;
  static const Color black = neutral;
  static const Color grey = neutralGrey;
  static const Color greyLight = neutralGreyLight;
  static const Color greyDark = neutralGreyDark;

  static const Color textPrimary = onBackground;
  static const Color textSecondary = neutralGrey;
  static const Color textHint = neutralGreyLight;

  static const Color secondary = primary;
  static const Color secondaryDark = primary;
  static const Color secondaryLight = primary;

  static const Color surfaceVariant = surface;
  static const Color surfaceVariantDark = surfaceDark;

  static const Color primaryDark = primary;
  static const Color primaryLight = primary;

  static const Color info = primary;
}
