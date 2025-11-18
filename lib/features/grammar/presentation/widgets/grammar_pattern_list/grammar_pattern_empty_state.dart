import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/grammar/presentation/widgets/grammar_pattern_list/grammar_pattern_generate_card.dart';

/// Empty state widget for grammar pattern list page
class GrammarPatternEmptyState extends StatelessWidget {
  final String grammarSubTopicSlug;
  final bool isDark;

  const GrammarPatternEmptyState({
    super.key,
    required this.grammarSubTopicSlug,
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
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 80,
                color: isDark ? Colors.white24 : Colors.black12,
              ),
            ),
            const SizedBox(height: AppSizes.s32),

            Text(
              'No Grammar Patterns Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: AppSizes.s12),

            Text(
              'Create your first grammar patterns\nwith AI assistance',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white60 : Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSizes.s40),

            // Generate with AI card
            GrammarPatternGenerateCard(
              grammarSubTopicSlug: grammarSubTopicSlug,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}
