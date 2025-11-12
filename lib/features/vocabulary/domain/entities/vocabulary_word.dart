// Simple class without freezed - just for UI
class VocabularyWord {
  final String id;
  final String word;
  final String meaning;
  final String pronunciation;
  final String? example;
  final String? translation;
  final bool isMastered;

  const VocabularyWord({
    required this.id,
    required this.word,
    required this.meaning,
    required this.pronunciation,
    this.example,
    this.translation,
    this.isMastered = false,
  });
}

