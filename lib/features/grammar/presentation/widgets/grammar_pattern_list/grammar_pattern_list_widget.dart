import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/grammar/domain/entities/grammar_pattern.dart';
import 'package:nihonix/features/grammar/presentation/widgets/grammar_pattern_list/grammar_pattern_card.dart';
import 'package:nihonix/features/grammar/presentation/widgets/grammar_pattern_list/grammar_pattern_detail_sheet.dart';

/// Grammar pattern list widget (similar to VocabSetItemList)
class GrammarPatternListWidget extends StatelessWidget {
  final List<GrammarPattern> patterns;
  final bool isDark;

  const GrammarPatternListWidget({
    super.key,
    required this.patterns,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.s24,
        0,
        AppSizes.s24,
        AppSizes.s40,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final pattern = patterns[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.s12),
              child: GrammarPatternCard(
                pattern: pattern,
                isDark: isDark,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.7,
                      minChildSize: 0.5,
                      maxChildSize: 0.95,
                      builder: (context, scrollController) {
                        return GrammarPatternDetailSheet(
                          pattern: pattern,
                          isDark: isDark,
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
          childCount: patterns.length,
        ),
      ),
    );
  }
}

