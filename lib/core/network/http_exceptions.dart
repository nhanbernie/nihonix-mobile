library;

import 'package:dio/dio.dart';

/// Đây là abstract class (class trừu tượng) - không thể tạo instance trực tiếp,
abstract class HttpException implements Exception {
  final String message;

  /// HTTP status code (400, 401, 404, 500...)
  final int? statusCode;

  /// RequestOptions từ Dio (chứa thông tin về request)
  final RequestOptions? requestOptions;

  /// Response data từ server (có thể là Map, String, v.v.)
  final dynamic data;

  HttpException({
    required this.message,
    this.statusCode,
    this.requestOptions,
    this.data,
  });

  @override
  String toString() => '$runtimeType: $message (statusCode: $statusCode)';
}

class NoInternetException extends HttpException {
  NoInternetException()
      : super(
          message: 'Không có kết nối mạng. Vui lòng kiểm tra lại.',
        );
}

class UnauthorizedException extends HttpException {
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

class ServerException extends HttpException {
  ServerException({
    String? message,
    super.statusCode,
    super.requestOptions,
    super.data,
  }) : super(
          message: message ?? 'Lỗi máy chủ. Vui lòng thử lại sau.',
        );
}

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
