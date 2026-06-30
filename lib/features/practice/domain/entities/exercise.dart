import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';

@freezed
sealed class Exercise with _$Exercise {
  const Exercise._();

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
sealed class Question with _$Question {
  const Question._();

  const factory Question({
    required String text,
    String? hint,
    String? context,
  }) = _Question;
}

@freezed
sealed class ExerciseOption with _$ExerciseOption {
  const ExerciseOption._();

  const factory ExerciseOption({
    required int id,
    required String text,
  }) = _ExerciseOption;
}

@freezed
sealed class Explanation with _$Explanation {
  const Explanation._();

  const factory Explanation({
    String? vi,
    String? en,
  }) = _Explanation;
}
