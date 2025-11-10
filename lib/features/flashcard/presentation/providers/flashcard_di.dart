import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/providers.dart';
import '../../data/datasources/flashcard_remote_datasource.dart';
import '../../data/repositories/flashcard_repository_impl.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../../domain/usecases/create_flashcard_folder.dart';

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
