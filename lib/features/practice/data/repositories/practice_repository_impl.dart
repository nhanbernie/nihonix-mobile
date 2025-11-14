import '../../domain/entities/exercise_session.dart';
import '../../domain/repositories/practice_repository.dart';
import '../datasources/practice_remote_datasource.dart';

class PracticeRepositoryImpl implements PracticeRepository {
  final PracticeRemoteDataSource _remoteDataSource;

  PracticeRepositoryImpl(this._remoteDataSource);

  @override
  Future<ExerciseSession> generateFillBlankExercises({
    required String topicId,
    required int exerciseCount,
  }) async {
    return await _remoteDataSource.generateFillBlankExercises(
      topicId: topicId,
      exerciseCount: exerciseCount,
    );
  }

  @override
  Future<ExerciseSession> generateMultipleChoiceExercises({
    required String topicId,
    required int exerciseCount,
  }) async {
    return await _remoteDataSource.generateMultipleChoiceExercises(
      topicId: topicId,
      exerciseCount: exerciseCount,
    );
  }
}

