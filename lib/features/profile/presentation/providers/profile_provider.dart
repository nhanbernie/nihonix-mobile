library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/update_profile_request.dart';
import 'profile_di.dart';

part 'profile_provider.freezed.dart';

/// Profile State
@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? error,
  }) = _ProfileState;
}

/// Profile Notifier
class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return const ProfileState();
  }

  /// Update user profile
  Future<void> updateProfile({
    required String userId,
    String? username,
    String? email,
    String? fullName,
    String? language,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      // Get use case from DI
      final updateProfileUseCase = ref.read(updateProfileUseCaseProvider);

      // Create request
      final request = UpdateProfileRequest(
        username: username,
        email: email,
        fullName: fullName,
        language: language,
      );

      // Call use case
      final updatedUser = await updateProfileUseCase(
        userId: userId,
        request: request,
      );

      // Update auth state with new user data
      ref.read(authProvider.notifier).updateUser(updatedUser);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        error: e.toString(),
      );
    }
  }

  /// Reset state
  void reset() {
    state = const ProfileState();
  }
}

/// Profile Provider
final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);

