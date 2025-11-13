import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/grammar/presentation/providers/grammar_provider.dart';
import 'package:nihonix/features/grammar/presentation/providers/grammar_generate_provider.dart';
import 'package:nihonix/features/grammar/presentation/widgets/grammar_pattern_card.dart';
import 'package:nihonix/shared/widgets/ai_loading_overlay.dart';

class GrammarPatternListPage extends ConsumerStatefulWidget {
  final String slug;
  final String title;

  const GrammarPatternListPage({
    super.key,
    required this.slug,
    required this.title,
  });

  @override
  ConsumerState<GrammarPatternListPage> createState() =>
      _GrammarPatternListPageState();
}

class _GrammarPatternListPageState
    extends ConsumerState<GrammarPatternListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(grammarProvider.notifier).loadPatterns(widget.slug);
    });
  }

  void _showGenerateDialog() {
    final countController = TextEditingController(text: '5');
    final promptController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final generateState = ref.watch(grammarGenerateProvider);

        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.s24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.s24),

                // Title
                Text(
                  'Generate Grammar Patterns',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: AppSizes.s8),
                Text(
                  'AI will generate grammar patterns for this topic',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                const SizedBox(height: AppSizes.s24),

                // Count input
                TextField(
                  controller: countController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Number of patterns',
                    hintText: 'Enter number (1-10)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.numbers_rounded),
                  ),
                ),
                const SizedBox(height: AppSizes.s16),

                // Custom prompt (optional)
                TextField(
                  controller: promptController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Custom prompt (optional)',
                    hintText: 'E.g., Focus on casual conversation...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.edit_note_rounded),
                  ),
                ),
                const SizedBox(height: AppSizes.s24),

                // Generate button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: generateState.isGenerating
                        ? null
                        : () async {
                            final count = int.tryParse(countController.text);
                            if (count == null || count < 1 || count > 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a number between 1-10'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            Navigator.pop(context);

                            // Generate patterns
                            await ref
                                .read(grammarGenerateProvider.notifier)
                                .generateGrammarPatterns(
                                  grammarSubTopicSlug: widget.slug,
                                  levelCode: 'N5', // TODO: Get from user level
                                  count: count,
                                  customPrompt: promptController.text.isEmpty
                                      ? null
                                      : promptController.text,
                                );

                            // Check result
                            final state = ref.read(grammarGenerateProvider);
                            if (mounted) {
                              if (state.error != null) {
                                // Clear state first to hide overlay
                                ref.read(grammarGenerateProvider.notifier).clearResult();

                                // Small delay to ensure overlay is hidden
                                await Future.delayed(const Duration(milliseconds: 300));

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${state.error}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else if (state.result != null) {
                                // Reload patterns
                                await ref
                                    .read(grammarProvider.notifier)
                                    .loadPatterns(widget.slug);

                                // Clear generate state to hide overlay
                                ref.read(grammarGenerateProvider.notifier).clearResult();

                                // Small delay to ensure overlay is hidden
                                await Future.delayed(const Duration(milliseconds: 300));

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Generated ${state.result!.count} patterns successfully!',
                                      ),
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Generate with AI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final grammarState = ref.watch(grammarProvider);
    final generateState = ref.watch(grammarGenerateProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            body: CustomScrollView(
          slivers: [
            // Simple App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                onPressed: () => context.pop(),
              ),
              title: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.auto_awesome_rounded),
                  onPressed: _showGenerateDialog,
                  tooltip: 'Generate with AI',
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  height: 1,
                  color: isDark
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFFE8E8E8),
                ),
              ),
            ),

            // Content
            grammarState.isLoading
                ? const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : grammarState.patterns.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.menu_book_rounded,
                                size: 64,
                                color: isDark ? Colors.white24 : Colors.black12,
                              ),
                              const SizedBox(height: AppSizes.s16),
                              Text(
                                'No patterns found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark ? Colors.white60 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.all(AppSizes.s16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final pattern = grammarState.patterns[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSizes.s12),
                                child: GrammarPatternCard(
                                  pattern: pattern,
                                  isDark: isDark,
                                ),
                              );
                            },
                            childCount: grammarState.patterns.length,
                          ),
                        ),
                      ),
            ],
          ),
        ),

        // AI Loading Overlay
        AILoadingOverlay(
          message: 'Generating grammar patterns...',
          isVisible: generateState.isGenerating,
        ),
      ],
    ),
    );
  }
}
