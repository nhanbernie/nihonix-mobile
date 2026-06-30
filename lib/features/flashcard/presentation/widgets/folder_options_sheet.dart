import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';

class FolderOptionsSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FolderOptionsSheet({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

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

          const SizedBox(height: AppSizes.s16),

          ListTile(
            leading: Icon(Icons.edit, color: AppColors.primary),
            title: const Text('Sửa'),
            onTap: onEdit,
          ),

          ListTile(
            leading: Icon(Icons.delete_outline, color: Colors.redAccent),
            title: const Text('Xóa'),
            onTap: onDelete,
          ),

          const SizedBox(height: AppSizes.s24),
        ],
      ),
    );
  }
}
