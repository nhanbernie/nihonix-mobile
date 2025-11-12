import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/vocabulary/presentation/providers/vocab_provider.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocabulary_word_card.dart';

class VocabFolderDetailPage extends ConsumerStatefulWidget {
  final String folderId;
  final String folderName;

  const VocabFolderDetailPage({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  ConsumerState<VocabFolderDetailPage> createState() =>
      _VocabFolderDetailPageState();
}

class _VocabFolderDetailPageState extends ConsumerState<VocabFolderDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vocabProvider.notifier).loadWords(widget.folderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final vocabState = ref.watch(vocabProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text(
              widget.folderName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${vocabState.words.length} words',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.play_circle_outline),
            onPressed: () {
              // TODO: Start learning
            },
          ),
        ],
      ),
      body: vocabState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vocabState.words.isEmpty
              ? _buildEmptyState(isDark)
              : _buildWordList(vocabState, isDark),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 80,
            color: isDark ? Colors.white24 : Colors.black12,
          ),
          const SizedBox(height: AppSizes.s16),
          Text(
            'No words yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordList(VocabState vocabState, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.s16),
      itemCount: vocabState.words.length,
      itemBuilder: (context, index) {
        final word = vocabState.words[index];
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
