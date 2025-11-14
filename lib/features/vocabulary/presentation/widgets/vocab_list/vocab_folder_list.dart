import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/features/vocabulary/domain/entities/vocab_folder.dart';
import 'package:nihonix/features/vocabulary/presentation/providers/vocab_provider.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_list/vocab_folder_card.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_list/create_vocab_ai_card.dart';

/// Vocabulary folder list widget with grid layout
class VocabFolderList extends ConsumerWidget {
  final List<VocabFolder> folders;
  final String topicName;
  final VoidCallback onCreateTap;
  final bool isDark;

  const VocabFolderList({
    super.key,
    required this.folders,
    required this.topicName,
    required this.onCreateTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Create new folder card at top
        Padding(
          padding: const EdgeInsets.all(AppSizes.s16),
          child: CreateVocabAICard(
            topicName: topicName,
            onTap: onCreateTap,
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
            itemCount: folders.length,
            itemBuilder: (context, index) {
              final folder = folders[index];
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

