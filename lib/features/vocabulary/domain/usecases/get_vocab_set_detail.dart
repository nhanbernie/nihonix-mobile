import '../entities/vocab_set_detail.dart';
import '../repositories/vocab_set_detail_repository.dart';

class GetVocabSetDetailUseCase {
  final VocabSetDetailRepository _repository;

  GetVocabSetDetailUseCase(this._repository);

  Future<VocabSetDetail> call(String id) async {
    return await _repository.getVocabSetById(id);
  }
}
