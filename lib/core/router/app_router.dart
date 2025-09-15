import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

/// App routes configuration using GoRouter
class AppRouter {
  static const String home = '/';
  static const String login = '/login';
  static const String profile = '/profile';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
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
