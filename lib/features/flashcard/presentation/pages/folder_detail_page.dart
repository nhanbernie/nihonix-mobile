import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/route_constants.dart';
import '../widgets/folder_header.dart';
import '../widgets/flashcard_item.dart';
import '../widgets/add_flashcard_sheet.dart';
import '../widgets/folder_options_sheet.dart';
import '../providers/flashcard_provider.dart';

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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => FolderOptionsSheet(
                    onEdit: () {
                      Navigator.of(context).pop();
                      // Navigate to folder edit route (placeholder)
                      context.push('${AppRoutes.folderDetail}/edit?folderId=$folderId');
                    },
                    onDelete: () async {
                      Navigator.of(context).pop();
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
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Folder Header
            FolderHeader(folderName: folderName),

            // Flashcard List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
                children: [
                  // Section Header
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.s12),
                    child: Row(
                      children: [
                        Text(
                          'Recent',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: AppSizes.s8),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),

                  // Flashcard Items (Hardcoded for UI demo)
                  FlashcardItem(
                    title: 'animal',
                    subtitle: 'Flashcard set • 2 terms • by you',
                    onTap: () {
                      context.push(
                        '${AppRoutes.cardStudy}?setId=demo&setName=${Uri.encodeComponent('animal')}',
                      );
                    },
                  ),

                  const SizedBox(height: AppSizes.s24),

                  // Add More Button
                  Center(
                    child: TextButton.icon(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

}

