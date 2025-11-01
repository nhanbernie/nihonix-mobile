import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/features/lesson/presentation/widgets/lesson_type_toggle.dart';
import 'package:nihonix/features/lesson/presentation/widgets/vocabulary_list.dart';

class LessonPage extends ConsumerStatefulWidget {
  const LessonPage({super.key});

  @override
  ConsumerState<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends ConsumerState<LessonPage> {
  @override
  Widget build(BuildContext context) {
    // final lessonState = ref.watch(lessonProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 50),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          flexibleSpace: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                children: [
                  // IconButton(
                  //   icon: const Icon(Icons.arrow_back),
                  //   onPressed: () => context.pop(),
                  // ),1
                  const Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bài 2: Vật dụng hằng ngày",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "毎日の生活用品",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 17,
                          fontWeight: FontWeight.w200,
                        ),
                      )
                    ],
                  )),
                  const LessonTypeToggle(),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: VocabularyList(),
      ),
    );
  }
}
