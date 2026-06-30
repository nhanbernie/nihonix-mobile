import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'grammar_generate_api.g.dart';

@RestApi()
abstract class GrammarGenerateApi {
  factory GrammarGenerateApi(Dio dio, {String? baseUrl}) = _GrammarGenerateApi;

  @POST('/grammar-patterns/generate')
  Future<HttpResponse<dynamic>> generateGrammarPatterns({
    @Body() required Map<String, dynamic> body,
  });
}
