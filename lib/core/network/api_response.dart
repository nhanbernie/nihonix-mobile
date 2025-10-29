library;

// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'api_response.freezed.dart';
// part 'api_response.g.dart';

/// Base API Response wrapper theo format chuẩn
///
/// Tương ứng với TypeScript interface:
/// ```typescript
/// export interface ApiResponse<T = any> {
///   success: boolean;
///   message: string;
///   data: T | null;
///   errors: any | null;
///   statusCode?: number;
/// }
/// ```
// @freezed
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  final bool success;
  final String message;
  final T? data;
  final dynamic errors;
  final int? statusCode;

  /// Factory constructor từ JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json['errors'],
      statusCode: json['statusCode'] as int?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': data != null ? toJsonT(data as T) : null,
      'errors': errors,
      'statusCode': statusCode,
    };
  }
}

/// Success response helper
class ApiResponseSuccess<T> {
  static ApiResponse<T> create<T>({
    required T data,
    String message = 'Success',
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      errors: null,
      statusCode: statusCode,
    );
  }
}

/// Error response helper
class ApiResponseError<T> {
  static ApiResponse<T> create<T>({
    required String message,
    dynamic errors,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      data: null,
      errors: errors,
      statusCode: statusCode,
    );
  }
}

/// Extension để convert ApiResponse sang các types khác
extension ApiResponseX<T> on ApiResponse<T> {
  /// Kiểm tra response có thành công không
  bool get isSuccess => success && data != null;

  /// Kiểm tra response có lỗi không
  bool get isError => !success || errors != null;

  /// Lấy data hoặc throw exception nếu error
  T get dataOrThrow {
    if (isError) {
      throw Exception('API Error: $message');
    }
    return data as T;
  }

  /// Lấy data hoặc return default value
  T dataOr(T defaultValue) {
    return isSuccess ? (data as T) : defaultValue;
  }
}
