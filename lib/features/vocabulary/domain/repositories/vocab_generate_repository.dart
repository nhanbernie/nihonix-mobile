import '../entities/vocab_generate_result.dart';

abstract class VocabGenerateRepository {
  Future<VocabGenerateResult> generateVocabularyItems({
    required String topicId,
    required String levelCode,
    required int count,
    String? customPrompt,
  });
}
