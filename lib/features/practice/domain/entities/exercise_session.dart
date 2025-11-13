import 'package:freezed_annotation/freezed_annotation.dart';
import 'exercise.dart';

part 'exercise_session.freezed.dart';

@freezed
class ExerciseSession with _$ExerciseSession {
  const factory ExerciseSession({
    required String sessionId,
    required String topicId,
    required Map<String, String> topicTitle,
    required String levelCode,
    required String exerciseType, // 'fill_blank' or 'multiple_choice'
    required int totalExercises,
    required int vocabularyCount,
    required int grammarCount,
    required List<Exercise> exercises,
  }) = _ExerciseSession;
}

