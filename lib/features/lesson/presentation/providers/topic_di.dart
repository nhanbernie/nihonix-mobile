// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:nihonix/core/network/providers.dart';
import '../../data/datasources/topic_api.dart';
import '../../data/datasources/topic_remote_datasource.dart';
import '../../data/repositories/topic_repository_impl.dart';
import '../../domain/repositories/topic_repository.dart';
import '../../domain/usecases/get_topics.dart';
part 'topic_di.g.dart';

// DataSource
@riverpod
TopicRemoteDataSource topicRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  final api = TopicApi(apiClient.dio);
  return TopicRemoteDataSource(api);
}

// Repository
@riverpod
TopicRepository topicRepository(Ref ref) {
  final remoteDataSource = ref.watch(topicRemoteDataSourceProvider);
  return TopicRepositoryImpl(remoteDataSource);
}

// UseCase
@riverpod
GetTopicsUseCase getTopicsUseCase(Ref ref) {
  final repository = ref.watch(topicRepositoryProvider);
  return GetTopicsUseCase(repository);
}
