// Simple class without freezed - just for UI
class VocabFolder {
  final String id;
  final String name;
  final String topicName;
  final int wordCount;
  final DateTime createdAt;
  final String? description;
  final String? prompt;
  final bool isAiGenerated;

  const VocabFolder({
    required this.id,
    required this.name,
    required this.topicName,
    required this.wordCount,
    required this.createdAt,
    this.description,
    this.prompt,
    this.isAiGenerated = false,
  });

  String get displayWordCount =>
      '$wordCount ${wordCount == 1 ? 'word' : 'words'}';
}
