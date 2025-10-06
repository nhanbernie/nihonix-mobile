/// File chứa tất cả HTTP exception classes.
///
/// Định nghĩa các exception tùy chỉnh để xử lý các lỗi HTTP một cách
/// thân thiện và có cấu trúc. Mỗi exception class đại diện cho một loại
/// lỗi HTTP cụ thể (400, 401, 403, 404, 408, 5xx...).
///
/// Các exception này sẽ được sử dụng bởi AuthInterceptor và có thể
/// được catch ở presentation layer để hiển thị message phù hợp cho user.
library;

import 'package:dio/dio.dart';

// ============================================================================
// BASE HTTP EXCEPTION
// ============================================================================

/// Base exception cho tất cả HTTP errors.
///
/// Đây là abstract class (class trừu tượng) - không thể tạo instance trực tiếp,
/// chỉ dùng để các class khác extend (kế thừa).
///
/// Implements Exception: Cho phép class này được throw và catch như exception.
abstract class HttpException implements Exception {
  /// Message mô tả lỗi (tiếng Việt, thân thiện với user)
  final String message;

  /// HTTP status code (400, 401, 404, 500...)
  final int? statusCode;

  /// RequestOptions từ Dio (chứa thông tin về request)
  final RequestOptions? requestOptions;

  /// Response data từ server (có thể là Map, String, v.v.)
  final dynamic data;

  /// Constructor của base class
  ///
  /// Syntax:
  /// - required this.message: Bắt buộc phải truyền message khi tạo exception
  /// - this.statusCode: Optional parameter, có thể null
  /// - this.requestOptions: Optional, thông tin về request gây lỗi
  /// - this.data: Optional, dữ liệu response từ server
  HttpException({
    required this.message,
    this.statusCode,
    this.requestOptions,
    this.data,
  });

  /// Override toString() để in exception đẹp hơn khi debug
  ///
  /// runtimeType: Lấy tên class thực tế (UnauthorizedException, NotFoundException...)
  ///
  /// Ví dụ output: "UnauthorizedException: Phiên đăng nhập hết hạn (statusCode: 401)"
  @override
  String toString() => '$runtimeType: $message (statusCode: $statusCode)';
}

// ============================================================================
// SPECIFIC HTTP EXCEPTIONS
// ============================================================================

/// Exception khi không có kết nối mạng.
///
/// Được throw khi NetworkInfo.isConnected = false
/// hoặc khi Dio gặp connection error.
class NoInternetException extends HttpException {
  /// Constructor không cần tham số vì message đã cố định
  ///
  /// Syntax:
  /// - : super(...) gọi constructor của class cha (HttpException)
  /// - message: 'Không có kết nối...' được truyền lên parent
  NoInternetException()
      : super(
          message: 'Không có kết nối mạng. Vui lòng kiểm tra lại.',
        );
}

/// Exception khi nhận HTTP 401 Unauthorized.
///
/// Thường xảy ra khi:
/// - Access token hết hạn
/// - Token không hợp lệ
/// - Chưa đăng nhập
class UnauthorizedException extends HttpException {
  /// Constructor với optional parameters
  ///
  /// Syntax:
  /// - String? message: Nullable string, nếu không truyền sẽ dùng default
  /// - super.requestOptions: Truyền trực tiếp lên constructor cha
  /// - super.data: Truyền trực tiếp lên constructor cha
  /// - : super(...) phải đặt SAU dấu )
  UnauthorizedException({
    String? message,
    super.requestOptions,
    super.data,
  }) : super(
          message:
              message ?? 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
          statusCode: 401,
        );
}

/// Exception khi nhận HTTP 403 Forbidden.
///
/// Xảy ra khi user không có quyền truy cập resource,
/// thường do role/permission không đủ.
class ForbiddenException extends HttpException {
  ForbiddenException({
    String? message,
    super.requestOptions,
    super.data,
  }) : super(
          message: message ?? 'Bạn không có quyền truy cập tài nguyên này.',
          statusCode: 403,
        );
}

/// Exception khi nhận HTTP 404 Not Found.
///
/// Xảy ra khi endpoint không tồn tại hoặc resource đã bị xóa.
class NotFoundException extends HttpException {
  NotFoundException({
    String? message,
    super.requestOptions,
    super.data,
  }) : super(
          message: message ?? 'Không tìm thấy tài nguyên yêu cầu.',
          statusCode: 404,
        );
}

/// Exception khi nhận HTTP 408 Request Timeout
/// hoặc khi Dio timeout (connectionTimeout, receiveTimeout, sendTimeout).
///
/// Xảy ra khi:
/// - Request mất quá nhiều thời gian
/// - Server phản hồi chậm
/// - Network lag
class RequestTimeoutException extends HttpException {
  RequestTimeoutException({
    String? message,
    super.requestOptions,
  }) : super(
          message: message ?? 'Yêu cầu quá thời gian chờ. Vui lòng thử lại.',
          statusCode: 408,
        );
}

/// Exception khi nhận HTTP 400 Bad Request.
///
/// Xảy ra khi:
/// - Dữ liệu gửi lên không đúng format
/// - Thiếu required fields
/// - Validation failed
class BadRequestException extends HttpException {
  BadRequestException({
    String? message,
    super.requestOptions,
    super.data,
  }) : super(
          message: message ?? 'Yêu cầu không hợp lệ.',
          statusCode: 400,
        );
}

/// Exception khi nhận HTTP 5xx Server Error.
///
/// Xảy ra khi:
/// - Server gặp lỗi nội bộ (500 Internal Server Error)
/// - Server đang bảo trì (503 Service Unavailable)
/// - Gateway error (502 Bad Gateway)
///
/// Note: statusCode có thể là 500, 502, 503, 504...
class ServerException extends HttpException {
  /// Constructor cho phép truyền statusCode động (500, 502, 503...)
  ///
  /// Syntax:
  /// - super.statusCode: Truyền statusCode trực tiếp lên parent
  ///   (khác với các class khác có statusCode cố định)
  ServerException({
    String? message,
    super.statusCode,
    super.requestOptions,
    super.data,
  }) : super(
          message: message ?? 'Lỗi máy chủ. Vui lòng thử lại sau.',
        );
}

/// Exception cho các lỗi không xác định hoặc không thuộc các loại trên.
///
/// Đây là fallback exception khi không match được với các status code cụ thể.
class UnknownHttpException extends HttpException {
  UnknownHttpException({
    String? message,
    super.statusCode,
    super.requestOptions,
    super.data,
  }) : super(
          message: message ?? 'Đã xảy ra lỗi không xác định.',
        );
}
