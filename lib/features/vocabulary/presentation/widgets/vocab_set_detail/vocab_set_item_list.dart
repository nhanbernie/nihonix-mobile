import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/vocabulary/domain/entities/vocab_item.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_item_card.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_item_detail_sheet.dart';

/// Vocabulary items list widget for vocab set detail page
class VocabSetItemList extends StatelessWidget {
  final List<VocabItem> items;
  final bool isDark;

  const VocabSetItemList({
    super.key,
    required this.items,
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
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.s12),
              child: VocabItemCard(
                item: item,
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
                        return VocabItemDetailSheet(
                          item: item,
                          isDark: isDark,
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}

