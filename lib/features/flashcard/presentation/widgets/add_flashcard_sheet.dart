import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import '../../../../core/router/route_constants.dart';

class AddFlashcardSheet extends StatelessWidget {
  final String folderId;

  const AddFlashcardSheet({super.key, required this.folderId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              context.push('${AppRoutes.cardForm}?folderId=$folderId');
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
              context.push('${AppRoutes.generateFlashcard}?folderId=$folderId');
            },
          ),

          const SizedBox(height: AppSizes.s24),
        ],
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
