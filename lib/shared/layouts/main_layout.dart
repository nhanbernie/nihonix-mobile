import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/shared/widgets/app_bottom_nav_bar.dart';

const routes = [
  AppRoutes.home,
  AppRoutes.lesson,
  AppRoutes.profile,
];

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final currentIndex = routes.indexOf(currentPath);
    final colorScheme = Theme.of(context).colorScheme;

    // Ẩn bottom nav nếu đang ở nested route (ví dụ: /profile/edit)
    final showBottomNav = currentIndex != -1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: colorScheme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: colorScheme.brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            colorScheme.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        extendBody: true,
        body: child,
        bottomNavigationBar:
            showBottomNav ? AppBottomNavBar(currentIndex: currentIndex) : null,
      ),
    );
  }
}
