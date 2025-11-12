import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/vocab_folder.dart';
import '../../domain/entities/vocabulary_word.dart';

// Simple state class without freezed
class VocabState {
  final List<VocabFolder> folders;
  final List<VocabularyWord> words;
  final bool isLoading;
  final bool isCreatingFolder;
  final String? error;
  final VocabFolder? selectedFolder;

  const VocabState({
    this.folders = const [],
    this.words = const [],
    this.isLoading = false,
    this.isCreatingFolder = false,
    this.error,
    this.selectedFolder,
  });

  VocabState copyWith({
    List<VocabFolder>? folders,
    List<VocabularyWord>? words,
    bool? isLoading,
    bool? isCreatingFolder,
    String? error,
    VocabFolder? selectedFolder,
  }) {
    return VocabState(
      folders: folders ?? this.folders,
      words: words ?? this.words,
      isLoading: isLoading ?? this.isLoading,
      isCreatingFolder: isCreatingFolder ?? this.isCreatingFolder,
      error: error ?? this.error,
      selectedFolder: selectedFolder ?? this.selectedFolder,
    );
  }
}

class VocabNotifier extends Notifier<VocabState> {
  @override
  VocabState build() {
    return VocabState(
      folders: _getMockFolders(),
      words: _getMockWords(),
    );
  }

  // Mock data for UI
  List<VocabFolder> _getMockFolders() {
    return [
      VocabFolder(
        id: '1',
        name: 'JLPT N5 Vocabulary',
        topicName: 'Japanese Basics',
        wordCount: 150,
        createdAt: DateTime.now(),
        description: 'Essential vocabulary for JLPT N5',
        isAiGenerated: true,
      ),
      VocabFolder(
        id: '2',
        name: 'Daily Conversation',
        topicName: 'Speaking',
        wordCount: 80,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Common phrases for everyday use',
        isAiGenerated: false,
      ),
      VocabFolder(
        id: '3',
        name: 'Food & Drinks',
        topicName: 'Japanese Culture',
        wordCount: 120,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        description: 'Vocabulary related to food and beverages',
        isAiGenerated: true,
      ),
    ];
  }

  List<VocabularyWord> _getMockWords() {
    return [
      const VocabularyWord(
        id: '1',
        word: 'こんにちは',
        meaning: 'Hello, Good afternoon',
        pronunciation: 'Konnichiwa',
        example: 'こんにちは、お元気ですか。',
        translation: 'Hello, how are you?',
        isMastered: true,
      ),
      const VocabularyWord(
        id: '2',
        word: 'ありがとう',
        meaning: 'Thank you',
        pronunciation: 'Arigatou',
        example: 'ありがとうございます。',
        translation: 'Thank you very much.',
        isMastered: false,
      ),
      const VocabularyWord(
        id: '3',
        word: 'さようなら',
        meaning: 'Goodbye',
        pronunciation: 'Sayounara',
        example: 'さようなら、また明日。',
        translation: 'Goodbye, see you tomorrow.',
        isMastered: false,
      ),
    ];
  }

  void selectFolder(VocabFolder folder) {
    state = state.copyWith(selectedFolder: folder);
  }

  void loadWords(String folderId) {
    state = state.copyWith(words: _getMockWords());
  }
}

final vocabProvider = NotifierProvider<VocabNotifier, VocabState>(
  VocabNotifier.new,
);

