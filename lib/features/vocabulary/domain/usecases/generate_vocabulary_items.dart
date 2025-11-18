import '../entities/vocab_generate_result.dart';
import '../repositories/vocab_generate_repository.dart';

class GenerateVocabularyItemsUseCase {
  final VocabGenerateRepository _repository;

  GenerateVocabularyItemsUseCase(this._repository);

  Future<VocabGenerateResult> call({
    required String topicId,
    required String levelCode,
    required int count,
    String? customPrompt,
  }) async {
    return await _repository.generateVocabularyItems(
      topicId: topicId,
      levelCode: levelCode,
      count: count,
      customPrompt: customPrompt,
    );
  }
}
