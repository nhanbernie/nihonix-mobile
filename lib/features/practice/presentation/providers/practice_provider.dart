import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/providers.dart';
import '../../data/datasources/practice_api.dart';
import '../../data/datasources/practice_remote_datasource.dart';
import '../../data/repositories/practice_repository_impl.dart';
import '../../domain/entities/exercise_session.dart';
import '../../domain/repositories/practice_repository.dart';

part 'practice_provider.g.dart';

// API Provider
@riverpod
PracticeApi practiceApi(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PracticeApi(apiClient.dio);
}

// Remote DataSource Provider
@riverpod
PracticeRemoteDataSource practiceRemoteDataSource(Ref ref) {
  final api = ref.watch(practiceApiProvider);
  return PracticeRemoteDataSource(api);
}

// Repository Provider
@riverpod
PracticeRepository practiceRepository(Ref ref) {
  final remoteDataSource = ref.watch(practiceRemoteDataSourceProvider);
  return PracticeRepositoryImpl(remoteDataSource);
}

// Generate Fill Blank Exercises
@riverpod
Future<ExerciseSession> generateFillBlankExercises(
  Ref ref, {
  required String topicId,
  int exerciseCount = 10,
}) async {
  final repository = ref.watch(practiceRepositoryProvider);
  return await repository.generateFillBlankExercises(
    topicId: topicId,
    exerciseCount: exerciseCount,
  );
}

// Generate Multiple Choice Exercises
@riverpod
Future<ExerciseSession> generateMultipleChoiceExercises(
  Ref ref, {
  required String topicId,
  int exerciseCount = 10,
}) async {
  final repository = ref.watch(practiceRepositoryProvider);
  return await repository.generateMultipleChoiceExercises(
    topicId: topicId,
    exerciseCount: exerciseCount,
  );
}

