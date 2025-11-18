import '../../domain/entities/grammar_sub_topic.dart';
import '../../domain/entities/grammar_pattern.dart';
import '../../domain/repositories/grammar_repository.dart';
import '../datasources/grammar_remote_datasource.dart';

class GrammarRepositoryImpl implements GrammarRepository {
  final GrammarRemoteDataSource _remoteDataSource;

  GrammarRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<GrammarSubTopic>> getGrammarSubTopics({
    String? levelCode,
    String? topicId,
  }) async {
    return await _remoteDataSource.getGrammarSubTopics(
      levelCode: levelCode,
      topicId: topicId,
    );
  }

  @override
  Future<List<GrammarPattern>> getGrammarPatterns(
      String grammarSubTopicSlug) async {
    return await _remoteDataSource.getGrammarPatterns(grammarSubTopicSlug);
  }
}
