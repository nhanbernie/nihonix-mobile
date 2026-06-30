import '../entities/topic.dart';
import '../repositories/topic_repository.dart';

class GetTopicsUseCase {
  final TopicRepository _repository;

  GetTopicsUseCase(this._repository);

  Future<List<Topic>> call({String? levelCode}) async {
    return await _repository.getTopics(levelCode: levelCode);
  }
}
