import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_response.dart';
import '../models/topic_model.dart';
import 'converters/topic_list_api_response_converter.dart';

part 'topic_api.g.dart';

@RestApi()
abstract class TopicApi {
  factory TopicApi(Dio dio, {String? baseUrl}) = _TopicApi;

  @GET('/topics')
  @TopicListApiResponseConverter()
  Future<ApiResponse<List<TopicModel>>> getTopics({
    @Query('levelCode') String? levelCode,
  });
}
