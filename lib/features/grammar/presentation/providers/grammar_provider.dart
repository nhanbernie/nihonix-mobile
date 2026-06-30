import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/grammar_sub_topic.dart';
import '../../domain/entities/grammar_pattern.dart';
import 'grammar_di.dart';

part 'grammar_provider.freezed.dart';

@freezed
sealed class GrammarState with _$GrammarState {
  const factory GrammarState({
    @Default([]) List<GrammarSubTopic> subTopics,
    @Default([]) List<GrammarPattern> patterns,
    @Default(false) bool isLoading,
    String? error,
    GrammarSubTopic? selectedSubTopic,
    String? currentTopicId,
  }) = _GrammarState;
}

class GrammarNotifier extends Notifier<GrammarState> {
  @override
  GrammarState build() {
    return const GrammarState();
  }

  Future<void> loadSubTopics(String topicId, {String? levelCode}) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      currentTopicId: topicId,
    );

    try {
      final useCase = ref.read(getGrammarSubTopicsUseCaseProvider);
      final subTopics = await useCase(
        topicId: topicId,
        levelCode: levelCode,
      );

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
      final useCase = ref.read(getGrammarPatternsUseCaseProvider);
      final patterns = await useCase(subTopicSlug);

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
