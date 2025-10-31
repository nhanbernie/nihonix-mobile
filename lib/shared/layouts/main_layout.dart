import 'package:flutter/material.dart';
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

    // Ẩn bottom nav nếu đang ở nested route (ví dụ: /profile/edit)
    final showBottomNav = currentIndex != -1;

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar:
          showBottomNav ? AppBottomNavBar(currentIndex: currentIndex) : null,
    );
  }
}
