import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'grammar_api.g.dart';

@RestApi()
abstract class GrammarApi {
  factory GrammarApi(Dio dio, {String? baseUrl}) = _GrammarApi;

  @GET('/grammar-sub-topics')
  Future<HttpResponse<dynamic>> getGrammarSubTopics({
    @Query('levelCode') String? levelCode,
    @Query('topicId') String? topicId,
  });

  @GET('/grammar-patterns')
  Future<HttpResponse<dynamic>> getGrammarPatterns({
    @Query('grammar_sub_topic_slug') required String grammarSubTopicSlug,
  });
}

