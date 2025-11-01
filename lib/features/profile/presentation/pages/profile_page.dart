import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/route_constants.dart';

class ProfilePage extends StatelessWidget {
  final int userId;

  const ProfilePage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppStrings.profile} #$userId'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.profileEdit),
            icon: const Icon(Icons.edit),
            tooltip: AppStrings.edit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.s16),
        child: Column(
          children: [
            // Profile header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.s20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        userId.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.s16),
                    Text(
                      'User #$userId',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSizes.s8),
                    Text(
                      'user$userId@example.com',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSizes.s24),

            // Profile info
            Expanded(
              child: ListView(
                children: [
                  _buildInfoTile(
                    context,
                    icon: Icons.person,
                    title: 'Tên đầy đủ',
                    subtitle: 'Nguyễn Văn A',
                  ),
                  _buildInfoTile(
                    context,
                    icon: Icons.phone,
                    title: 'Số điện thoại',
                    subtitle: '+84 123 456 789',
                  ),
                  _buildInfoTile(
                    context,
                    icon: Icons.location_on,
                    title: 'Địa chỉ',
                    subtitle: 'Hà Nội, Việt Nam',
                  ),
                  _buildInfoTile(
                    context,
                    icon: Icons.cake,
                    title: 'Ngày sinh',
                    subtitle: '01/01/1990',
                  ),
                  _buildInfoTile(
                    context,
                    icon: Icons.work,
                    title: 'Nghề nghiệp',
                    subtitle: 'Flutter Developer',
                  ),

                  const SizedBox(height: AppSizes.s24),

                  // Action buttons
                  ElevatedButton.icon(
                    onPressed: () => context.push(AppRoutes.profileEdit),
                    icon: const Icon(Icons.edit),
                    label: const Text(AppStrings.edit),
                  ),

                  const SizedBox(height: AppSizes.s12),

                  OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(AppStrings.logout),
                          content:
                              const Text('Bạn có chắc chắn muốn đăng xuất?'),
                          actions: [
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text(AppStrings.cancel),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.pop(); // Close dialog
                                context.go('/'); // Go to home
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Đã đăng xuất!')),
                                );
                              },
                              child: const Text(AppStrings.logout),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text(AppStrings.logout),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.s8),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Chỉnh sửa $title')),
          );
        },
      ),
    );
  }
}
