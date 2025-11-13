import 'package:json_annotation/json_annotation.dart';
import '../api_response.dart';

/// Generic converter for ApiResponse<T>
class ApiResponseConverter<T> implements JsonConverter<ApiResponse<T>, Map<String, dynamic>> {
  final T Function(Object?) fromJsonT;
  
  const ApiResponseConverter(this.fromJsonT);

  @override
  ApiResponse<T> fromJson(Map<String, dynamic> json) {
    return ApiResponse<T>.fromJson(json, fromJsonT);
  }

  @override
  Map<String, dynamic> toJson(ApiResponse<T> object) {
    return object.toJson((value) => value as Object);
  }
}
