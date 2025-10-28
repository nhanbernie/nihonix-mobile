library;

import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';

/// User entity đại diện cho người dùng trong hệ thống.
/// Sử dụng Freezed để:
/// - Immutable: Không thể thay đổi sau khi tạo
/// - copyWith: Tạo copy với một số field thay đổi
/// - Equality: So sánh object dựa trên value, không phải reference
/// - Pattern matching: Hỗ trợ sealed class patterns
@freezed
sealed class User with _$User {
  const User._();

  const factory User({
    required String id,
    required String email,
    required String name,
    String? avatar,
    @Default('user') String role,
    required DateTime createdAt,
  }) = _User;

  bool get isAdmin => role == 'admin';

  bool get isPremium => role == 'premium' || role == 'admin';

  String get firstName {
    final parts = name.split(' ');
    return parts.first;
  }

  String get initials {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return parts.map((p) => p[0].toUpperCase()).take(2).join();
  }

  String get avatarOrPlaceholder {
    return avatar ??
        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}';
  }
}
