import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/shared/widgets/ai_loading_overlay.dart';
import 'package:nihonix/features/grammar/presentation/providers/grammar_provider.dart';
import 'package:nihonix/features/grammar/presentation/providers/grammar_generate_provider.dart';
import 'package:nihonix/features/grammar/presentation/widgets/grammar_pattern_list/grammar_pattern_empty_state.dart';
import 'package:nihonix/features/grammar/presentation/widgets/grammar_pattern_list/grammar_pattern_list_widget.dart';

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
        systemNavigationBarColor:
            isDark ? const Color(0xFF1A1A1A) : Colors.white,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
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
            ),
            body: grammarState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : grammarState.patterns.isEmpty
                    ? GrammarPatternEmptyState(
                        grammarSubTopicSlug: widget.slug,
                        isDark: isDark,
                      )
                    : CustomScrollView(
                        slivers: [
                          GrammarPatternListWidget(
                            patterns: grammarState.patterns,
                            isDark: isDark,
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
