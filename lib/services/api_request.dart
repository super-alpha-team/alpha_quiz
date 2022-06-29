import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:alpha_quiz/modles/api/api_response.dart';
import 'package:alpha_quiz/modles/api/request_exception.dart';
import 'package:alpha_quiz/services/api.dart';
import 'package:alpha_quiz/services/alpha_quiz_data.dart';
import 'package:alpha_quiz/services/ws_function.dart';
import 'package:http/http.dart' as http;

class APIRequest {
  static Future<dynamic> alphaPost<T extends Object>({
    required String uriString,
    Map? body,
  }) async {
    var uri = Uri.parse(uriString);

    HttpClient httpClient = HttpClient();
    final bodyString = json.encode(body ?? {});
    try {
      // final request = http.Request('POST', uri);
      // request.followRedirects = true;
      // request.body = bodyString;
      //   request.headers.set(HttpHeaders.contentTypeHeader, mimeType);
      // request.headers.set(HttpHeaders.contentLengthHeader, totalByteLength);

      //   final response = await client.send(request);
      //   final responseBody = await response.stream.bytesToString();

      HttpClientRequest request = await httpClient.postUrl(uri);

      request.followRedirects = false;

      final bodyBytes = utf8.encode(json.encode(body));

      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.headers.set(HttpHeaders.contentLengthHeader, bodyBytes.length);
      request.add(bodyBytes);
      await request.flush();
      HttpClientResponse response = await request.close();

      while (response.statusCode > 299 && response.statusCode < 400) {
        response.drain();
        final location = response.headers.value(HttpHeaders.locationHeader);
        if (location != null) {
          uri = uri.resolve(location);
          request = await httpClient.postUrl(uri);
          request.followRedirects = false;
          request.headers
              .set(HttpHeaders.contentTypeHeader, 'application/json');
          request.headers
              .set(HttpHeaders.contentLengthHeader, bodyBytes.length);
          request.add(bodyBytes);
          await request.flush();

          // Set the body or headers as desired.
          response = await request.close();
        }
      }
      String responseBody = await response.transform(utf8.decoder).join();
      httpClient.close();

      return json.decode(responseBody);
    } catch (_, __) {
      rethrow;
    } finally {}
  }

  static Future<dynamic> alphaGet<T extends Object>({
    required String uriString,
    Map? body,
  }) async {
    var uri = Uri.parse(uriString);

    HttpClient httpClient = HttpClient();
    final bodyString = json.encode(body ?? {});
    try {
      // final request = http.Request('POST', uri);
      // request.followRedirects = true;
      // request.body = bodyString;
      //   request.headers.set(HttpHeaders.contentTypeHeader, mimeType);
      // request.headers.set(HttpHeaders.contentLengthHeader, totalByteLength);

      //   final response = await client.send(request);
      //   final responseBody = await response.stream.bytesToString();

      HttpClientRequest request = await httpClient.getUrl(uri);

      request.followRedirects = true;

      final bodyBytes = utf8.encode(json.encode(body));

      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.headers.set(HttpHeaders.contentLengthHeader, bodyBytes.length);
      await request.flush();
      request.add(bodyBytes);
      HttpClientResponse response = await request.close();

      while (response.statusCode > 299 && response.statusCode < 400) {
        response.drain();
        final location = response.headers.value(HttpHeaders.locationHeader);
        if (location != null) {
          uri = uri.resolve(location);
          request = await httpClient.postUrl(uri);
          // Set the body or headers as desired.
          request.followRedirects = false;
          request.headers
              .set(HttpHeaders.contentTypeHeader, 'application/json');
          request.headers
              .set(HttpHeaders.contentLengthHeader, bodyBytes.length);
          request.add(bodyBytes);
          await request.flush();
          response = await request.close();
        }
      }
      String responseBody = await response.transform(utf8.decoder).join();
      httpClient.close();

      return json.decode(responseBody);
    } catch (_, __) {
      rethrow;
    } finally {}
  }

  static Future<String> getLtiToken(int toolId) async {
    final uri = APIRequest.apiUri(
      WSFunction.MOD_LTI_GET_TOOL_LAUNCH_DATA,
      'toolid=$toolId',
    );

    try {
      final result = await get<Map>(uri, (json) {
        return json;
      });

      final data = result.response!['parameters'][0];

      if (data['name'] == 'id_token') {
        return data['value'];
      } else {
        throw Exception('Invalid parameters');
      }
    } catch (_, __) {
      rethrow;
    }
  }

  static Future<String> alphaServerGet(String uriString, String token) async {
    final uri = Uri.parse(uriString);

    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    return response.body;
  }

  static Future<APIResponse<T>> get<T extends Object>(
      String uriString, ResponseObjectFromMap<T> constructor) async {
    final uri = Uri.parse(uriString.replaceAll('#', '%23'));
    final response = await http.get(uri);
    return _getCompletionHandler(response, constructor);
  }

  static String apiUri(String wsFunction, String param) {
    final String wsToken = AlphaQuizData.wsToken;
    final uriString = AlphaAPI.moodleRest +
        '?wstoken=$wsToken&moodlewsrestformat=json&wsfunction=$wsFunction&$param';
    return uriString;
  }

  static APIResponse<T> _getCompletionHandler<T extends Object>(
      http.Response response,
      ResponseObjectFromMap<T> responseObjectConstructor) {
    switch (response.statusCode) {
      case 200:
        return APIResponse.fromJson(
            json.decode(response.body), responseObjectConstructor);
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}


// enum WSFunction { CORE_ENROL_GET_USERS_COURSES }
// final wsFunctionValues = EnumValues({
//   'core_enrol_get_users_courses': WSFunction.CORE_ENROL_GET_USERS_COURSES,
// });
// class EnumValues<T> {
//     Map<String, T> map;
//     Map<T, String>? reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//         reverseMap ??= map.map((k, v) => MapEntry(v, k));
//         return reverseMap!;
//     }
// }
