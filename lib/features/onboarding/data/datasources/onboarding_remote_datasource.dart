library;

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/data/models/user_model.dart';
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

  Future<UserModel> updateUserLevel(String levelCode) async {
    try {
      final response = await _api.updateUserLevel({'level_code': levelCode});
      print('✅ Update Level Response: ${response.data?.toJson()}'); // DEBUG
      
      // Extract data from ApiResponse wrapper
      if (response.data == null) {
        throw Exception('API returned null data');
      }
      
      return response.data!;
    } on DioException catch (e) {
      print('❌ Update Level Error: ${e.response?.data}'); // DEBUG
      rethrow;
    } catch (e) {
      print('❌ Update Level Unknown Error: $e'); // DEBUG
      rethrow;
    }
  }
}
