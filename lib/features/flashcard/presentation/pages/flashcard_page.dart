import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/flashcard/presentation/widgets/folder_card.dart';
import 'package:nihonix/shared/widgets/common_app_bar.dart';

class FlashcardPage extends ConsumerWidget {
  const FlashcardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: 'Flashcard',
        actionIcon: Icons.add_rounded,
        onActionPressed: () => _showCreateFolderDialog(context),
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

          // Folder Cards
          FolderCard(
            folderName: 'Từ vựng N5',
            onTap: () {
              // TODO: Navigate to folder detail
            },
          ),
          FolderCard(
            folderName: 'Kanji cơ bản',
            onTap: () {
              // TODO: Navigate to folder detail
            },
          ),
          FolderCard(
            folderName: 'Ngữ pháp thường dùng',
            onTap: () {
              // TODO: Navigate to folder detail
            },
          ),
        ],
      ),
    );
  }

  // NOTE: fix dùng modal khác sau 
  void _showCreateFolderDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo folder mới'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nhập tên folder',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                // TODO: Create folder logic
                Navigator.pop(context);
              }
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }
}

