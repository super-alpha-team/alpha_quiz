import 'package:alpha_quiz/modles/api/api_response_error.dart';

typedef ResponseObjectFromMap<T extends Object> = T Function(dynamic json);

class APIResponse<Response extends Object> {
  APIResponseError? error;
  Response? response;

  APIResponse({this.response, this.error});

  factory APIResponse.fromJson(
      dynamic json, ResponseObjectFromMap<Response> constructor) {
    if (json is Map<String, dynamic> && json['error'] != null) {
      APIResponseError error = APIResponseError.fromMap(json);
      return APIResponse(response: null, error: error);
    } else {
      Response response = constructor(json);
      return APIResponse(response: response, error: null);
    }
  }
}
