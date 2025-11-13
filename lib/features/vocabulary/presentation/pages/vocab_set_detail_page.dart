import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/shared/widgets/common_app_bar.dart';
import '../providers/vocab_set_detail_provider.dart';
import '../widgets/vocab_item_card.dart';
import '../widgets/vocab_item_detail_sheet.dart';

class VocabSetDetailPage extends ConsumerWidget {
  final String setId;
  final String setName;

  const VocabSetDetailPage({
    super.key,
    required this.setId,
    required this.setName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vocabSetAsync = ref.watch(vocabSetDetailProvider(setId));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        appBar: const CommonAppBar(),
        body: vocabSetAsync.when(
          data: (vocabSet) {
            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
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
                  ),
                ),

                // Vocabulary Items
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.s24,
                    0,
                    AppSizes.s24,
                    AppSizes.s40,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = vocabSet.items[index];
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
                      childCount: vocabSet.items.length,
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: AppSizes.s16),
                Text(
                  'Error loading vocabulary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: AppSizes.s8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.s32),
                  child: Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.s24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(vocabSetDetailProvider(setId));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

