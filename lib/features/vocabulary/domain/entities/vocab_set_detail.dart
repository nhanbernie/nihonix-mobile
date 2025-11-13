import 'vocab_item.dart';

class VocabSetDetail {
  final String id;
  final String topicId;
  final String slug;
  final Map<String, String> title;
  final String? description;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;
  final VocabSetTopic topic;
  final List<VocabItem> items;

  const VocabSetDetail({
    required this.id,
    required this.topicId,
    required this.slug,
    required this.title,
    this.description,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    required this.topic,
    required this.items,
  });

  String getTitleByLanguage(String lang) {
    return title[lang] ?? title['en'] ?? '';
  }
}

class VocabSetTopic {
  final String id;
  final String slug;
  final String levelCode;
  final Map<String, String> title;
  final String? iconSvg;
  final String iconType;
  final int? iconCode;
  final int order;

  const VocabSetTopic({
    required this.id,
    required this.slug,
    required this.levelCode,
    required this.title,
    this.iconSvg,
    required this.iconType,
    this.iconCode,
    required this.order,
  });
}

