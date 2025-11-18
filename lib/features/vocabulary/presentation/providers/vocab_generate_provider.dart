import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/vocab_generate_result.dart';
import 'vocab_generate_di.dart';

class VocabGenerateState {
  final bool isGenerating;
  final VocabGenerateResult? result;
  final String? error;

  const VocabGenerateState({
    this.isGenerating = false,
    this.result,
    this.error,
  });

  VocabGenerateState copyWith({
    bool? isGenerating,
    VocabGenerateResult? result,
    String? error,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return VocabGenerateState(
      isGenerating: isGenerating ?? this.isGenerating,
      result: clearResult ? null : (result ?? this.result),
      error: clearError ? null : error,
    );
  }
}

class VocabGenerateNotifier extends Notifier<VocabGenerateState> {
  @override
  VocabGenerateState build() {
    return const VocabGenerateState();
  }

  Future<VocabGenerateResult?> generateVocabularyItems({
    required String topicId,
    required String levelCode,
    required int count,
    String? customPrompt,
  }) async {
    state = state.copyWith(
      isGenerating: true,
      error: null,
    );

    try {
      final useCase = ref.read(generateVocabularyItemsUseCaseProvider);
      final result = await useCase(
        topicId: topicId,
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
    state = const VocabGenerateState();
  }
}

final vocabGenerateProvider =
    NotifierProvider<VocabGenerateNotifier, VocabGenerateState>(
  VocabGenerateNotifier.new,
);
