import '../entities/grammar_generate_result.dart';

abstract class GrammarGenerateRepository {
  Future<GrammarGenerateResult> generateGrammarPatterns({
    required String grammarSubTopicSlug,
    required String levelCode,
    required int count,
    String? customPrompt,
  });
}
