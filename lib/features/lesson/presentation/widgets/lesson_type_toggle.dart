import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_strings.dart';
import 'package:nihonix/features/lesson/presentation/providers/lesson_provider.dart';

class LessonTypeToggle extends ConsumerWidget {
  const LessonTypeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonState = ref.watch(lessonProvider);
    final lessonNotifier = ref.read(lessonProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              lessonNotifier.toggleLessonType(AppStrings.vocabulary);
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: lessonState.lessonType == LessonType.vocabulary
                    ? Colors.white
                    : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  AppStrings.vocabulary,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    color: lessonState.lessonType == LessonType.vocabulary
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              lessonNotifier.toggleLessonType(AppStrings.grammar);
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: lessonState.lessonType == LessonType.grammar
                    ? Colors.white
                    : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  AppStrings.grammar,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    color: lessonState.lessonType == LessonType.grammar
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
