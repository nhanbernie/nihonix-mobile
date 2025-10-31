import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:nihonix/core/constants/app_strings.dart';
import 'package:nihonix/core/router/route_constants.dart';

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
      body: SafeArea(
        child: child,
      ),
      bottomNavigationBar: showBottomNav
          ? Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                elevation: 0,
                currentIndex: currentIndex != -1 ? currentIndex : 0,
                onTap: (i) {
                  switch (i) {
                    case 0:
                      context.go(AppRoutes.home);
                      break;
                    case 1:
                      context.go(AppRoutes.lesson);
                      break;
                    case 2:
                      context.go(AppRoutes.profile);
                      break;
                  }
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: AppStrings.home),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.book), label: AppStrings.lesson),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: AppStrings.profile),
                ],
              ),
            )
          : null,
    );
  }
}
