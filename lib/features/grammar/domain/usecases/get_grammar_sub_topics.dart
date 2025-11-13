import '../entities/grammar_sub_topic.dart';
import '../repositories/grammar_repository.dart';

class GetGrammarSubTopicsUseCase {
  final GrammarRepository _repository;

  GetGrammarSubTopicsUseCase(this._repository);

  Future<List<GrammarSubTopic>> call({
    String? levelCode,
    String? topicId,
  }) async {
    return await _repository.getGrammarSubTopics(
      levelCode: levelCode,
      topicId: topicId,
    );
  }
}

