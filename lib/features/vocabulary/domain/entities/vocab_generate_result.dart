import 'vocab_item.dart';

/// Result entity for AI-generated vocabulary set
class VocabGenerateResult {
  final String setId;
  final String setSlug;
  final Map<String, String> setTitle;
  final String topicId;
  final String levelCode;
  final int requestedCount;
  final int generatedCount;
  final List<VocabItem> items;

  const VocabGenerateResult({
    required this.setId,
    required this.setSlug,
    required this.setTitle,
    required this.topicId,
    required this.levelCode,
    required this.requestedCount,
    required this.generatedCount,
    required this.items,
  });

  /// Get set title by language code
  /// Falls back to English if the requested language is not available
  String getSetTitleByLanguage(String lang) {
    return setTitle[lang] ?? setTitle['en'] ?? setTitle.values.first;
  }
}

