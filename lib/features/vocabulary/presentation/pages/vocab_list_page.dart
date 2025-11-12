import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/features/vocabulary/presentation/providers/vocab_provider.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_folder_card.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/create_vocab_ai_card.dart';

class VocabListPage extends ConsumerStatefulWidget {
  final String topicName;
  final IconData topicIcon;

  const VocabListPage({
    super.key,
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
    // Mock data is already loaded in provider, no need to call loadFolders
  }

  void _showCreateDialog() {
    final nameController = TextEditingController();
    final promptController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
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

              // Folder name field
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Folder Name',
                  hintText: 'e.g., ${widget.topicName} basics',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.folder_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Prompt field
              TextField(
                controller: promptController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'AI Prompt',
                  hintText: 'Describe what vocabulary you want to learn...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.auto_awesome),
                ),
              ),
              const SizedBox(height: 24),

              // Create button
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      promptController.text.isEmpty) {
                    return;
                  }

                  Navigator.pop(context);

                  // TODO: Implement AI folder creation later
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('AI folder creation will be implemented later'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
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
      ),
    );
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
                    '${AppRoutes.vocabFolderDetail}?folderId=${folder.id}&folderName=${folder.name}',
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
