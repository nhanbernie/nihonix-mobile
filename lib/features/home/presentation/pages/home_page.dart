import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/constants/app_strings.dart';
import 'package:nihonix/features/auth/presentation/providers/auth_provider.dart';
import 'package:nihonix/features/home/presentation/widgets/home_app_bar.dart';
import 'package:nihonix/features/home/presentation/widgets/milestone_card.dart';
import 'package:nihonix/features/home/presentation/widgets/streak_tracker.dart';
import 'package:nihonix/features/lesson/presentation/pages/lesson_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      // kéo lên trên app bar để nhìn fullsize
      extendBodyBehindAppBar: true,
      appBar: const HomeAppBar(),
      body: ListView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top +
              kToolbarHeight +
              AppSizes.s12,
          left: AppSizes.s16,
          right: AppSizes.s16,
          bottom: MediaQuery.of(context).padding.bottom +
              100, // Bottom system + nav bar space
        ),
        children: [
            // Welcome header
            SizedBox(height: AppSizes.s16),
            Container(
              padding: const EdgeInsets.symmetric(
                // horizontal: AppSizes.s20,
                vertical: AppSizes.s16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Welcome text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w300,
                              height: 1.0,
                            ),
                      ),
                      Text(
                        'back, ${authState.user?.username ?? "User"}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                      ),
                    ],
                  ),
                  // Level badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🇯🇵', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 4),
                            Text(
                              'N5',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Upper',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                    fontSize: 9,
                                  ),
                        ),
                        Text(
                          'Intermediate',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                    fontSize: 9,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.s24),

            // Streak Tracker
            const StreakTracker(
              currentStreak: 7,
              longestStreak: 15,
              weekProgress: [true, true, true, true, false, false, false],
            ),
            const SizedBox(height: AppSizes.s24),

            // Today's milestones section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's milestones",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s16),

            // 4 milestone cards in 2x2 grid
            Row(
              children: [
                Expanded(
                  child: MilestoneCard(
                    icon: Icons.text_fields,
                    title: 'New Words',
                    current: 17,
                    total: 24,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LessonPage(
                            preSelectedType: AppStrings.vocabulary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSizes.s16),
                Expanded(
                  child: MilestoneCard(
                    icon: Icons.edit,
                    title: 'Exercise',
                    current: 4,
                    total: 7,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LessonPage(
                            preSelectedType: AppStrings.grammar,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s16),
            Row(
              children: [
                Expanded(
                  child: MilestoneCard(
                    icon: Icons.headphones,
                    title: 'Listening',
                    current: 3,
                    total: 5,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LessonPage(
                            preSelectedType: AppStrings.vocabulary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSizes.s16),
                Expanded(
                  child: MilestoneCard(
                    icon: Icons.menu_book,
                    title: 'Reading',
                    current: 2,
                    total: 4,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LessonPage(
                            preSelectedType: AppStrings.vocabulary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s24),
          ],
      ),
    );
  }
}
