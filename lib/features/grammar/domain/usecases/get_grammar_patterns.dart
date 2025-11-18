import '../entities/grammar_pattern.dart';
import '../repositories/grammar_repository.dart';

class GetGrammarPatternsUseCase {
  final GrammarRepository _repository;

  GetGrammarPatternsUseCase(this._repository);

  Future<List<GrammarPattern>> call(String grammarSubTopicSlug) async {
    return await _repository.getGrammarPatterns(grammarSubTopicSlug);
  }
}
