import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/features/auth_pages.dart';
import 'package:nihonix/features/main_pages.dart';
import 'package:nihonix/shared/layouts/main_layout.dart';
import 'route_constants.dart';

List<RouteBase> buildAppRoutes() {
  return [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splashName,
      builder: (context, state) => const SplashPage(),
    ),

    GoRoute(
      path: AppRoutes.welcome,
      name: AppRoutes.welcomeName,
      builder: (context, state) => const WelcomePage(),
    ),

    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.loginName,
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: AppRoutes.register,
      name: AppRoutes.registerName,
      builder: (context, state) => const RegisterPage(),
    ),

    // Main shell with bottom navigation
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.homeName,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.lesson,
          name: AppRoutes.lessonName,
          builder: (context, state) => const LessonPage(),
        ),
        GoRoute(
          path: AppRoutes.flashcard,
          name: AppRoutes.flashcardName,
          builder: (context, state) => const FlashcardPage(),
        ),
        GoRoute(
          path: AppRoutes.practice,
          name: AppRoutes.practiceName,
          builder: (context, state) => const PracticePage(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          name: AppRoutes.profileName,
          builder: (context, state) {
            final userId = state.uri.queryParameters['userId'] ?? '1';
            return ProfilePage(userId: int.tryParse(userId) ?? 1);
          },
          routes: [
            GoRoute(
              path: 'edit',
              name: AppRoutes.profileEditName,
              builder: (context, state) => const ProfileEditPage(),
            ),
          ],
        ),
      ],
    ),

    // Forgot password flow
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: AppRoutes.forgotPasswordName,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.verifyCode,
      name: AppRoutes.verifyCodeName,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return VerifyCodePage(email: email);
      },
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      name: AppRoutes.resetPasswordName,
      builder: (context, state) => const ResetPasswordPage(),
    ),
  ];
}

/// Builds error page widget
Widget buildErrorPage(BuildContext context, GoRouterState state) {
  return Scaffold(
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
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Về trang chủ'),
          ),
        ],
      ),
    ),
  );
}
