import '../../domain/entities/vocab_set_detail.dart';
import '../../domain/repositories/vocab_set_detail_repository.dart';
import '../datasources/vocab_set_remote_datasource.dart';

class VocabSetDetailRepositoryImpl implements VocabSetDetailRepository {
  final VocabSetRemoteDataSource _remoteDataSource;

  VocabSetDetailRepositoryImpl(this._remoteDataSource);

  @override
  Future<VocabSetDetail> getVocabSetById(String id) async {
    return await _remoteDataSource.getVocabSetById(id);
  }
}
