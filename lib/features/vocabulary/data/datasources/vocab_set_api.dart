import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'vocab_set_api.g.dart';

@RestApi()
abstract class VocabSetApi {
  factory VocabSetApi(Dio dio, {String? baseUrl}) = _VocabSetApi;

  @GET('/vocabulary-sets/by-topic/{topicId}')
  Future<HttpResponse<dynamic>> getVocabSetsByTopic(
    @Path('topicId') String topicId,
  );

  @GET('/vocabulary-sets/{id}')
  Future<HttpResponse<dynamic>> getVocabSetById(
    @Path('id') String id,
  );
}

