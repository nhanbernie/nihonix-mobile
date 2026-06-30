import '../entities/exercise_session.dart';

abstract class PracticeRepository {
  Future<ExerciseSession> generateFillBlankExercises({
    required String topicId,
    required int exerciseCount,
  });

  Future<ExerciseSession> generateMultipleChoiceExercises({
    required String topicId,
    required int exerciseCount,
  });
}
