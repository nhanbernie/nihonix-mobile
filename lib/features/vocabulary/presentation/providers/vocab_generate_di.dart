import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/providers.dart';
import '../../data/datasources/vocab_generate_api.dart';
import '../../data/datasources/vocab_generate_remote_datasource.dart';
import '../../data/repositories/vocab_generate_repository_impl.dart';
import '../../domain/repositories/vocab_generate_repository.dart';
import '../../domain/usecases/generate_vocabulary_items.dart';

// API Provider
final vocabGenerateApiProvider = Provider<VocabGenerateApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VocabGenerateApi(apiClient.dio);
});

// DataSource Provider
final vocabGenerateRemoteDataSourceProvider =
    Provider<VocabGenerateRemoteDataSource>((ref) {
  final api = ref.watch(vocabGenerateApiProvider);
  return VocabGenerateRemoteDataSource(api);
});

// Repository Provider
final vocabGenerateRepositoryProvider =
    Provider<VocabGenerateRepository>((ref) {
  final dataSource = ref.watch(vocabGenerateRemoteDataSourceProvider);
  return VocabGenerateRepositoryImpl(dataSource);
});

// UseCase Provider
final generateVocabularyItemsUseCaseProvider =
    Provider<GenerateVocabularyItemsUseCase>((ref) {
  final repository = ref.watch(vocabGenerateRepositoryProvider);
  return GenerateVocabularyItemsUseCase(repository);
});
