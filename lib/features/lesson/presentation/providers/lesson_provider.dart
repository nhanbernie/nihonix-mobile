import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/constants/app_strings.dart';
import 'package:nihonix/features/lesson/domain/entities/vocabulary.dart';

part 'lesson_provider.freezed.dart';

enum LessonType { grammar, vocabulary }

final List<Vocabulary> vocabularyListSample = [
  Vocabulary(word: 'いす', hiragana: 'いす', romaji: 'isu', meaning: 'ghế'),
  Vocabulary(word: 'つくえ', hiragana: 'つくえ', romaji: 'tsukue', meaning: 'bàn'),
  Vocabulary(
      word: 'かばん', hiragana: 'かばん', romaji: 'kaban', meaning: 'cặp, túi xách'),
  Vocabulary(word: 'ほん', hiragana: 'ほん', romaji: 'hon', meaning: 'sách'),
  Vocabulary(
      word: 'えんぴつ', hiragana: 'えんぴつ', romaji: 'enpitsu', meaning: 'bút chì'),
  Vocabulary(word: 'ペン', hiragana: 'ぺん', romaji: 'pen', meaning: 'bút mực'),
  Vocabulary(
      word: 'けしゴム', hiragana: 'けしごむ', romaji: 'keshigomu', meaning: 'cục tẩy'),
  Vocabulary(word: 'ノート', hiragana: 'のーと', romaji: 'nōto', meaning: 'vở'),
  Vocabulary(word: 'かぎ', hiragana: 'かぎ', romaji: 'kagi', meaning: 'chìa khóa'),
  Vocabulary(word: 'とけい', hiragana: 'とけい', romaji: 'tokei', meaning: 'đồng hồ'),
  Vocabulary(
      word: 'でんわ', hiragana: 'でんわ', romaji: 'denwa', meaning: 'điện thoại'),
  Vocabulary(
      word: 'スマホ',
      hiragana: 'すまほ',
      romaji: 'sumaho',
      meaning: 'điện thoại thông minh'),
  Vocabulary(word: 'くつ', hiragana: 'くつ', romaji: 'kutsu', meaning: 'giày'),
  Vocabulary(
      word: 'くつした', hiragana: 'くつした', romaji: 'kutsushita', meaning: 'tất, vớ'),
  Vocabulary(word: 'かさ', hiragana: 'かさ', romaji: 'kasa', meaning: 'ô, dù'),
  Vocabulary(word: 'タオル', hiragana: 'たおる', romaji: 'taoru', meaning: 'khăn'),
  Vocabulary(
      word: 'はブラシ',
      hiragana: 'はぶらし',
      romaji: 'haburashi',
      meaning: 'bàn chải đánh răng'),
  Vocabulary(
      word: 'はみがき',
      hiragana: 'はみがき',
      romaji: 'hamigaki',
      meaning: 'kem đánh răng'),
  Vocabulary(word: 'コップ', hiragana: 'こっぷ', romaji: 'koppu', meaning: 'cốc, ly'),
  Vocabulary(word: 'スプーン', hiragana: 'すぷーん', romaji: 'supūn', meaning: 'thìa'),
  Vocabulary(word: 'フォーク', hiragana: 'ふぉーく', romaji: 'fōku', meaning: 'nĩa'),
  Vocabulary(word: 'さら', hiragana: 'さら', romaji: 'sara', meaning: 'đĩa'),
  Vocabulary(word: 'はし', hiragana: 'はし', romaji: 'hashi', meaning: 'đũa'),
  Vocabulary(
      word: 'せっけん', hiragana: 'せっけん', romaji: 'sekken', meaning: 'xà phòng'),
  Vocabulary(
      word: 'シャンプー', hiragana: 'しゃんぷー', romaji: 'shanpū', meaning: 'dầu gội'),
  Vocabulary(word: 'ベッド', hiragana: 'べっど', romaji: 'beddo', meaning: 'giường'),
  Vocabulary(word: 'まくら', hiragana: 'まくら', romaji: 'makura', meaning: 'gối'),
  Vocabulary(
      word: 'ふとん',
      hiragana: 'ふとん',
      romaji: 'futon',
      meaning: 'chăn nệm kiểu Nhật'),
  Vocabulary(
      word: 'カーテン', hiragana: 'かーてん', romaji: 'kāten', meaning: 'rèm cửa'),
  Vocabulary(
      word: 'でんき', hiragana: 'でんき', romaji: 'denki', meaning: 'điện, đèn điện'),
  Vocabulary(
      word: 'エアコン', hiragana: 'えあこん', romaji: 'eakon', meaning: 'máy lạnh'),
  Vocabulary(word: 'テレビ', hiragana: 'てれび', romaji: 'terebi', meaning: 'ti vi'),
  Vocabulary(
      word: 'パソコン',
      hiragana: 'ぱそこん',
      romaji: 'pasokon',
      meaning: 'máy tính cá nhân'),
  Vocabulary(
      word: 'つくえランプ',
      hiragana: 'つくえらんぷ',
      romaji: 'tsukue ranpu',
      meaning: 'đèn bàn'),
  Vocabulary(
      word: 'ごみばこ', hiragana: 'ごみばこ', romaji: 'gomibako', meaning: 'thùng rác'),
];

@freezed
sealed class LessonState with _$LessonState {
  const factory LessonState({
    @Default(LessonType.vocabulary) LessonType lessonType,
    @Default([]) List<Vocabulary> vocabularyList,
  }) = _LessonState;
}

class LessonNotifier extends Notifier<LessonState> {
  @override
  LessonState build() {
    return LessonState(vocabularyList: vocabularyListSample);
  }

  void toggleLessonType(String type) {
    if (type == AppStrings.vocabulary) {
      state = state.copyWith(lessonType: LessonType.vocabulary);
    } else {
      state = state.copyWith(lessonType: LessonType.grammar);
    }
  }
}

final lessonProvider =
    NotifierProvider<LessonNotifier, LessonState>(LessonNotifier.new);
