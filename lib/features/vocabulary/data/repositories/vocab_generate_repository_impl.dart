import '../../domain/entities/vocab_generate_result.dart';
import '../../domain/repositories/vocab_generate_repository.dart';
import '../datasources/vocab_generate_remote_datasource.dart';

class VocabGenerateRepositoryImpl implements VocabGenerateRepository {
  final VocabGenerateRemoteDataSource _remoteDataSource;

  VocabGenerateRepositoryImpl(this._remoteDataSource);

  @override
  Future<VocabGenerateResult> generateVocabularyItems({
    required String topicId,
    required String levelCode,
    required int count,
    String? customPrompt,
  }) async {
    return await _remoteDataSource.generateVocabularyItems(
      topicId: topicId,
      levelCode: levelCode,
      count: count,
      customPrompt: customPrompt,
    );
  }
}

