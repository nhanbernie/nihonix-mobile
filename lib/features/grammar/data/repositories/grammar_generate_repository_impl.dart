import '../../domain/entities/grammar_generate_result.dart';
import '../../domain/repositories/grammar_generate_repository.dart';
import '../datasources/grammar_generate_remote_datasource.dart';

class GrammarGenerateRepositoryImpl implements GrammarGenerateRepository {
  final GrammarGenerateRemoteDataSource _remoteDataSource;

  GrammarGenerateRepositoryImpl(this._remoteDataSource);

  @override
  Future<GrammarGenerateResult> generateGrammarPatterns({
    required String grammarSubTopicSlug,
    required String levelCode,
    required int count,
    String? customPrompt,
  }) async {
    return await _remoteDataSource.generateGrammarPatterns(
      grammarSubTopicSlug: grammarSubTopicSlug,
      levelCode: levelCode,
      count: count,
      customPrompt: customPrompt,
    );
  }
}
