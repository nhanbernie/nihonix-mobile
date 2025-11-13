import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/shared/widgets/ai_loading_overlay.dart';
import 'package:nihonix/features/vocabulary/presentation/providers/vocab_provider.dart';
import 'package:nihonix/features/vocabulary/presentation/providers/vocab_generate_provider.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_folder_card.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/create_vocab_ai_card.dart';

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
    final countController = TextEditingController(text: '10');
    final promptController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final generateState = ref.watch(vocabGenerateProvider);

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  Text(
                    'Create Vocabulary with AI',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AI will generate vocabulary list based on your prompt',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Count field
                  TextField(
                    controller: countController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Number of Words',
                      hintText: 'e.g., 10',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.numbers),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Prompt field (optional)
                  TextField(
                    controller: promptController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Custom Prompt (Optional)',
                      hintText: 'Describe specific vocabulary you want...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.auto_awesome),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Create button
                  ElevatedButton(
                    onPressed: generateState.isGenerating
                        ? null
                        : () async {
                            final count = int.tryParse(countController.text);
                            if (count == null || count <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a valid number'),
                                ),
                              );
                              return;
                            }

                            Navigator.pop(context);

                            // Generate vocabulary
                            await ref
                                .read(vocabGenerateProvider.notifier)
                                .generateVocabularyItems(
                                  topicId: widget.topicId,
                                  levelCode: 'N5', // TODO: Get from user level
                                  count: count,
                                  customPrompt: promptController.text.isEmpty
                                      ? null
                                      : promptController.text,
                                );

                            // Check result
                            final state = ref.read(vocabGenerateProvider);
                            if (mounted) {
                              if (state.error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Lỗi: ${state.error}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (state.result != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Tạo ${state.result!.generatedCount} từ vựng thành công!',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                // Reload vocab sets
                                ref
                                    .read(vocabProvider.notifier)
                                    .loadVocabSetsByTopic(widget.topicId);
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: generateState.isGenerating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Generate with AI',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
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
                  ? _buildEmptyState(isDark)
                  : _buildFolderList(vocabState, isDark),
        ),

        // AI Loading Overlay
        AILoadingOverlay(
          message: 'AI đang tạo từ vựng...',
          isVisible: generateState.isGenerating,
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSizes.s32),

            Text(
              'No Vocabulary Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: AppSizes.s12),

            Text(
              'Create your first vocabulary folder\nwith AI assistance',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white60 : Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSizes.s40),

            // Create with AI card
            CreateVocabAICard(
              topicName: widget.topicName,
              onTap: _showCreateDialog,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderList(VocabState vocabState, bool isDark) {
    return Column(
      children: [
        // Create new folder card at top
        Padding(
          padding: const EdgeInsets.all(AppSizes.s16),
          child: CreateVocabAICard(
            topicName: widget.topicName,
            onTap: _showCreateDialog,
            isDark: isDark,
            isCompact: true,
          ),
        ),

        // Folders grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s16,
              vertical: AppSizes.s8,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: AppSizes.s12,
              mainAxisSpacing: AppSizes.s12,
            ),
            itemCount: vocabState.folders.length,
            itemBuilder: (context, index) {
              final folder = vocabState.folders[index];
              return VocabFolderCard(
                folder: folder,
                isDark: isDark,
                onTap: () {
                  ref.read(vocabProvider.notifier).selectFolder(folder);
                  context.push(
                    '${AppRoutes.vocabSetDetail}?setId=${folder.id}&setName=${Uri.encodeComponent(folder.name)}',
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
