library;

import '../../../../core/network/api_response.dart';
import 'login_response.dart';
import 'user_model.dart';

/// Typed API Response cho Auth endpoints
typedef LoginApiResponse = ApiResponse<LoginResponse>;
typedef UserApiResponse = ApiResponse<UserModel>;
typedef MessageApiResponse = ApiResponse<String>;

/// Helper để tạo Auth API responses
class AuthApiResponseHelper {
  /// Tạo success response cho login
  static LoginApiResponse loginSuccess(LoginResponse loginData) {
    return ApiResponseSuccess.create(
      data: loginData,
      message: 'Đăng nhập thành công',
      statusCode: 200,
    );
  }

  /// Tạo success response cho user info
  static UserApiResponse userSuccess(UserModel user) {
    return ApiResponseSuccess.create(
      data: user,
      message: 'Lấy thông tin người dùng thành công',
      statusCode: 200,
    );
  }

  /// Tạo success response cho message
  static MessageApiResponse messageSuccess(String message) {
    return ApiResponseSuccess.create(
      data: message,
      message: 'Thành công',
      statusCode: 200,
    );
  }

  /// Tạo error response cho auth
  static LoginApiResponse authError(String message,
      {dynamic errors, int? statusCode}) {
    return ApiResponseError.create(
      message: message,
      errors: errors,
      statusCode: statusCode,
    );
  }
}

/// Extension để convert từ raw response sang typed response
extension AuthResponseConverter on Map<String, dynamic> {
  /// Convert raw response sang LoginApiResponse
  LoginApiResponse toLoginResponse() {
    return ApiResponse<LoginResponse>.fromJson(
      this,
      (json) => json != null
          ? LoginResponse.fromJson(json as Map<String, dynamic>)
          : throw Exception('Invalid login data'),
    );
  }

  /// Convert raw response sang UserApiResponse
  UserApiResponse toUserResponse() {
    return ApiResponse<UserModel>.fromJson(
      this,
      (json) => json != null
          ? UserModel.fromJson(json as Map<String, dynamic>)
          : throw Exception('Invalid user data'),
    );
  }

  /// Convert raw response sang MessageApiResponse
  MessageApiResponse toMessageResponse() {
    return ApiResponse<String>.fromJson(
      this,
      (json) => json != null
          ? json as String
          : throw Exception('Invalid message data'),
    );
  }
}
