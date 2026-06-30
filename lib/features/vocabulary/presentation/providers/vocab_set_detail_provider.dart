import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/providers.dart';
import '../../data/datasources/vocab_set_api.dart';
import '../../data/datasources/vocab_set_remote_datasource.dart';
import '../../data/repositories/vocab_set_detail_repository_impl.dart';
import '../../domain/entities/vocab_set_detail.dart';
import '../../domain/repositories/vocab_set_detail_repository.dart';
import '../../domain/usecases/get_vocab_set_detail.dart';

// Repository Provider
final vocabSetDetailRepositoryProvider =
    Provider<VocabSetDetailRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final api = VocabSetApi(apiClient.dio);
  final dataSource = VocabSetRemoteDataSource(api);
  return VocabSetDetailRepositoryImpl(dataSource);
});

// UseCase Provider
final getVocabSetDetailUseCaseProvider =
    Provider<GetVocabSetDetailUseCase>((ref) {
  final repository = ref.watch(vocabSetDetailRepositoryProvider);
  return GetVocabSetDetailUseCase(repository);
});

// State Provider
final vocabSetDetailProvider =
    FutureProvider.family<VocabSetDetail, String>((ref, id) async {
  final useCase = ref.watch(getVocabSetDetailUseCaseProvider);
  return await useCase(id);
});
