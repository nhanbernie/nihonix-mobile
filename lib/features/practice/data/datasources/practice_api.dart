import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/exercise_session_model.dart';

part 'practice_api.g.dart';

@RestApi()
abstract class PracticeApi {
  factory PracticeApi(Dio dio, {String baseUrl}) = _PracticeApi;

  @POST('/practice/fill-blank')
  Future<HttpResponse<ExerciseSessionModel>> generateFillBlankExercises(
    @Body() Map<String, dynamic> body,
  );

  @POST('/practice/multiple-choice')
  Future<HttpResponse<ExerciseSessionModel>> generateMultipleChoiceExercises(
    @Body() Map<String, dynamic> body,
  );
}
