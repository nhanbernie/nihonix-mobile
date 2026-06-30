import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'vocab_generate_api.g.dart';

@RestApi()
abstract class VocabGenerateApi {
  factory VocabGenerateApi(Dio dio, {String? baseUrl}) = _VocabGenerateApi;

  @POST('/vocabulary-items/generate')
  Future<HttpResponse<dynamic>> generateVocabularyItems(
    @Body() Map<String, dynamic> body,
  );
}
