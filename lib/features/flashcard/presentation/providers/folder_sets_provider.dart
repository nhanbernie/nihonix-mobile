import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/flashcard_set.dart';
import 'flashcard_di.dart';

part 'folder_sets_provider.freezed.dart';

@freezed
sealed class FolderSetsState with _$FolderSetsState {
  const factory FolderSetsState({
    @Default([]) List<FlashcardSet> sets,
    @Default(false) bool isLoading,
    String? error,
  }) = _FolderSetsState;
}

/// Folder Sets Provider (Family - one instance per folder ID)
/// Usage: ref.watch(folderSetsProvider('folderId'))
final folderSetsProvider = FutureProvider.family<List<FlashcardSet>, String>((ref, folderId) async {
  final repository = ref.watch(flashcardRepositoryProvider);
  return await repository.getSetsInFolder(folderId);
});
