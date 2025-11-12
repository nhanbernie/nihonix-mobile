library;

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'onboarding_api.dart';

part 'onboarding_remote_datasource.g.dart';

/// Riverpod Provider for OnboardingRemoteDataSource
/// Dependency injection: Auto inject Dio instance
@riverpod
OnboardingRemoteDataSource onboardingRemoteDataSource(Ref ref) {
  // Example: final dio = ref.watch(dioProvider);
  throw UnimplementedError('Cần inject Dio instance từ DI container');
}

class OnboardingRemoteDataSource {
  final OnboardingApi _api;

  OnboardingRemoteDataSource(this._api);

  factory OnboardingRemoteDataSource.fromDio(Dio dio) {
    return OnboardingRemoteDataSource(OnboardingApi(dio));
  }

  Future<void> updateUserLevel(String levelCode) async {
    try {
      await _api.updateUserLevel({'level_code': levelCode});
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}

