import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/network/providers.dart';
import '../../data/datasources/onboarding_remote_datasource.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/usecases/update_user_level.dart';

final onboardingDataSourceProvider = Provider<OnboardingRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OnboardingRemoteDataSource.fromDio(apiClient.dio);
});

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final dataSource = ref.watch(onboardingDataSourceProvider);
  return OnboardingRepositoryImpl(dataSource);
});

final updateUserLevelUseCaseProvider = Provider<UpdateUserLevel>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return UpdateUserLevel(repository);
});

final updateUserLevelProvider = FutureProvider.family<void, String>((ref, levelCode) async {
  final useCase = ref.watch(updateUserLevelUseCaseProvider);
  await useCase(levelCode);
});
