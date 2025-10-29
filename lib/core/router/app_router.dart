import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/welcome/presentation/pages/welcome_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../storage/welcome_preferences.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/verify_code_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';

/// App routes configuration using GoRouter
class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String forgotPassword = '/forgotPassword';
  static const String verifyCode = '/verifyCode';
  static const String resetPassword = '/resetPassword';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    redirect: (context, state) async {
      try {
        final location = state.matchedLocation;
        final prefs = WelcomePreferences();
        final isFirstTime = await prefs.isFirstTime();

        // Get auth state from Riverpod
        final container = ProviderScope.containerOf(context);
        final authState = container.read(authProvider);

        if (location == splash) {
          // Splash page should handle its own navigation
          return null;
        }

        // Welcome page protection
        if (location == welcome) {
          // If already seen welcome, redirect to home
          if (!isFirstTime) {
            return home;
          }
          return null;
        }

        // Home and other routes protection
        if (isFirstTime && location != splash && location != welcome) {
          // First time user trying to access other routes → show welcome
          return welcome;
        }

        // Authentication guard
        if (location == home || location == profile) {
          // If not authenticated, redirect to login
          if (!authState.isAuthenticated) {
            return login;
          }
        }

        // If authenticated and trying to access login, redirect to home
        if (location == login && authState.isAuthenticated) {
          return home;
        }

        return null;
      } catch (e) {
        // Fallback to welcome page
        return welcome;
      }
    },
    routes: [
      // Splash route
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Welcome route
      GoRoute(
        path: welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomePage(),
      ),

      // Home route
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // Auth routes
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      GoRoute(
        path: forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // Verify code route
      GoRoute(
        path: verifyCode,
        name: 'verifyCode',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return VerifyCodePage(email: email);
        },
      ),

      // Reset password route
      GoRoute(
        path: resetPassword,
        name: 'resetPassword',
        builder: (context, state) => const ResetPasswordPage(),
      ),

      // Profile route
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) {
          // Get userId from query parameters
          final userId = state.uri.queryParameters['userId'] ?? '1';
          return ProfilePage(userId: int.tryParse(userId) ?? 1);
        },
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Lỗi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Trang không tồn tại',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Đường dẫn: ${state.uri}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Về trang chủ'),
            ),
          ],
        ),
      ),
    ),
  );
}
