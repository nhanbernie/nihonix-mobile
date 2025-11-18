import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/core/theme/theme_provider.dart';
import 'package:nihonix/features/auth/presentation/providers/auth_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_action_button.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Fixed Header + Profile + Progress (không cuộn)
            ProfileHeader(user: user),

            // Scrollable Action Buttons
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
                child: Column(
                  children: [
                    const SizedBox(height: AppSizes.s16),
                    ProfileActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Sửa thông tin',
                      onTap: () => context.push(AppRoutes.profileEdit),
                    ),
                    const SizedBox(height: AppSizes.s12),
                    ProfileActionButton(
                      icon: Icons.dark_mode_outlined,
                      label: 'Chế độ tối',
                      onTap: () =>
                          ref.read(themeProvider.notifier).toggleTheme(),
                    ),
                    const SizedBox(height: AppSizes.s12),
                    ProfileActionButton(
                      icon: Icons.logout,
                      label: 'Đăng xuất',
                      onTap: () => _handleLogout(context, ref),
                      isDestructive: true,
                    ),
                    const SizedBox(height: AppSizes.s24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) {
        context.go(AppRoutes.login);
      }
    }
  }
}
