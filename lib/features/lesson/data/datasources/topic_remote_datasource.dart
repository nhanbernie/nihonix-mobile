import 'package:dio/dio.dart';
import '../models/topic_model.dart';
import 'topic_api.dart';

class TopicRemoteDataSource {
  final TopicApi _api;

  TopicRemoteDataSource(this._api);

  factory TopicRemoteDataSource.fromDio(Dio dio) {
    return TopicRemoteDataSource(TopicApi(dio));
  }

  Future<List<TopicModel>> getTopics({String? levelCode}) async {
    try {
      final response = await _api.getTopics(levelCode: levelCode);
      
      if (response.data == null) {
        throw Exception('API returned null data');
      }
      
      return response.data!;
    } on DioException catch (e) {
      throw Exception('Failed to fetch topics: ${e.message}');
    }
  }
}
