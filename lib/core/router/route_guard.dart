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

    // Check first time user preference
    final isFirstTime = await _welcomePrefs.isFirstTime();

    // Get auth state from Riverpod
    final container = ProviderScope.containerOf(context);
    final authState = container.read(authProvider);

    // Welcome page protection
    if (location == AppRoutes.welcome) {
      // If already seen welcome, redirect to home
      if (!isFirstTime) {
        return AppRoutes.home;
      }
      return null;
    }

    // Home and other routes protection
    if (isFirstTime &&
        location != AppRoutes.splash &&
        location != AppRoutes.welcome) {
      // First time user trying to access other routes → show welcome
      return AppRoutes.welcome;
    }

    // Authentication guard for protected routes
    if (AppRoutes.protectedRoutes.contains(location)) {
      if (!authState.isAuthenticated) {
        return AppRoutes.login;
      }
    }

    // Redirect authenticated users away from auth routes
    if (AppRoutes.authRoutes.contains(location) && authState.isAuthenticated) {
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
    // Fallback to welcome page
    return AppRoutes.welcome;
  }
}
