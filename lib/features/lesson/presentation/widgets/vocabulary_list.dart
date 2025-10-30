import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/features/lesson/presentation/providers/lesson_provider.dart';

class VocabularyList extends ConsumerWidget {
  const VocabularyList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonState = ref.watch(lessonProvider);
    final vocabularyList = lessonState.vocabularyList;

    if (vocabularyList.isEmpty) {
      return const Center(
        child: Text('Không có từ vựng nào'),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          // Header cố định
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1.0),
                left: BorderSide(color: Colors.grey.shade300, width: 1.0),
                right: BorderSide(color: Colors.grey.shade300, width: 1.0),
                bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Từ vựng",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${vocabularyList.length} từ",
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          // Danh sách có thể cuộn
          Expanded(
            child: ListView.builder(
              itemCount: vocabularyList.length,
              itemBuilder: (context, index) {
                final vocabulary = vocabularyList[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: Colors.grey.shade200, width: 1.0),
                      left: BorderSide(color: Colors.grey.shade300, width: 1.0),
                      right:
                          BorderSide(color: Colors.grey.shade300, width: 1.0),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vocabulary.word,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            vocabulary.hiragana,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              '.',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Text(
                            vocabulary.romaji,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vocabulary.meaning,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
