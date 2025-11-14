import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/shared/widgets/ai_loading_overlay.dart';
import 'package:nihonix/shared/widgets/common_bottom_sheet.dart';
import 'package:nihonix/features/vocabulary/presentation/providers/vocab_provider.dart';
import 'package:nihonix/features/vocabulary/presentation/providers/vocab_generate_provider.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_list/create_vocab_form.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_list/vocab_empty_state.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_list/vocab_folder_list.dart';

class VocabListPage extends ConsumerStatefulWidget {
  final String topicId;
  final String topicName;
  final IconData topicIcon;

  const VocabListPage({
    super.key,
    required this.topicId,
    required this.topicName,
    required this.topicIcon,
  });

  @override
  ConsumerState<VocabListPage> createState() => _VocabListPageState();
}

class _VocabListPageState extends ConsumerState<VocabListPage> {
  @override
  void initState() {
    super.initState();
    // Load vocab sets from API
    Future.microtask(() {
      ref.read(vocabProvider.notifier).loadVocabSetsByTopic(widget.topicId);
    });
  }

  void _showCreateDialog() {
    CommonBottomSheet.show(
      context: context,
      builder: (context) => CreateVocabForm(
        topicId: widget.topicId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final vocabState = ref.watch(vocabProvider);
    final generateState = ref.watch(vocabGenerateProvider);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop(),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.topicIcon, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${widget.topicName} Vocabulary',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: vocabState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : vocabState.folders.isEmpty
                  ? VocabEmptyState(
                      topicName: widget.topicName,
                      onCreateTap: _showCreateDialog,
                      isDark: isDark,
                    )
                  : VocabFolderList(
                      folders: vocabState.folders,
                      topicName: widget.topicName,
                      onCreateTap: _showCreateDialog,
                      isDark: isDark,
                    ),
        ),

        AILoadingOverlay(
          message: 'AI đang tạo từ vựng...',
          isVisible: generateState.isGenerating,
        ),
      ],
    );
  }
}
