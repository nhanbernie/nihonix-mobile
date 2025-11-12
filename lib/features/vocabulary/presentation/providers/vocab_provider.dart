import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/vocab_folder.dart';
import '../../domain/entities/vocabulary_word.dart';

part 'vocab_provider.freezed.dart';

@freezed
class VocabState with _$VocabState {
  const factory VocabState({
    @Default([]) List<VocabFolder> folders,
    @Default([]) List<VocabularyWord> words,
    @Default(false) bool isLoading,
    @Default(false) bool isCreatingFolder,
    String? error,
    VocabFolder? selectedFolder,
  }) = _VocabState;
}

class VocabNotifier extends Notifier<VocabState> {
  @override
  VocabState build() {
    return const VocabState();
  }

  Future<void> loadFolders(String topicName) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Call repository to fetch folders
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data for now
      final folders = <VocabFolder>[];

      state = state.copyWith(
        folders: folders,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createFolderWithAI({
    required String topicName,
    required String folderName,
    required String prompt,
  }) async {
    state = state.copyWith(isCreatingFolder: true, error: null);

    try {
      // TODO: Call API to create folder with AI
      await Future.delayed(const Duration(seconds: 2));

      // Mock created folder
      final newFolder = VocabFolder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: folderName,
        topicName: topicName,
        wordCount: 20,
        createdAt: DateTime.now(),
        description: 'AI-generated vocabulary for $topicName',
        prompt: prompt,
        isAiGenerated: true,
      );

      state = state.copyWith(
        folders: [...state.folders, newFolder],
        isCreatingFolder: false,
      );
    } catch (e) {
      state = state.copyWith(
        isCreatingFolder: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadWords(String folderId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Call repository to fetch words
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data
      final words = <VocabularyWord>[
        VocabularyWord(
          id: '1',
          word: 'Hello',
          meaning: 'A greeting',
          pronunciation: '/həˈloʊ/',
          example: 'Hello, how are you?',
          translation: 'Xin chào',
        ),
      ];

      state = state.copyWith(
        words: words,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void selectFolder(VocabFolder folder) {
    state = state.copyWith(selectedFolder: folder);
  }
}

final vocabProvider = NotifierProvider<VocabNotifier, VocabState>(
  VocabNotifier.new,
);
