import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/features/auth/presentation/providers/auth_provider.dart';
import 'package:nihonix/features/lesson/presentation/providers/topic_provider.dart';
import 'package:nihonix/features/lesson/presentation/widgets/topic_card.dart';
import 'package:nihonix/features/practice/presentation/widgets/quiz_type_bottom_sheet.dart';
import 'package:nihonix/shared/widgets/common_app_bar.dart';

/// Helper to create IconData with const fontFamily for tree-shaking
IconData _createMaterialIcon(int codePoint) {
  return IconData(
    codePoint,
    fontFamily: 'MaterialIcons',
    fontPackage: null,
  );
}

class QuizTopicSelectionPage extends ConsumerWidget {
  const QuizTopicSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get user's level code from auth state
    final authState = ref.watch(authProvider);
    final userLevelCode = authState.user?.levelCode;

    // Watch topics async provider with user's level
    final topicsAsync = ref.watch(topicsProvider(levelCode: userLevelCode));

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: 'Chọn chủ đề',
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
                // Header card
                Container(
                  padding: const EdgeInsets.all(AppSizes.s20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4CAF50), // Green
                        Color(0xFF45A049), // Darker green
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.quiz_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(height: AppSizes.s12),
                            Text(
                              'Quiz nhanh',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: AppSizes.s4),
                            Text(
                              'Chọn chủ đề để bắt đầu luyện tập',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.s16),

                // Section title
                const Text(
                  'Chọn chủ đề bạn muốn luyện tập',
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
                          'Không có chủ đề nào',
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
                    if (topic.iconType == 'material' && topic.iconCode != null) {
                      icon = _createMaterialIcon(topic.iconCode!);
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
                      onTap: () async {
                        // Show bottom sheet to select quiz type
                        final quizType = await QuizTypeBottomSheet.show(
                          context: context,
                          topicId: topic.id,
                          topicName: label,
                        );

                        // Navigate to quiz play page if user selected a type
                        if (quizType != null && context.mounted) {
                          context.push(
                            '${AppRoutes.quizPlay}?topicId=${topic.id}&topicName=$label&type=$quizType',
                          );
                        }
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
                      'Lỗi khi tải chủ đề',
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
                      label: const Text('Thử lại'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
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

