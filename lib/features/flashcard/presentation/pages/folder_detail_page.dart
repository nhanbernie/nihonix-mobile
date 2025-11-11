import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/route_constants.dart';

class FolderDetailPage extends StatelessWidget {
  final String folderId;
  final String folderName;

  const FolderDetailPage({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context) {
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
                // TODO: Show folder options
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Folder Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
              child: Column(
                children: [
                  const SizedBox(height: AppSizes.s16),
                  // Folder Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.folder_rounded,
                      size: 40,
                      color: AppColors.primary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: AppSizes.s16),
                  // Folder Name
                  Text(
                    folderName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: AppSizes.s24),
                ],
              ),
            ),

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
                  _buildFlashcardItem(
                    context,
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
                      onPressed: () => _showAddFlashcardSheet(context),
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

  Widget _buildFlashcardItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.s12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.s16),
            child: Row(
              children: [
                // Flashcard Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.style_rounded,
                    size: 20,
                    color: AppColors.primary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(width: AppSizes.s12),
                // Flashcard Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // More Icon
                Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddFlashcardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: AppSizes.s12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: AppSizes.s24),

            // Manual Flashcard Set Option
            _buildSheetOption(
              context,
              icon: Icons.style_rounded,
              title: 'Flashcard Set',
              subtitle: 'Tạo bộ thẻ học thủ công',
              onTap: () {
                context.pop();
                context.push(
                  '${AppRoutes.cardForm}?folderId=$folderId',
                );
              },
            ),

            const SizedBox(height: AppSizes.s8),

            // AI Generated Flashcard Option
            _buildSheetOption(
              context,
              icon: Icons.auto_awesome,
              title: 'AI Flashcard',
              subtitle: 'Tạo thẻ học tự động bằng AI',
              onTap: () {
                context.pop();
                // TODO: Navigate to AI generation page
              },
            ),

            const SizedBox(height: AppSizes.s24),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s24,
            vertical: AppSizes.s12,
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSizes.s16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

