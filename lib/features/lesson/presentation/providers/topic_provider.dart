import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/topic.dart';
import 'topic_di.dart';

part 'topic_provider.g.dart';

/// Provider to fetch topics with optional level filter
@riverpod
Future<List<Topic>> topics(Ref ref, {String? levelCode}) async {
  final useCase = ref.read(getTopicsUseCaseProvider);
  return await useCase(levelCode: levelCode);
}
