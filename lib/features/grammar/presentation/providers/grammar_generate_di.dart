import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/providers.dart';
import '../../data/datasources/grammar_generate_api.dart';
import '../../data/datasources/grammar_generate_remote_datasource.dart';
import '../../data/repositories/grammar_generate_repository_impl.dart';
import '../../domain/repositories/grammar_generate_repository.dart';
import '../../domain/usecases/generate_grammar_patterns.dart';

final grammarGenerateApiProvider = Provider<GrammarGenerateApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GrammarGenerateApi(apiClient.dio);
});

final grammarGenerateRemoteDataSourceProvider =
    Provider<GrammarGenerateRemoteDataSource>((ref) {
  return GrammarGenerateRemoteDataSource(ref.read(grammarGenerateApiProvider));
});

final grammarGenerateRepositoryProvider =
    Provider<GrammarGenerateRepository>((ref) {
  return GrammarGenerateRepositoryImpl(
      ref.read(grammarGenerateRemoteDataSourceProvider));
});

final generateGrammarPatternsUseCaseProvider =
    Provider<GenerateGrammarPatternsUseCase>((ref) {
  return GenerateGrammarPatternsUseCase(
      ref.read(grammarGenerateRepositoryProvider));
});

