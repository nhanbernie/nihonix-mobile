import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_list/create_vocab_ai_card.dart';

/// Empty state widget for vocabulary list page
class VocabEmptyState extends StatelessWidget {
  final String topicName;
  final VoidCallback onCreateTap;
  final bool isDark;

  const VocabEmptyState({
    super.key,
    required this.topicName,
    required this.onCreateTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSizes.s32),

            Text(
              'No Vocabulary Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: AppSizes.s12),

            Text(
              'Create your first vocabulary folder\nwith AI assistance',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white60 : Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSizes.s40),

            // Create with AI card
            CreateVocabAICard(
              topicName: topicName,
              onTap: onCreateTap,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

