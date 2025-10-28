import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/welcome/presentation/pages/welcome_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../storage/welcome_preferences.dart';

/// App routes configuration using GoRouter
class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String profile = '/profile';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    redirect: (context, state) async {
      final location = state.matchedLocation;
      final prefs = WelcomePreferences();
      final isFirstTime = await prefs.isFirstTime();
      
      // Splash logic: Only show on first app start
      if (location == splash) {
        // If already seen welcome, skip splash and go directly to home
        if (!isFirstTime) {
          return home;
        }
        // First time: allow splash to show
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

      return null;
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
