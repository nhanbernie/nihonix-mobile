import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/grammar/domain/entities/grammar_pattern.dart';

/// Simple grammar pattern card widget (similar to VocabItemCard)
class GrammarPatternCard extends StatelessWidget {
  final GrammarPattern pattern;
  final bool isDark;
  final VoidCallback onTap;

  const GrammarPatternCard({
    super.key,
    required this.pattern,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE8E8E8),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppSizes.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pattern (Japanese)
            Text(
              pattern.patternJp,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),

            // Romaji
            Text(
              pattern.patternRomaji,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white60 : Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AppSizes.s12),

            // Explanation
            Text(
              pattern.getExplanation('vi'),
              style: TextStyle(
                fontSize: 15,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.87)
                    : Colors.black.withValues(alpha: 0.87),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // First example if available
            if (pattern.usageExamples.isNotEmpty) ...[
              const SizedBox(height: AppSizes.s12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pattern.usageExamples.first.sentenceJp,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s8),
                    Text(
                      pattern.usageExamples.first.sentenceVi,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
