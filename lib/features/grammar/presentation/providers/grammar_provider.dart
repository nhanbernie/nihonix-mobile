import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/grammar_sub_topic.dart';
import '../../domain/entities/grammar_pattern.dart';

part 'grammar_provider.freezed.dart';

@freezed
sealed class GrammarState with _$GrammarState {
  const factory GrammarState({
    @Default([]) List<GrammarSubTopic> subTopics,
    @Default([]) List<GrammarPattern> patterns,
    @Default(false) bool isLoading,
    String? error,
    GrammarSubTopic? selectedSubTopic,
  }) = _GrammarState;
}

class GrammarNotifier extends Notifier<GrammarState> {
  @override
  GrammarState build() {
    return const GrammarState();
  }

  Future<void> loadSubTopics(String topicName) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Call API to fetch sub topics
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data based on API response
      final subTopics = [
        GrammarSubTopic(
          slug: 'basic-patterns-greetings',
          topicId: '2821dca6-1d84-4b6f-88ca-4aab33dc0ba5',
          levelCode: 'N5',
          title: {
            'en': 'Basic Patterns',
            'jp': '基本構造',
            'vi': 'Cấu trúc cơ bản',
          },
          order: 1,
        ),
        GrammarSubTopic(
          slug: 'polite-forms-greetings-greetings',
          topicId: '2821dca6-1d84-4b6f-88ca-4aab33dc0ba5',
          levelCode: 'N5',
          title: {
            'en': 'Polite Forms',
            'jp': '丁寧形',
            'vi': 'Thể lịch sự',
          },
          order: 2,
        ),
        GrammarSubTopic(
          slug: 'time-based-greetings-greetings',
          topicId: '2821dca6-1d84-4b6f-88ca-4aab33dc0ba5',
          levelCode: 'N5',
          title: {
            'en': 'Time-based Greetings',
            'jp': '時間別の挨拶',
            'vi': 'Chào theo thời gian',
          },
          order: 3,
        ),
      ];

      state = state.copyWith(
        subTopics: subTopics,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadPatterns(String subTopicSlug) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Call API to fetch patterns
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data based on API response
      final patterns = [
        GrammarPattern(
          slug: 'basic-patterns-greetings-wa-desu-1',
          grammarSubTopicSlug: 'basic-patterns-greetings',
          topicSlug: 'greetings',
          levelCode: 'N5',
          patternJp: '〜は〜です',
          patternRomaji: '~wa ~desu',
          explanation: {
            'vi': 'Cấu trúc cơ bản để nói về tính chất hoặc đặc điểm',
            'en': 'Basic structure to describe characteristics or attributes',
            'jp': '基本的な構造で特性や特徴を述べる',
          },
          usageExamples: [
            const UsageExample(
              sentenceJp: '私は学生です',
              sentenceRomaji: 'Watashi wa gakusei desu',
              sentenceVi: 'Tôi là học sinh',
              sentenceEn: 'I am a student',
            ),
            const UsageExample(
              sentenceJp: 'これは本です',
              sentenceRomaji: 'Kore wa hon desu',
              sentenceVi: 'Đây là cuốn sách',
              sentenceEn: 'This is a book',
            ),
          ],
          conjugationRules: {},
          levelDifficulty: 'beginner',
          grammarPoints: [
            'copula',
            'basic sentence structure',
            'describing attributes',
          ],
          order: 1,
        ),
        GrammarPattern(
          slug: 'basic-patterns-greetings-san-2',
          grammarSubTopicSlug: 'basic-patterns-greetings',
          topicSlug: 'greetings',
          levelCode: 'N5',
          patternJp: '〜さん',
          patternRomaji: '~san',
          explanation: {
            'vi': 'Hậu tố lịch sự dùng sau tên người',
            'en': "Polite suffix used after a person's name",
            'jp': '人の名前の後につける丁寧な接尾辞',
          },
          usageExamples: [
            const UsageExample(
              sentenceJp: '田中さん',
              sentenceRomaji: 'Tanaka-san',
              sentenceVi: 'Ông/Bà/Cô/Anh Tanaka',
              sentenceEn: 'Mr./Ms./Mrs. Tanaka',
            ),
            const UsageExample(
              sentenceJp: '鈴木さん',
              sentenceRomaji: 'Suzuki-san',
              sentenceVi: 'Ông/Bà/Cô/Anh Suzuki',
              sentenceEn: 'Mr./Ms./Mrs. Suzuki',
            ),
          ],
          conjugationRules: {},
          levelDifficulty: 'beginner',
          grammarPoints: [
            'honorifics',
            'suffixes',
            'politeness',
          ],
          order: 2,
        ),
      ];

      state = state.copyWith(
        patterns: patterns,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void selectSubTopic(GrammarSubTopic subTopic) {
    state = state.copyWith(selectedSubTopic: subTopic);
  }
}

final grammarProvider = NotifierProvider<GrammarNotifier, GrammarState>(
  GrammarNotifier.new,
);
