import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/grammar_generate_result.dart';
import 'grammar_generate_di.dart';

class GrammarGenerateState {
  final bool isGenerating;
  final GrammarGenerateResult? result;
  final String? error;

  const GrammarGenerateState({
    this.isGenerating = false,
    this.result,
    this.error,
  });

  GrammarGenerateState copyWith({
    bool? isGenerating,
    GrammarGenerateResult? result,
    String? error,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return GrammarGenerateState(
      isGenerating: isGenerating ?? this.isGenerating,
      result: clearResult ? null : (result ?? this.result),
      error: clearError ? null : error,
    );
  }
}

class GrammarGenerateNotifier extends Notifier<GrammarGenerateState> {
  @override
  GrammarGenerateState build() {
    return const GrammarGenerateState();
  }

  Future<GrammarGenerateResult?> generateGrammarPatterns({
    required String grammarSubTopicSlug,
    required String levelCode,
    required int count,
    String? customPrompt,
  }) async {
    state = state.copyWith(
      isGenerating: true,
      error: null,
      clearResult: true,
    );

    try {
      final useCase = ref.read(generateGrammarPatternsUseCaseProvider);
      final result = await useCase(
        grammarSubTopicSlug: grammarSubTopicSlug,
        levelCode: levelCode,
        count: count,
        customPrompt: customPrompt,
      );

      state = state.copyWith(
        isGenerating: false,
        result: result,
        clearError: true,
      );
      
      return result; // Return result
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        error: e.toString(),
        clearResult: true,
      );
      
      return null; // Return null on error
    }
  }

  void clearResult() {
    state = const GrammarGenerateState();
  }
}

final grammarGenerateProvider =
    NotifierProvider<GrammarGenerateNotifier, GrammarGenerateState>(
  GrammarGenerateNotifier.new,
);

