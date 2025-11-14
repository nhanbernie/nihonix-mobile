import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/vocabulary/domain/entities/vocab_set_detail.dart';

/// Header widget for vocabulary set detail page
class VocabSetHeader extends StatelessWidget {
  final VocabSetDetail vocabSet;
  final bool isDark;

  const VocabSetHeader({
    super.key,
    required this.vocabSet,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.s24,
        AppSizes.s8,
        AppSizes.s24,
        AppSizes.s16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Set Title
          Text(
            vocabSet.getTitleByLanguage('en'),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          
          // Topic and Count
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  vocabSet.topic.title['en'] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${vocabSet.items.length} words',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

