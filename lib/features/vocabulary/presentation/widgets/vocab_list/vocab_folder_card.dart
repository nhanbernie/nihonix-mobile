import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/vocabulary/domain/entities/vocab_folder.dart';

class VocabFolderCard extends StatelessWidget {
  final VocabFolder folder;
  final bool isDark;
  final VoidCallback onTap;

  const VocabFolderCard({
    super.key,
    required this.folder,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? const Color(0xFF3A3A3A)
              : const Color(0xFFE8E8E8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and AI badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7246AC).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        folder.isAiGenerated
                            ? Icons.auto_awesome
                            : Icons.folder_outlined,
                        color: const Color(0xFF7246AC),
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                    if (folder.isAiGenerated)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8A3D).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'AI',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF8A3D),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSizes.s12),

                // Folder name
                Text(
                  folder.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),

                // Word count
                Row(
                  children: [
                    Icon(
                      Icons.text_fields,
                      size: 14,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      folder.displayWordCount,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
