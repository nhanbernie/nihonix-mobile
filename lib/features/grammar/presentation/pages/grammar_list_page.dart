import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/features/grammar/presentation/providers/grammar_provider.dart';
import 'package:nihonix/features/grammar/presentation/widgets/grammar_sub_topic_card.dart';

class GrammarListPage extends ConsumerStatefulWidget {
  final String topicId;
  final String topicName;
  final IconData topicIcon;

  const GrammarListPage({
    super.key,
    required this.topicId,
    required this.topicName,
    required this.topicIcon,
  });

  @override
  ConsumerState<GrammarListPage> createState() => _GrammarListPageState();
}

class _GrammarListPageState extends ConsumerState<GrammarListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(grammarProvider.notifier).loadSubTopics(widget.topicId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final grammarState = ref.watch(grammarProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor:
            isDark ? const Color(0xFF2A2A2A) : Colors.white,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          forceMaterialTransparency: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => context.pop(),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            // Orange header background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.28,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                ),
              ),
            ),

            // Content
            Column(
              children: [
                // Icon section
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSizes.s32),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.topicIcon,
                          size: 40,
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.s24),

                // Bottom sheet with curved top
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Header with title
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSizes.s20,
                            AppSizes.s16,
                            AppSizes.s20,
                            AppSizes.s12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${widget.topicName} Grammar',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Content
                        Expanded(
                          child: grammarState.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : grammarState.subTopics.isEmpty
                                  ? _buildEmptyState(isDark)
                                  : _buildSubTopicsList(grammarState, isDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 80,
            color: isDark ? Colors.white24 : Colors.black12,
          ),
          const SizedBox(height: AppSizes.s16),
          Text(
            'No Grammar Topics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: AppSizes.s8),
          Text(
            'Grammar topics will appear here',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTopicsList(GrammarState grammarState, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.s16),
      itemCount: grammarState.subTopics.length,
      itemBuilder: (context, index) {
        final subTopic = grammarState.subTopics[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.s12),
          child: GrammarSubTopicCard(
            subTopic: subTopic,
            isDark: isDark,
            index: index,
            onTap: () {
              ref.read(grammarProvider.notifier).selectSubTopic(subTopic);
              context.push(
                '${AppRoutes.grammarPatternList}?slug=${subTopic.slug}&title=${Uri.encodeComponent(subTopic.getTitleByLanguage('vi'))}',
              );
            },
          ),
        );
      },
    );
  }
}
