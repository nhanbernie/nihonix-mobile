import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic.freezed.dart';

@freezed
sealed class Topic with _$Topic {
  const Topic._();

  const factory Topic({
    required String id,
    required String slug,
    required String levelCode,
    required Map<String, String> title,
    String? iconSvg,
    required String iconType,
    int? iconCode,
    required int order,
  }) = _Topic;
}
