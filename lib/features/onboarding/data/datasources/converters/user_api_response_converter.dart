import 'package:nihonix/core/network/converters/api_response_converter.dart';
import 'package:nihonix/features/auth/data/models/user_model.dart';

/// Converter for ApiResponse<UserModel>
class UserApiResponseConverter extends ApiResponseConverter<UserModel> {
  const UserApiResponseConverter() : super(_fromJson);

  static UserModel _fromJson(Object? json) {
    return UserModel.fromJson(json as Map<String, dynamic>);
  }
}
