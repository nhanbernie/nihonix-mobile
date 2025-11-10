import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/flashcard/presentation/providers/flashcard_provider.dart';
import 'package:nihonix/features/flashcard/presentation/widgets/folder_card.dart';
import 'package:nihonix/shared/widgets/common_app_bar.dart';

class FlashcardPage extends ConsumerWidget {
  const FlashcardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashcardState = ref.watch(flashcardProvider);
    
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: 'Flashcard',
        actionIcon: Icons.add_rounded,
        onActionPressed: () => _showCreateFolderDialog(context, ref),
      ),
      body: ListView(
        // const Box 

        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top +
              kToolbarHeight +
              AppSizes.s12,
          left: AppSizes.s16,
          right: AppSizes.s16,
          bottom: MediaQuery.of(context).padding.bottom + 100,
        ),
        children: [
          const SizedBox(height: AppSizes.s12),
          // Header
          Container(
            padding: const EdgeInsets.all(AppSizes.s20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF8A3D), // Primary
                  Color(0xFFFF6B35), // Darker orange
                  Color(0xFFFF4500), // Deep orange
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.style_rounded,
                  size: 48,
                  color: Colors.white,
                ),
                SizedBox(height: AppSizes.s12),
                Text(
                  'Học với Flashcard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppSizes.s8),
                Text(
                  'Ghi nhớ từ vựng hiệu quả với thẻ học thông minh',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.s24),

          // Loading indicator
          if (flashcardState.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.s24),
                child: CircularProgressIndicator(),
              ),
            )
          // Error message
          else if (flashcardState.error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.s24),
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: AppSizes.s12),
                    Text(
                      'Lỗi: ${flashcardState.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: AppSizes.s16),
                    FilledButton.icon(
                      onPressed: () => ref.read(flashcardProvider.notifier).loadFolders(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            )
          // Empty state
          else if (flashcardState.folders.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.s24),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open_rounded,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: AppSizes.s16),
                    Text(
                      'Chưa có folder nào',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s8),
                    Text(
                      'Nhấn + để tạo folder mới',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            )
          // Folder list
          else
            ...flashcardState.folders.map((folder) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.s12),
              child: FolderCard(
                folderName: folder.name,
                onTap: () {
                  // TODO: Navigate to folder detail
                },
              ),
            )),
        ],
      ),
    );
  }

  void _showCreateFolderDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tạo folder mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tên folder *',
                hintText: 'Ví dụ: Từ vựng N5',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: AppSizes.s16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Mô tả (tùy chọn)',
                hintText: 'Mô tả ngắn về folder',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập tên folder')),
                );
                return;
              }

              Navigator.pop(dialogContext);

              // Call API to create folder
              final description = descriptionController.text.trim();
              final success = await ref.read(flashcardProvider.notifier).createFolder(
                name: name,
                description: description.isEmpty ? null : description,
                order: 1, // Backend requires order >= 1
              );

              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tạo folder "$name" thành công!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  final error = ref.read(flashcardProvider).error ?? 'Có lỗi xảy ra';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lỗi: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }
}

