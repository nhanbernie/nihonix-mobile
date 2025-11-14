import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/features/vocabulary/presentation/providers/vocab_provider.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_folder_detail/vocab_folder_empty_state.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_folder_detail/vocab_folder_word_list.dart';

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
              ? VocabFolderEmptyState(isDark: isDark)
              : VocabFolderWordList(
                  words: vocabState.words,
                  isDark: isDark,
                ),
    );
  }
}
