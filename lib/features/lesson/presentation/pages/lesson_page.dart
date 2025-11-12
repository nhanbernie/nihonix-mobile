import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/features/lesson/presentation/providers/lesson_provider.dart';
import 'package:nihonix/features/lesson/presentation/widgets/topic_card.dart';
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
  void initState() {
    super.initState();
    // Set lesson type based on preSelectedType if provided
    if (widget.preSelectedType != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(lessonProvider.notifier).toggleLessonType(widget.preSelectedType!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: GridView.count(
              crossAxisCount: 3,
              padding: EdgeInsets.only(
                left: AppSizes.s16,
                right: AppSizes.s16,
                top: AppSizes.s12,
                bottom: MediaQuery.of(context).padding.bottom + 100,
              ),
              mainAxisSpacing: AppSizes.s12,
              crossAxisSpacing: AppSizes.s12,
              childAspectRatio: 0.9,
              children: [
                TopicCard(
                  icon: Icons.music_note_rounded,
                  label: 'music',
                  onTap: () {
                    context.push(
                      '${AppRoutes.topicDetail}?name=music&icon=${Icons.music_note_rounded.codePoint}',
                    );
                  },
                ),
                TopicCard(
                  icon: Icons.movie_rounded,
                  label: 'cinema',
                  onTap: () {
                    context.push(
                      '${AppRoutes.topicDetail}?name=cinema&icon=${Icons.movie_rounded.codePoint}',
                    );
                  },
                ),
                TopicCard(
                  icon: Icons.flight_rounded,
                  label: 'travel',
                  onTap: () {
                    context.push(
                      '${AppRoutes.topicDetail}?name=travel&icon=${Icons.flight_rounded.codePoint}',
                    );
                  },
                ),
                TopicCard(
                  icon: Icons.pets_rounded,
                  label: 'animals',
                  onTap: () {
                    context.push(
                      '${AppRoutes.topicDetail}?name=animals&icon=${Icons.pets_rounded.codePoint}',
                    );
                  },
                ),
                TopicCard(
                  icon: Icons.sports_esports_rounded,
                  label: 'hobby',
                  onTap: () {
                    context.push(
                      '${AppRoutes.topicDetail}?name=hobby&icon=${Icons.sports_esports_rounded.codePoint}',
                    );
                  },
                ),
                TopicCard(
                  icon: Icons.cloud_rounded,
                  label: 'weather',
                  onTap: () {
                    context.push(
                      '${AppRoutes.topicDetail}?name=weather&icon=${Icons.cloud_rounded.codePoint}',
                    );
                  },
                ),
                TopicCard(
                  icon: Icons.restaurant_rounded,
                  label: 'food',
                  onTap: () {
                    context.push(
                      '${AppRoutes.topicDetail}?name=food&icon=${Icons.restaurant_rounded.codePoint}',
                    );
                  },
                ),
                TopicCard(
                  icon: Icons.sports_soccer_rounded,
                  label: 'sports',
                  onTap: () {
                    context.push(
                      '${AppRoutes.topicDetail}?name=sports&icon=${Icons.sports_soccer_rounded.codePoint}',
                    );
                  },
                ),
                TopicCard(
                  icon: Icons.school_rounded,
                  label: 'education',
                  onTap: () {
                    context.push(
                      '${AppRoutes.topicDetail}?name=education&icon=${Icons.school_rounded.codePoint}',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
