import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/providers.dart';
import '../../data/datasources/grammar_api.dart';
import '../../data/datasources/grammar_remote_datasource.dart';
import '../../data/repositories/grammar_repository_impl.dart';
import '../../domain/repositories/grammar_repository.dart';
import '../../domain/usecases/get_grammar_sub_topics.dart';
import '../../domain/usecases/get_grammar_patterns.dart';

final grammarApiProvider = Provider<GrammarApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GrammarApi(apiClient.dio);
});

final grammarRemoteDataSourceProvider =
    Provider<GrammarRemoteDataSource>((ref) {
  return GrammarRemoteDataSource(ref.read(grammarApiProvider));
});

final grammarRepositoryProvider = Provider<GrammarRepository>((ref) {
  return GrammarRepositoryImpl(ref.read(grammarRemoteDataSourceProvider));
});

final getGrammarSubTopicsUseCaseProvider =
    Provider<GetGrammarSubTopicsUseCase>((ref) {
  return GetGrammarSubTopicsUseCase(ref.read(grammarRepositoryProvider));
});

final getGrammarPatternsUseCaseProvider =
    Provider<GetGrammarPatternsUseCase>((ref) {
  return GetGrammarPatternsUseCase(ref.read(grammarRepositoryProvider));
});

