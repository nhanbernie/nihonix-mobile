import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class FolderHeader extends StatelessWidget {
  final String folderName;

  const FolderHeader({super.key, required this.folderName});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
