import '../entities/grammar_sub_topic.dart';
import '../entities/grammar_pattern.dart';

abstract class GrammarRepository {
  Future<List<GrammarSubTopic>> getGrammarSubTopics({
    String? levelCode,
    String? topicId,
  });

  Future<List<GrammarPattern>> getGrammarPatterns(String grammarSubTopicSlug);
}

