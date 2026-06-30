import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_sizes.dart';

/// Empty state widget for vocabulary folder detail page
class VocabFolderEmptyState extends StatelessWidget {
  final bool isDark;

  const VocabFolderEmptyState({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 80,
            color: isDark ? Colors.white24 : Colors.black12,
          ),
          const SizedBox(height: AppSizes.s16),
          Text(
            'No words yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
