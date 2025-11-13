import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/shared/widgets/common_app_bar.dart';

import '../widgets/folder_header.dart';
import '../widgets/flashcard_item.dart';
import '../widgets/add_flashcard_sheet.dart';
import '../widgets/folder_options_sheet.dart';
import '../providers/flashcard_provider.dart';
import '../providers/folder_sets_provider.dart';
import '../providers/flashcard_di.dart';

class FolderDetailPage extends ConsumerWidget {
  final String folderId;
  final String folderName;

  const FolderDetailPage({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final flashcardState = ref.watch(flashcardProvider);
    final folder = flashcardState.folders.firstWhere(
      (f) => f.id == folderId,
      orElse: () => throw Exception('Folder not found'),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonAppBar(
          // title: folder.name,
          actionIcon: Icons.more_vert,
          onActionPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => FolderOptionsSheet(
                onEdit: () {
                  Navigator.of(context).pop();
                  context.push(
                    '${AppRoutes.folderDetail}/$folderId/edit?name=${Uri.encodeComponent(folder.name)}&description=${Uri.encodeComponent(folder.description)}',
                  );
                },
                onDelete: () {
                  Navigator.of(context).pop();
                  _handleDeleteFolder(context, ref);
                },
              ),
            );
          },
        ),
        body: Column(
          children: [
            // Folder Header
            FolderHeader(
              folderName: folder.name,
              folderDescription: folder.description,
            ),

            // Flashcard List
            Expanded(
              child: _buildSetsList(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetsList(BuildContext context, WidgetRef ref) {
    final setsAsync = ref.watch(folderSetsProvider(folderId));

    return setsAsync.when(
      data: (sets) {
        if (sets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: AppSizes.s16),
                Text(
                  'Chưa có set nào',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: AppSizes.s24),
                FilledButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => AddFlashcardSheet(folderId: folderId),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Tạo set đầu tiên'),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
          children: [
            // Section Header
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.s12),
              child: Row(
                children: [
                  Text(
                    'Sets (${sets.length})',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Flashcard Sets from API
            ...sets.map((set) {
              return FlashcardItem(
                title: set.name,
                subtitle: 'Flashcard set • ${set.cardCount} terms',
                onTap: () {
                  context.push(
                    '${AppRoutes.cardStudy}?setId=${set.id}&setName=${Uri.encodeComponent(set.name)}',
                  );
                },
                onEdit: () {
                  context.push(
                    '${AppRoutes.cardForm}?setId=${set.id}&folderId=$folderId&setName=${Uri.encodeComponent(set.name)}',
                  );
                },
                onDelete: () => _handleDeleteSet(context, ref, set.id, set.name),
              );
            }),

            const SizedBox(height: AppSizes.s24),

            // Add More Button
            Center(
              child: TextButton.icon(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => AddFlashcardSheet(folderId: folderId),
                ),
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Add more',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.s20,
                    vertical: AppSizes.s12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.s40),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: AppSizes.s16),
            Text(
              'Lỗi: $error',
              style: TextStyle(color: Colors.red.shade700),
            ),
            const SizedBox(height: AppSizes.s16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(folderSetsProvider(folderId));
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDeleteFolder(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn chắc chắn muốn xóa folder này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await ref.read(flashcardProvider.notifier).deleteFolder(folderId);
        if (success) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Xóa folder thành công')),
            );
            context.pop();
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi xóa folder: $e')),
          );
        }
      }
    }
  }

  Future<void> _handleDeleteSet(
    BuildContext context,
    WidgetRef ref,
    String setId,
    String setName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa set "$setName" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final useCase = ref.read(deleteFlashcardSetUseCaseProvider);
        await useCase(setId);
        
        // Refresh danh sách sets
        ref.invalidate(folderSetsProvider(folderId));
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Xóa set thành công'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi xóa set: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

