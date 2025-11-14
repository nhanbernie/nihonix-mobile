import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/exercise.dart';

part 'exercise_model.freezed.dart';

@freezed
sealed class ExerciseModel with _$ExerciseModel {
  const ExerciseModel._();

  factory ExerciseModel({
    required String id,
    required String type,
    required QuestionModel question,
    required List<ExerciseOptionModel> options,
    required ExplanationModel explanation,
    required int order,
  }) = _ExerciseModel;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      question: QuestionModel.fromJson(json['question'] as Map<String, dynamic>? ?? {}),
      options: (json['options'] as List?)
          ?.map((e) => ExerciseOptionModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      explanation: ExplanationModel.fromJson(json['explanation'] as Map<String, dynamic>? ?? {}),
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'question': question.toJson(),
      'options': options.map((e) => e.toJson()).toList(),
      'explanation': explanation.toJson(),
      'order': order,
    };
  }

  Exercise toDomain() {
    return Exercise(
      id: id,
      type: type,
      question: question.toDomain(),
      options: options.map((o) => o.toDomain()).toList(),
      explanation: explanation.toDomain(),
      order: order,
    );
  }
}

@freezed
sealed class QuestionModel with _$QuestionModel {
  const QuestionModel._();

  factory QuestionModel({
    required String text,
    String? hint,
    String? context,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      text: json['text'] as String? ?? '',
      hint: json['hint'] as String?,
      context: json['context'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'hint': hint,
      'context': context,
    };
  }

  Question toDomain() {
    return Question(
      text: text,
      hint: hint,
      context: context,
    );
  }
}

@freezed
sealed class ExerciseOptionModel with _$ExerciseOptionModel {
  const ExerciseOptionModel._();

  factory ExerciseOptionModel({
    required int id,
    required String text,
  }) = _ExerciseOptionModel;

  factory ExerciseOptionModel.fromJson(Map<String, dynamic> json) {
    return ExerciseOptionModel(
      id: json['id'] as int? ?? 0,
      text: json['text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  ExerciseOption toDomain() {
    return ExerciseOption(
      id: id,
      text: text,
    );
  }
}

@freezed
sealed class ExplanationModel with _$ExplanationModel {
  const ExplanationModel._();

  factory ExplanationModel({
    String? vi,
    String? en,
  }) = _ExplanationModel;

  factory ExplanationModel.fromJson(Map<String, dynamic> json) {
    return ExplanationModel(
      vi: json['vi'] as String?,
      en: json['en'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vi': vi,
      'en': en,
    };
  }

  Explanation toDomain() {
    return Explanation(
      vi: vi,
      en: en,
    );
  }
}

