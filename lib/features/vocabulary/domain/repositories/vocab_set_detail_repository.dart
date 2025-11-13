import '../entities/vocab_set_detail.dart';

abstract class VocabSetDetailRepository {
  Future<VocabSetDetail> getVocabSetById(String id);
}

