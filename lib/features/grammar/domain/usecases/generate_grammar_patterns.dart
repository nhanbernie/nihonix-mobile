import '../entities/grammar_generate_result.dart';
import '../repositories/grammar_generate_repository.dart';

class GenerateGrammarPatternsUseCase {
  final GrammarGenerateRepository _repository;

  GenerateGrammarPatternsUseCase(this._repository);

  Future<GrammarGenerateResult> call({
    required String grammarSubTopicSlug,
    required String levelCode,
    required int count,
    String? customPrompt,
  }) async {
    return await _repository.generateGrammarPatterns(
      grammarSubTopicSlug: grammarSubTopicSlug,
      levelCode: levelCode,
      count: count,
      customPrompt: customPrompt,
    );
  }
}

