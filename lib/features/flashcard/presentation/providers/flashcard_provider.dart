import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nihonix/features/flashcard/domain/entities/flashcard_folder.dart';
import 'flashcard_di.dart';

part 'flashcard_provider.freezed.dart';

@freezed
sealed class FlashcardState with _$FlashcardState {
  const factory FlashcardState({
    @Default([]) List<FlashcardFolder> folders,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? error,
  }) = _FlashcardState;
}

class FlashcardNotifier extends Notifier<FlashcardState> {
  @override
  FlashcardState build() {
    // Auto load folders when provider initializes
    Future.microtask(() => loadFolders());
    return const FlashcardState();
  }

  Future<void> loadFolders() async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);
    try {
      final repository = ref.read(flashcardRepositoryProvider);
      final folders = await repository.getFolders();
      state = state.copyWith(
        folders: folders,
        isLoading: false,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        error: e.toString(),
      );
    }
  }

  Future<bool> createFolder({
    required String name,
    String? description,
    int order = 0,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);
    try {
      final useCase = ref.read(createFlashcardFolderUseCaseProvider);
      final folder = await useCase.call(
        name: name,
        description: description ?? '',
        order: order,
      );

      // Add to list
      final updatedFolders = [...state.folders, folder];
      state = state.copyWith(
        folders: updatedFolders,
        isLoading: false,
        isSuccess: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateFolder({
    required String id,
    String? name,
    String? description,
    int? order,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);
    try {
      final repository = ref.read(flashcardRepositoryProvider);
      final folder = await repository.updateFolder(
        id: id,
        name: name,
        description: description,
        order: order,
      );

      // Update in list
      final updatedFolders = state.folders.map((f) {
        return f.id == id ? folder : f;
      }).toList();
      state = state.copyWith(
        folders: updatedFolders,
        isLoading: false,
        isSuccess: true,
      );
      return true;
    } catch (e) {
      print('[FlashcardNotifier] Error updating folder: $e');
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteFolder(String id) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);
    try {
      final repository = ref.read(flashcardRepositoryProvider);
      await repository.deleteFolder(id);

      // Remove from list
      final updatedFolders = state.folders.where((f) => f.id != id).toList();
      state = state.copyWith(
        folders: updatedFolders,
        isLoading: false,
        isSuccess: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        error: e.toString(),
      );
      return false;
    }
  }

  void reset() {
    state = const FlashcardState();
  }
}

/// Flashcard Provider
final flashcardProvider = NotifierProvider<FlashcardNotifier, FlashcardState>(
  FlashcardNotifier.new,
);
