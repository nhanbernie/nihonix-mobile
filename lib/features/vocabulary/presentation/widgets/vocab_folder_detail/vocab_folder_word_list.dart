import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/vocabulary/domain/entities/vocabulary_word.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocabulary_word_card.dart';

/// Word list widget for vocabulary folder detail page
class VocabFolderWordList extends StatelessWidget {
  final List<VocabularyWord> words;
  final bool isDark;

  const VocabFolderWordList({
    super.key,
    required this.words,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.s16),
      itemCount: words.length,
      itemBuilder: (context, index) {
        final word = words[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.s12),
          child: VocabularyWordCard(
            word: word,
            isDark: isDark,
          ),
        );
      },
    );
  }
}

