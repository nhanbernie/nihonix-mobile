/// Data Model: UserModel
///
/// Data layer model với JSON serialization.
/// Chuyển đổi giữa JSON (từ API) và Domain Entity.
///
/// Pattern 2025:
/// - Freezed cho immutability
/// - json_serializable cho auto JSON mapping
/// - Extension method để convert sang Domain Entity
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nihonix/features/auth/domain/entities/user.dart';

part 'user_model.freezed.dart';

@freezed
sealed class UserModel with _$UserModel {
  const UserModel._();

  factory UserModel({
    required String id,
    required String username,
    required String email,
    required String name,
    String? avatar,
    @Default('user') String role,
    required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final idString =
        idValue is int ? idValue.toString() : (idValue as String? ?? '');

    return UserModel(
      id: idString,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['full_name'] as String? ?? '',
      avatar: json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'user',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'username': username,
      'email': email,
      'full_name': name,
      'avatar_url': avatar,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }

  User toDomain() {
    return User(
      id: id,
      username: username,
      email: email,
      name: name,
      avatar: avatar,
      role: role,
      createdAt: createdAt,
    );
  }

  factory UserModel.fromDomain(User user) {
    return UserModel(
      id: user.id,
      username: user.username,
      email: user.email,
      name: user.name,
      avatar: user.avatar,
      role: user.role,
      createdAt: user.createdAt,
    );
  }
}

extension UserModelListX on List<UserModel> {
  List<User> toDomain() => map((model) => model.toDomain()).toList();
}
