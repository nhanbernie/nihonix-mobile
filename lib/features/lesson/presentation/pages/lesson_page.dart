import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/features/auth/presentation/providers/auth_provider.dart';
import 'package:nihonix/features/lesson/presentation/providers/topic_provider.dart';
import 'package:nihonix/features/lesson/presentation/widgets/topic_card.dart';
import 'package:nihonix/shared/utils/material_icon_mapper.dart';
import 'package:nihonix/shared/widgets/common_app_bar.dart';

class LessonPage extends ConsumerStatefulWidget {
  final String? preSelectedType;

  const LessonPage({
    super.key,
    this.preSelectedType,
  });

  @override
  ConsumerState<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends ConsumerState<LessonPage> {
  @override
  Widget build(BuildContext context) {
    // Get user's level code from auth state
    final authState = ref.watch(authProvider);
    final userLevelCode = authState.user?.levelCode;

    // Watch topics async provider with user's level
    final topicsAsync = ref.watch(topicsProvider(levelCode: userLevelCode));

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: 'Bài học',
      ),
      body: Column(
        children: [
          // Fixed header section
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 64 + AppSizes.s12,
              left: AppSizes.s16,
              right: AppSizes.s16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.s16,
                    vertical: AppSizes.s12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: Colors.grey.shade400,
                        size: 24,
                      ),
                      const SizedBox(width: AppSizes.s12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Find any topic',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.s20),

                // Progress card
                Container(
                  padding: const EdgeInsets.all(AppSizes.s20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF8A3D), // Primary
                        Color(0xFFFF7028), // Medium orange
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '20',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'new words to learn',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.s16),

                // Section title
                const Text(
                  'learn words by topic',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable grid
          Expanded(
            child: topicsAsync.when(
              data: (topics) {
                if (topics.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.topic_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: AppSizes.s16),
                        Text(
                          'No topics available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: AppSizes.s12,
                    crossAxisSpacing: AppSizes.s12,
                    childAspectRatio: 0.9,
                  ),
                  padding: EdgeInsets.only(
                    left: AppSizes.s16,
                    right: AppSizes.s16,
                    top: AppSizes.s12,
                    bottom: MediaQuery.of(context).padding.bottom + 100,
                  ),
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    final topic = topics[index];

                    // Get icon - use Material icon from codePoint if available
                    IconData icon;
                    if (topic.iconType == 'material' &&
                        topic.iconCode != null) {
                      icon = materialIconFromCodePoint(topic.iconCode);
                    } else {
                      // Fallback icon
                      icon = Icons.topic_rounded;
                    }

                    // Get title - prefer English, fallback to Japanese, then Vietnamese
                    String label = topic.title['en'] ??
                        topic.title['jp'] ??
                        topic.title['vi'] ??
                        'Topic';

                    return TopicCard(
                      icon: icon,
                      label: label,
                      onTap: () {
                        context.push(
                          '${AppRoutes.topicDetail}?id=${topic.id}&name=${topic.slug}&icon=${icon.codePoint}',
                        );
                      },
                    );
                  },
                );
              },
              loading: () => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: AppSizes.s12,
                  crossAxisSpacing: AppSizes.s12,
                  childAspectRatio: 0.9,
                ),
                padding: EdgeInsets.only(
                  left: AppSizes.s16,
                  right: AppSizes.s16,
                  top: AppSizes.s12,
                  bottom: MediaQuery.of(context).padding.bottom + 100,
                ),
                itemCount: 9, // Skeleton count
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                },
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: AppSizes.s16),
                    Text(
                      'Error loading topics',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s8),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.s16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(topicsProvider);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
