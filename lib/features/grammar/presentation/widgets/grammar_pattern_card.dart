import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/grammar/domain/entities/grammar_pattern.dart';

class GrammarPatternCard extends StatefulWidget {
  final GrammarPattern pattern;
  final bool isDark;

  const GrammarPatternCard({
    super.key,
    required this.pattern,
    required this.isDark,
  });

  @override
  State<GrammarPatternCard> createState() => _GrammarPatternCardState();
}

class _GrammarPatternCardState extends State<GrammarPatternCard> {
  bool _isExpanded = false;

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF4EF4A5);
      case 'intermediate':
        return const Color(0xFFF5F378);
      case 'advanced':
        return const Color(0xFFFF8A3D);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isDark
              ? const Color(0xFF3A3A3A)
              : const Color(0xFFE8E8E8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: widget.isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pattern with difficulty badge
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Japanese pattern
                            Text(
                              widget.pattern.patternJp,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: widget.isDark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Romaji
                            Text(
                              widget.pattern.patternRomaji,
                              style: TextStyle(
                                fontSize: 16,
                                color: widget.isDark
                                    ? Colors.white60
                                    : Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Difficulty badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(
                                  widget.pattern.levelDifficulty)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.pattern.levelDifficulty.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getDifficultyColor(
                                widget.pattern.levelDifficulty),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.s16),

                  // Explanation
                  Text(
                    widget.pattern.getExplanation('vi'),
                    style: TextStyle(
                      fontSize: 15,
                      color: widget.isDark ? Colors.white.withOpacity(0.87) : Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSizes.s12),

                  // Expand/Collapse indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSizes.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Usage examples
                  Text(
                    'Usage Examples',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: AppSizes.s12),

                  ...widget.pattern.usageExamples.map((example) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSizes.s12),
                      padding: const EdgeInsets.all(AppSizes.s16),
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? const Color(0xFF1A1A1A)
                            : const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Japanese sentence
                          Text(
                            example.sentenceJp,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: widget.isDark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Romaji
                          Text(
                            example.sentenceRomaji,
                            style: TextStyle(
                              fontSize: 14,
                              color: widget.isDark
                                  ? Colors.white60
                                  : Colors.black54,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Vietnamese translation
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'VI',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  example.sentenceVi,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: widget.isDark
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // English translation
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF81BFFF)
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'EN',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF81BFFF),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  example.sentenceEn,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: widget.isDark
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  // Grammar points
                  if (widget.pattern.grammarPoints.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.s16),
                    Text(
                      'Grammar Points',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.pattern.grammarPoints.map((point) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7246AC)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF7246AC)
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            point,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7246AC),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
