import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/constants/app_strings.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/auth/presentation/providers/auth_provider.dart';
import 'package:nihonix/features/home/presentation/widgets/home_app_bar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      // kéo lên trên app bar để nhìn fullsize 
      extendBodyBehindAppBar: true,
      appBar: const HomeAppBar(),
      body: ListView.builder(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight + AppSizes.s16,
          left: AppSizes.s16,
          right: AppSizes.s16,
          bottom: MediaQuery.of(context).padding.bottom + 100, // Bottom system + nav bar space
        ),
        itemCount: 51, // 1 welcome card + 50 items
        itemBuilder: (context, index) {
            // Welcome card ở đầu
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.s20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.flutter_dash,
                            size: AppSizes.iconXLarge,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: AppSizes.s16),
                          Text(
                            'Chào mừng ${authState.user?.name ?? 'User'}!',
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
                  const SizedBox(height: AppSizes.s16),
                  Text(
                    'Danh sách test scroll',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSizes.s8),
                ],
              );
            }

            // List items
            final itemIndex = index - 1;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.s12),
              child: Card(
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      '${itemIndex + 1}',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text('Item ${itemIndex + 1}'),
                  subtitle: Text('Mô tả cho item số ${itemIndex + 1}'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bạn đã chọn item ${itemIndex + 1}'),
                        duration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
    );
  }
}
