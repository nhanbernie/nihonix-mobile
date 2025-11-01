import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

/// Test nested route để verify bottom nav ẩn đi
class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.s16),
        child: Column(
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.s20),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 48),
                    SizedBox(width: AppSizes.s16),
                    Expanded(
                      child: Text(
                        'Màn này là test nested route.\nBottom Nav sẽ ẩn khi vào đây.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.s24),
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Họ và tên',
                      hintText: 'Nhập họ và tên',
                    ),
                  ),
                  const SizedBox(height: AppSizes.s16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Nhập email',
                    ),
                  ),
                  const SizedBox(height: AppSizes.s16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại',
                      hintText: 'Nhập số điện thoại',
                    ),
                  ),
                  const SizedBox(height: AppSizes.s32),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã lưu!')),
                      );
                      context.pop();
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Lưu'),
                  ),
                  const SizedBox(height: AppSizes.s12),
                  OutlinedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.cancel),
                    label: const Text(AppStrings.cancel),
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
