import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/topic.dart';

part 'topic_model.freezed.dart';

@freezed
sealed class TopicModel with _$TopicModel {
  const TopicModel._();

  factory TopicModel({
    required String id,
    required String slug,
    required String levelCode,
    required Map<String, String> title,
    String? iconSvg,
    required String iconType,
    int? iconCode,
    required int order,
    String? etag,
  }) = _TopicModel;

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      levelCode: json['level_code'] as String? ?? '',
      title: Map<String, String>.from(json['title'] as Map? ?? {}),
      iconSvg: json['icon_svg'] as String?,
      iconType: json['icon_type'] as String? ?? '',
      iconCode: json['icon_code'] as int?,
      order: json['order'] as int? ?? 0,
      etag: json['etag'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'level_code': levelCode,
      'title': title,
      'icon_svg': iconSvg,
      'icon_type': iconType,
      'icon_code': iconCode,
      'order': order,
      'etag': etag,
    };
  }

  Topic toDomain() {
    return Topic(
      id: id,
      slug: slug,
      levelCode: levelCode,
      title: title,
      iconSvg: iconSvg,
      iconType: iconType,
      iconCode: iconCode,
      order: order,
    );
  }

  factory TopicModel.fromDomain(Topic topic) {
    return TopicModel(
      id: topic.id,
      slug: topic.slug,
      levelCode: topic.levelCode,
      title: topic.title,
      iconSvg: topic.iconSvg,
      iconType: topic.iconType,
      iconCode: topic.iconCode,
      order: topic.order,
    );
  }
}

extension TopicModelListX on List<TopicModel> {
  List<Topic> toDomain() => map((model) => model.toDomain()).toList();
}
