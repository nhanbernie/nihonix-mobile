import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'route_constants.dart';
import 'route_builder.dart';
import 'route_guard.dart';
import 'router_refresh_notifier.dart';

/// Main router orchestrator for the app
class AppRouter {
  /// Creates a GoRouter that refreshes when auth state changes
  /// Use this in main.dart with ConsumerWidget/ConsumerStatefulWidget
  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: RouterRefreshNotifier(ref),
      redirect: handleRouteGuard,
      routes: buildAppRoutes(),
      errorBuilder: buildErrorPage,
    );
  }

  // Keep static router for backward compatibility
  // Note: This won't refresh automatically. Use createRouter in main.dart instead
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: handleRouteGuard,
    routes: buildAppRoutes(),
    errorBuilder: buildErrorPage,
  );
}
