class VocabItem {
  final String slug;
  final String vocabularySetId;
  final String levelCode;
  final String romaji;
  final String kanji;
  final String kana;
  final Map<String, String> meaning;
  final String wordType;
  final String? title;
  final List<VocabExample> examples;
  final int order;

  const VocabItem({
    required this.slug,
    required this.vocabularySetId,
    required this.levelCode,
    required this.romaji,
    required this.kanji,
    required this.kana,
    required this.meaning,
    required this.wordType,
    this.title,
    required this.examples,
    required this.order,
  });
}

class VocabExample {
  final String sentenceJp;
  final String sentenceRomaji;
  final String sentenceVi;
  final String sentenceEn;

  const VocabExample({
    required this.sentenceJp,
    required this.sentenceRomaji,
    required this.sentenceVi,
    required this.sentenceEn,
  });
}

