import 'package:dio/dio.dart';
import '../../domain/entities/exercise_session.dart';
import '../models/exercise_session_model.dart';
import 'practice_api.dart';

class PracticeRemoteDataSource {
  final PracticeApi _api;

  PracticeRemoteDataSource(this._api);

  /// Generate fill-blank exercises
  Future<ExerciseSession> generateFillBlankExercises({
    required String topicId,
    required int exerciseCount,
  }) async {
    try {
      final response = await _api.generateFillBlankExercises({
        'topic_id': topicId,
        'exercise_count': exerciseCount,
      });

      if (response.response.statusCode == 200 ||
          response.response.statusCode == 201) {
        // API returns {success: true, data: {...}}
        // Extract the 'data' field from raw response
        final rawResponse = response.response.data;

        // Debug: Check response structure
        print('Raw response type: ${rawResponse.runtimeType}');
        print('Raw response: $rawResponse');

        if (rawResponse is Map<String, dynamic> &&
            rawResponse.containsKey('data')) {
          final data = rawResponse['data'] as Map<String, dynamic>;
          print('Extracted data: $data');
          final model = ExerciseSessionModel.fromJson(data);
          print('Parsed model - exercises count: ${model.exercises.length}');
          return model.toDomain();
        } else {
          // Fallback: try to parse response.data directly (if Retrofit already parsed it)
          print('Using response.data directly');
          return response.data.toDomain();
        }
      } else {
        throw Exception('Failed to generate exercises');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (e.response?.statusCode != null) {
        throw Exception(e.response?.data?['message'] ?? 'Server error');
      } else {
        throw Exception('Network error');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Generate multiple-choice exercises
  Future<ExerciseSession> generateMultipleChoiceExercises({
    required String topicId,
    required int exerciseCount,
  }) async {
    try {
      final response = await _api.generateMultipleChoiceExercises({
        'topic_id': topicId,
        'exercise_count': exerciseCount,
      });

      if (response.response.statusCode == 200 ||
          response.response.statusCode == 201) {
        // API returns {success: true, data: {...}}
        // Extract the 'data' field from raw response
        final rawResponse = response.response.data;

        // Debug: Check response structure
        print('Raw response type: ${rawResponse.runtimeType}');
        print('Raw response: $rawResponse');

        if (rawResponse is Map<String, dynamic> &&
            rawResponse.containsKey('data')) {
          final data = rawResponse['data'] as Map<String, dynamic>;
          print('Extracted data: $data');
          final model = ExerciseSessionModel.fromJson(data);
          print('Parsed model - exercises count: ${model.exercises.length}');
          return model.toDomain();
        } else {
          // Fallback: try to parse response.data directly (if Retrofit already parsed it)
          print('Using response.data directly');
          return response.data.toDomain();
        }
      } else {
        throw Exception('Failed to generate exercises');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (e.response?.statusCode != null) {
        throw Exception(e.response?.data?['message'] ?? 'Server error');
      } else {
        throw Exception('Network error');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
