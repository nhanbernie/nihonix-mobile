import 'package:dio/dio.dart';
import '../../domain/entities/exercise_session.dart';
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

      if (response.response.statusCode == 200 || response.response.statusCode == 201) {
        return response.data.toDomain();
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

      if (response.response.statusCode == 200 || response.response.statusCode == 201) {
        return response.data.toDomain();
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

