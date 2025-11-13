/// Result entity for AI-generated grammar patterns
class GrammarGenerateResult {
  final String grammarSubTopicSlug;
  final String levelCode;
  final int count;
  final List<GrammarPatternGenerated> patterns;

  const GrammarGenerateResult({
    required this.grammarSubTopicSlug,
    required this.levelCode,
    required this.count,
    required this.patterns,
  });
}

/// Generated grammar pattern (simplified version)
class GrammarPatternGenerated {
  final String slug;
  final String grammarSubTopicSlug;
  final String topicSlug;
  final String levelCode;
  final String patternJp;
  final String patternRomaji;
  final Map<String, String> explanation;
  final List<GeneratedExample> usageExamples;
  final Map<String, dynamic> conjugationRules;
  final String levelDifficulty;
  final List<String> grammarPoints;
  final int order;

  const GrammarPatternGenerated({
    required this.slug,
    required this.grammarSubTopicSlug,
    required this.topicSlug,
    required this.levelCode,
    required this.patternJp,
    required this.patternRomaji,
    required this.explanation,
    required this.usageExamples,
    required this.conjugationRules,
    required this.levelDifficulty,
    required this.grammarPoints,
    required this.order,
  });
}

/// Generated usage example
class GeneratedExample {
  final String sentenceJp;
  final String sentenceRomaji;
  final String sentenceVi;
  final String sentenceEn;

  const GeneratedExample({
    required this.sentenceJp,
    required this.sentenceRomaji,
    required this.sentenceVi,
    required this.sentenceEn,
  });
}

