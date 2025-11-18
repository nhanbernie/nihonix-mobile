import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_remote_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;

  OnboardingRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> updateUserLevel(String levelCode) async {
    final userModel = await remoteDataSource.updateUserLevel(levelCode);
    return userModel.toDomain();
  }
}
