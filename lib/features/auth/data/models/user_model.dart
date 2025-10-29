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

/// UserModel - Data transfer object cho User entity.
///
/// Tách biệt Data Model và Domain Entity vì:
/// - Domain Entity không nên biết về JSON
/// - API response format có thể thay đổi mà không ảnh hưởng Domain
/// - Data Model có thể có thêm metadata (lastSync, isCached...)
///
/// Sử dụng Freezed + json_serializable:
/// - @JsonSerializable: Auto generate fromJson/toJson
/// - @FreezedUnionValue: Custom mapping cho union values
///
/// Note: Với Freezed 3.x, không thể dùng @JsonKey trên constructor parameters.
/// Thay vào đó, dùng custom fromJson/toJson.
@freezed
sealed class UserModel with _$UserModel {
  const UserModel._();

  /// Factory constructor.
  ///
  /// Mapping fields:
  /// - API: user_id → Model: id
  /// - API: full_name → Model: name
  /// - API: avatar_url → Model: avatar
  /// - API: created_at → Model: createdAt
  factory UserModel({
    required String id,
    required String email,
    required String name,
    String? avatar,
    @Default('user') String role,
    required DateTime createdAt,
  }) = _UserModel;

  /// Factory constructor từ JSON.
  ///
  /// Custom mapping vì API trả về field names khác với model:
  /// - user_id → id
  /// - full_name → name
  /// - avatar_url → avatar
  /// - created_at → createdAt
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['full_name'] as String? ?? '',
      avatar: json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'user',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  /// Convert to JSON.
  ///
  /// Custom mapping ngược lại:
  /// - id → user_id
  /// - name → full_name
  /// - avatar → avatar_url
  /// - createdAt → created_at
  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'email': email,
      'full_name': name,
      'avatar_url': avatar,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // =========================================================================
  // DOMAIN CONVERSION
  // =========================================================================

  /// Convert Data Model -> Domain Entity.
  ///
  /// Tại sao cần conversion?
  /// - Domain Entity KHÔNG có JSON logic
  /// - Tách biệt concerns: Data layer biết JSON, Domain không
  /// - Data Model có thể có extra fields không cần trong Domain
  User toDomain() {
    return User(
      id: id,
      email: email,
      name: name,
      avatar: avatar,
      role: role,
      createdAt: createdAt,
    );
  }

  /// Convert Domain Entity -> Data Model.
  ///
  /// Use case: Khi cần save Domain Entity vào local storage (Hive, SQLite...)
  factory UserModel.fromDomain(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      avatar: user.avatar,
      role: user.role,
      createdAt: user.createdAt,
    );
  }
}

/// Extension để convert `List<UserModel>` -> `List<User>`.
extension UserModelListX on List<UserModel> {
  List<User> toDomain() => map((model) => model.toDomain()).toList();
}
