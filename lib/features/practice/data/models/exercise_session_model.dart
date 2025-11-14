import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/exercise_session.dart';
import 'exercise_model.dart';

part 'exercise_session_model.freezed.dart';

@freezed
sealed class ExerciseSessionModel with _$ExerciseSessionModel {
  const ExerciseSessionModel._();

  factory ExerciseSessionModel({
    required String sessionId,
    required String topicId,
    required Map<String, String> topicTitle,
    required String levelCode,
    required String exerciseType,
    required int totalExercises,
    required int vocabularyCount,
    required int grammarCount,
    required List<ExerciseModel> exercises,
  }) = _ExerciseSessionModel;

  factory ExerciseSessionModel.fromJson(Map<String, dynamic> json) {
    return ExerciseSessionModel(
      sessionId: json['session_id'] as String? ?? '',
      topicId: json['topic_id'] as String? ?? '',
      topicTitle: Map<String, String>.from(json['topic_title'] as Map? ?? {}),
      levelCode: json['level_code'] as String? ?? '',
      exerciseType: json['exercise_type'] as String? ?? '',
      totalExercises: json['total_exercises'] as int? ?? 0,
      vocabularyCount: json['vocabulary_count'] as int? ?? 0,
      grammarCount: json['grammar_count'] as int? ?? 0,
      exercises: (json['exercises'] as List?)
          ?.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'topic_id': topicId,
      'topic_title': topicTitle,
      'level_code': levelCode,
      'exercise_type': exerciseType,
      'total_exercises': totalExercises,
      'vocabulary_count': vocabularyCount,
      'grammar_count': grammarCount,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }

  ExerciseSession toDomain() {
    return ExerciseSession(
      sessionId: sessionId,
      topicId: topicId,
      topicTitle: topicTitle,
      levelCode: levelCode,
      exerciseType: exerciseType,
      totalExercises: totalExercises,
      vocabularyCount: vocabularyCount,
      grammarCount: grammarCount,
      exercises: exercises.map((e) => e.toDomain()).toList(),
    );
  }
}

