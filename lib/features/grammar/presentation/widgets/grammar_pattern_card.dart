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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              widget.isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE8E8E8),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Always visible
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pattern
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.pattern.patternJp,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: widget.isDark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.pattern.patternRomaji,
                              style: TextStyle(
                                fontSize: 14,
                                color: widget.isDark
                                    ? Colors.white60
                                    : Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.s12),

                  // Explanation
                  Text(
                    widget.pattern.getExplanation('vi'),
                    style: TextStyle(
                      fontSize: 15,
                      color: widget.isDark
                          ? Colors.white.withOpacity(0.87)
                          : Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          if (_isExpanded) ...[
            Divider(
              height: 1,
              thickness: 1,
              color: widget.isDark
                  ? const Color(0xFF3A3A3A)
                  : const Color(0xFFE8E8E8),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Examples
                  if (widget.pattern.usageExamples.isNotEmpty) ...[
                    Text(
                      'Examples',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: widget.isDark ? Colors.white70 : Colors.black54,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s12),
                    ...widget.pattern.usageExamples.map((example) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSizes.s12),
                        padding: const EdgeInsets.all(AppSizes.s12),
                        decoration: BoxDecoration(
                          color: widget.isDark
                              ? const Color(0xFF1A1A1A)
                              : const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Japanese
                            Text(
                              example.sentenceJp,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: widget.isDark
                                    ? Colors.white
                                    : Colors.black87,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Romaji
                            Text(
                              example.sentenceRomaji,
                              style: TextStyle(
                                fontSize: 13,
                                color: widget.isDark
                                    ? Colors.white54
                                    : Colors.black45,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Vietnamese
                            Text(
                              '🇻🇳 ${example.sentenceVi}',
                              style: TextStyle(
                                fontSize: 14,
                                color: widget.isDark
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // English
                            Text(
                              '🇬🇧 ${example.sentenceEn}',
                              style: TextStyle(
                                fontSize: 14,
                                color: widget.isDark
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  // Grammar points
                  if (widget.pattern.grammarPoints.isNotEmpty) ...[
                    Text(
                      'Grammar Points',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: widget.isDark ? Colors.white70 : Colors.black54,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.pattern.grammarPoints.map((point) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
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
