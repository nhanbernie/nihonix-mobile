import 'package:json_annotation/json_annotation.dart';
import '../../../../../core/network/converters/api_response_converter.dart';
import '../../models/topic_model.dart';

/// Converter for ApiResponse<List<TopicModel>>
class TopicListApiResponseConverter extends ApiResponseConverter<List<TopicModel>> {
  const TopicListApiResponseConverter() : super(_fromJson);
  
  static List<TopicModel> _fromJson(Object? json) {
    if (json is List) {
      return json.map((e) => TopicModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
