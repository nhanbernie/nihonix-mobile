import '../../domain/entities/topic.dart';
import '../../domain/repositories/topic_repository.dart';
import '../datasources/topic_remote_datasource.dart';

class TopicRepositoryImpl implements TopicRepository {
  final TopicRemoteDataSource _remoteDataSource;

  TopicRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Topic>> getTopics({String? levelCode}) async {
    final topicModels = await _remoteDataSource.getTopics(levelCode: levelCode);
    return topicModels.map((model) => model.toDomain()).toList();
  }
}
