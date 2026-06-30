import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

// Định nghĩa ColorScheme chi tiết cho light/dark
final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: AppColors.white,
  secondary: AppColors.secondary,
  onSecondary: AppColors.white,
  error: AppColors.error,
  onError: AppColors.white,
  surface: AppColors.surface,
  onSurface: AppColors.textPrimary,
  surfaceContainerHighest: AppColors.surfaceVariant,
  onSurfaceVariant: AppColors.textSecondary,
  outline: AppColors.grey,
  outlineVariant: AppColors.greyLight,
  inverseSurface: AppColors.greyDark,
  inversePrimary: AppColors.primary,
  shadow: AppColors.greyDark,
  scrim: AppColors.greyDark,
  tertiary: AppColors.secondary,
  onTertiary: AppColors.white,
);

final ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.primary,
  onPrimary: AppColors.white,
  secondary: AppColors.secondary,
  onSecondary: AppColors.white,
  error: AppColors.error,
  onError: AppColors.white,
  surface: AppColors.surfaceDark,
  onSurface: AppColors.white,
  surfaceContainerHighest: AppColors.surfaceVariantDark,
  onSurfaceVariant: AppColors.textSecondary,
  outline: AppColors.grey,
  outlineVariant: AppColors.greyLight,
  inverseSurface: AppColors.greyDark,
  inversePrimary: AppColors.primary,
  shadow: AppColors.greyDark,
  scrim: AppColors.greyDark,
  tertiary: AppColors.secondary,
  onTertiary: AppColors.white,
);

// Tách textTheme riêng
final TextTheme appTextTheme = TextTheme(
  bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
  bodyMedium: TextStyle(fontSize: 14, color: AppColors.textPrimary),
  bodySmall: TextStyle(fontSize: 12, color: AppColors.textSecondary),
  titleLarge: TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
  titleMedium: TextStyle(
      fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
  titleSmall: TextStyle(
      fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
);

/// App theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: AppSizes.appBarElevation,
        surfaceTintColor: Colors.transparent,
        backgroundColor: lightColorScheme.surface,
        titleTextStyle: appTextTheme.titleMedium
            ?.copyWith(color: lightColorScheme.onSurface),
        iconTheme: IconThemeData(color: lightColorScheme.onSurface),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Brightness.dark, // Dark icons for light theme
          statusBarBrightness: Brightness.light, // For iOS
          systemNavigationBarColor: lightColorScheme.surface,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s12,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          side: BorderSide(color: lightColorScheme.primary),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.textFieldBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.textFieldBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.textFieldBorderRadius),
          borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.textFieldBorderRadius),
          borderSide: BorderSide(color: lightColorScheme.error, width: 1),
        ),
        contentPadding: const EdgeInsets.all(AppSizes.s16),
      ),
      cardTheme: CardThemeData(
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        color: lightColorScheme.surface,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: lightColorScheme.primary,
        unselectedItemColor: lightColorScheme.outline,
        elevation: 8,
        backgroundColor: lightColorScheme.surface,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightColorScheme.inverseSurface,
        contentTextStyle: appTextTheme.bodyMedium
            ?.copyWith(color: lightColorScheme.onInverseSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      textTheme: appTextTheme.apply(
          bodyColor: darkColorScheme.onSurface,
          displayColor: darkColorScheme.onSurface),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: AppSizes.appBarElevation,
        surfaceTintColor: Colors.transparent,
        backgroundColor: darkColorScheme.surface,
        titleTextStyle: appTextTheme.titleMedium
            ?.copyWith(color: darkColorScheme.onSurface),
        iconTheme: IconThemeData(color: darkColorScheme.onSurface),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Brightness.light, // Light icons for dark theme
          statusBarBrightness: Brightness.dark, // For iOS
          systemNavigationBarColor: darkColorScheme.surface,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s12,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          side: BorderSide(color: darkColorScheme.primary),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.textFieldBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.textFieldBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.textFieldBorderRadius),
          borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.textFieldBorderRadius),
          borderSide: BorderSide(color: darkColorScheme.error, width: 1),
        ),
        contentPadding: const EdgeInsets.all(AppSizes.s16),
      ),
      cardTheme: CardThemeData(
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        color: darkColorScheme.surface,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: darkColorScheme.primary,
        unselectedItemColor: darkColorScheme.outline,
        elevation: 8,
        backgroundColor: darkColorScheme.surface,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkColorScheme.inverseSurface,
        contentTextStyle: appTextTheme.bodyMedium
            ?.copyWith(color: darkColorScheme.onInverseSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
