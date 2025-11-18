import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/features/auth/presentation/providers/auth_provider.dart';
import 'package:nihonix/core/storage/welcome_preferences.dart';
import 'route_constants.dart';

/// Shared instance to avoid creating new objects on every redirect
final _welcomePrefs = WelcomePreferences();

/// Handles redirect logic for route protection
Future<String?> handleRouteGuard(
  BuildContext context,
  GoRouterState state,
) async {
  try {
    final location = state.matchedLocation;

    // Splash page should handle its own navigation
    if (location == AppRoutes.splash) {
      return null;
    }

    // Get auth state from Riverpod first (before async calls)
    final container = ProviderScope.containerOf(context);
    final authState = container.read(authProvider);

    // Check first time and language selection
    final isFirstTime = await _welcomePrefs.isFirstTime();
    final hasSelectedLanguage = await _welcomePrefs.hasSelectedLanguage();

    // Welcome page guard - show intro slides first time
    if (isFirstTime &&
        location != AppRoutes.welcome &&
        location != AppRoutes.splash) {
      return AppRoutes.welcome;
    }

    // Allow access to welcome page
    if (location == AppRoutes.welcome) {
      if (!isFirstTime) {
        // Already seen welcome, check language
        if (!hasSelectedLanguage) {
          return AppRoutes.languageSelection;
        }
        return authState.isAuthenticated ? AppRoutes.home : AppRoutes.login;
      }
      return null;
    }

    // Language selection guard - after welcome
    if (!hasSelectedLanguage &&
        location != AppRoutes.languageSelection &&
        location != AppRoutes.welcome &&
        location != AppRoutes.splash) {
      return AppRoutes.languageSelection;
    }

    // Allow access to language selection page
    if (location == AppRoutes.languageSelection) {
      if (hasSelectedLanguage) {
        // Already selected language, redirect based on auth
        return authState.isAuthenticated ? AppRoutes.home : AppRoutes.login;
      }
      return null;
    }

    // Level selection guard - only for authenticated users without level
    if (location == AppRoutes.levelSelection) {
      if (!authState.isAuthenticated) {
        return AppRoutes.login;
      }
      // Check if user has level_code
      final user = authState.user;
      if (user != null &&
          user.levelCode != null &&
          user.levelCode!.isNotEmpty) {
        // Already has level, go to home
        return AppRoutes.home;
      }
      return null;
    }

    // Authentication guard for protected routes
    if (AppRoutes.protectedRoutes.contains(location)) {
      if (!authState.isAuthenticated) {
        return AppRoutes.login;
      }

      // Check if authenticated user needs to select level
      final user = authState.user;
      if (user != null && (user.levelCode == null || user.levelCode!.isEmpty)) {
        return AppRoutes.levelSelection;
      }
    }

    // Redirect authenticated users away from auth routes
    if (AppRoutes.authRoutes.contains(location) && authState.isAuthenticated) {
      // Check if user needs to select level
      final user = authState.user;
      if (user != null && (user.levelCode == null || user.levelCode!.isEmpty)) {
        return AppRoutes.levelSelection;
      }
      return AppRoutes.home;
    }

    // Forgot password flow routes should redirect if authenticated
    if (AppRoutes.forgotPasswordRoutes.contains(location) &&
        authState.isAuthenticated) {
      return AppRoutes.home;
    }

    return null;
  } catch (e) {
    debugPrint('Router redirect error: $e');
    // Fallback to language selection
    return AppRoutes.languageSelection;
  }
}
