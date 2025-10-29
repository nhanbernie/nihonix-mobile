import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:nihonix/core/constants/app_strings.dart';

const routes = ['/home', '/lesson', '/profile'];

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final currentIndex = routes.indexOf(currentPath);

    return Scaffold(
      body: SafeArea(
        child: child,
      ),
      bottomNavigationBar: Container(
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
                context.go('/home');
                break;
              case 1:
                context.go('/lesson');
                break;
              case 2:
                context.go('/profile');
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
      ),
    );
  }
}
