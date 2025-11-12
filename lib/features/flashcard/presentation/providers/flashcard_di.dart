import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/providers.dart';
import '../../data/datasources/flashcard_remote_datasource.dart';
import '../../data/repositories/flashcard_repository_impl.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../../domain/usecases/create_flashcard_folder.dart';
import '../../domain/usecases/get_cards_in_set.dart';
import '../../domain/usecases/get_sets_in_folder.dart';
import '../../domain/usecases/get_folders.dart';
import '../../domain/usecases/get_folder_by_id.dart';
import '../../domain/usecases/update_folder.dart';
import '../../domain/usecases/delete_folder.dart';

/// Provider for FlashcardRemoteDataSource
final flashcardRemoteDataSourceProvider = Provider<FlashcardRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FlashcardRemoteDataSource.fromDio(apiClient.dio);
});

/// Provider for FlashcardRepository
final flashcardRepositoryProvider = Provider<FlashcardRepository>((ref) {
  final remoteDataSource = ref.watch(flashcardRemoteDataSourceProvider);
  return FlashcardRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for CreateFlashcardFolderUseCase
final createFlashcardFolderUseCaseProvider = Provider<CreateFlashcardFolderUseCase>((ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return CreateFlashcardFolderUseCase(repository);
});

/// Provider for GetCardsInSetUseCase
final getCardsInSetUseCaseProvider = Provider<GetCardsInSetUseCase>((ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return GetCardsInSetUseCase(repository);
});

/// Provider for GetSetsInFolderUseCase
final getSetsInFolderUseCaseProvider = Provider<GetSetsInFolderUseCase>((ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return GetSetsInFolderUseCase(repository);
});

/// Provider for GetFoldersUseCase
final getFoldersUseCaseProvider = Provider<GetFoldersUseCase>((ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return GetFoldersUseCase(repository);
});

/// Provider for GetFolderByIdUseCase
final getFolderByIdUseCaseProvider = Provider<GetFolderByIdUseCase>((ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return GetFolderByIdUseCase(repository);
});

/// Provider for UpdateFolderUseCase
final updateFolderUseCaseProvider = Provider<UpdateFolderUseCase>((ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return UpdateFolderUseCase(repository);
});

/// Provider for DeleteFolderUseCase
final deleteFolderUseCaseProvider = Provider<DeleteFolderUseCase>((ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return DeleteFolderUseCase(repository);
});
