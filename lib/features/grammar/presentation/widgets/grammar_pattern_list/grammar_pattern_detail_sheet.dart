import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/features/grammar/domain/entities/grammar_pattern.dart';

/// Grammar pattern detail sheet (similar to VocabItemDetailSheet)
class GrammarPatternDetailSheet extends StatelessWidget {
  final GrammarPattern pattern;
  final bool isDark;

  const GrammarPatternDetailSheet({
    super.key,
    required this.pattern,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pattern (Japanese)
                  Text(
                    pattern.patternJp,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Romaji
                  Text(
                    pattern.patternRomaji,
                    style: TextStyle(
                      fontSize: 20,
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Level difficulty
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      pattern.levelDifficulty,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Explanation
                  _buildSection(
                    'Explanation',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (pattern.explanation['vi'] != null)
                          _buildExplanationRow(
                              '🇻🇳', pattern.explanation['vi']!),
                        if (pattern.explanation['en'] != null)
                          _buildExplanationRow(
                              '🇬🇧', pattern.explanation['en']!),
                        if (pattern.explanation['jp'] != null)
                          _buildExplanationRow(
                              '🇯🇵', pattern.explanation['jp']!),
                      ],
                    ),
                  ),

                  // Usage Examples
                  if (pattern.usageExamples.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSection(
                      'Usage Examples',
                      Column(
                        children: pattern.usageExamples.map((example) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2A2A2A)
                                  : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Japanese
                                Text(
                                  example.sentenceJp,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Romaji
                                Text(
                                  example.sentenceRomaji,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.black54,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Vietnamese
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('🇻🇳 '),
                                    Expanded(
                                      child: Text(
                                        example.sentenceVi,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                // English
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('🇬🇧 '),
                                    Expanded(
                                      child: Text(
                                        example.sentenceEn,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],

                  // Grammar Points
                  if (pattern.grammarPoints.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSection(
                      'Grammar Points',
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: pattern.grammarPoints.map((point) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              point,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildExplanationRow(String flag, String explanation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$flag ',
            style: const TextStyle(fontSize: 16),
          ),
          Expanded(
            child: Text(
              explanation,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white.withValues(alpha: 0.87) : Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
