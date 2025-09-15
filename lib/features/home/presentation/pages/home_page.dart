import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRouter.profile),
            icon: const Icon(Icons.person),
            tooltip: AppStrings.profile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.s20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.flutter_dash,
                      size: AppSizes.iconXLarge,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: AppSizes.s16),
                    Text(
                      AppStrings.welcome,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.s8),
                    Text(
                      AppStrings.welcomeMessage,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSizes.s24),

            // Features section
            Text(
              'Tính năng demo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.s16),

            // Navigation buttons
            ElevatedButton.icon(
              onPressed: () => context.push(AppRouter.login),
              icon: const Icon(Icons.login),
              label: const Text(AppStrings.login),
            ),

            const SizedBox(height: AppSizes.s12),

            ElevatedButton.icon(
              onPressed: () => context.push('${AppRouter.profile}?userId=123'),
              icon: const Icon(Icons.person),
              label: const Text('Xem Profile (User #123)'),
            ),

            const SizedBox(height: AppSizes.s12),

            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chức năng đang phát triển!'),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
              label: const Text(AppStrings.settings),
            ),

            const Spacer(),

            // Bottom info
            Container(
              padding: const EdgeInsets.all(AppSizes.s16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Column(
                children: [
                  Text(
                    'Flutter Architecture 2025',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSizes.s4),
                  Text(
                    'Clean Architecture + Riverpod + GoRouter',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
