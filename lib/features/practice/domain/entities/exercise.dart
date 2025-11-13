import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';

@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required String type, // 'fill_blank' or 'multiple_choice'
    required Question question,
    required List<ExerciseOption> options,
    required Explanation explanation,
    required int order,
  }) = _Exercise;
}

@freezed
class Question with _$Question {
  const factory Question({
    required String text,
    String? hint,
    String? context,
  }) = _Question;
}

@freezed
class ExerciseOption with _$ExerciseOption {
  const factory ExerciseOption({
    required int id,
    required String text,
  }) = _ExerciseOption;
}

@freezed
class Explanation with _$Explanation {
  const factory Explanation({
    String? vi,
    String? en,
  }) = _Explanation;
}

