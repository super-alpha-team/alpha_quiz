import 'package:alpha_quiz/modles/api/api_response.dart';
import 'package:alpha_quiz/modles/quiz/alpha_quiz.dart';
import 'package:alpha_quiz/modles/quiz/lti_quiz.dart';
import 'package:alpha_quiz/modles/quiz/quiz_status.dart';
import 'package:alpha_quiz/services/api.dart';
import 'package:alpha_quiz/services/api_request.dart';
import 'package:alpha_quiz/services/ws_function.dart';

class QuizAPI {
  static Future<APIResponse<List<LTIQuiz>>> getAllquizzes(
    int courseId,
  ) async {
    final uri = APIRequest.apiUri(
      WSFunction.MOD_LTI_GET_LTIS_BY_COURSES,
      'courseids[0]=$courseId',
    );

    final result = await APIRequest.get<List<LTIQuiz>>(uri, (json) {
      final data = json['ltis'];
      if (data == null) {
        throw Exception('Invalid ltis');
      }

      return List<LTIQuiz>.from(data.map((e) => LTIQuiz.fromJson(e)));
    });
    return result;
  }

  static Future<QuizRoom> getQuizRoom(int toolId) async {
    try {
      final token = await APIRequest.getLtiToken(toolId);
      final data = await APIRequest.alphaGet(
          uriString: AlphaAPI.alphaRest + '/lti/sync/lti',
          body: {
            'id_token': token,
            'state': '',
          });

      if ((data['status'] as String?) != 'success') {
        throw Exception('Status not success');
      }
      return QuizRoom.fromLtiSyncLti(data);
    } catch (_, __) {
      rethrow;
    }
  }

  static Future<String> joinQuiz(
    int toolId,
    int newQuizId,
    String username,
  ) async {
    try {
      final token = await APIRequest.getLtiToken(toolId);

      final data = await APIRequest.alphaPost(
          uriString: AlphaAPI.alphaRest + '/lti/play/$newQuizId/join',
          body: {
            'username': username,
            'is_teacher': false,
            'id_token': token,
            'state': '',
          });

      print(data);

      return data['alpha_token'];
    } catch (_, __) {
      rethrow;
    }
  }

  static Future<AlphaQuiz> syncInfo(int toolId) async {
    try {
      final token = await APIRequest.getLtiToken(toolId);
      final data = await APIRequest.alphaGet(
          uriString: AlphaAPI.alphaRest + '/lti/sync/info',
          body: {
            'id_token': token,
            'state': '',
          });
      print(data);

      return AlphaQuiz.fromJson(data['data']);
    } catch (_, __) {
      rethrow;
    }
  }

  // static Future<APIResponse<List<Question>>> getAllQuestions(
  //   int quizId,
  // ) async {
  //   final uri = APIRequest.apiUri(
  //     WSFunction.MOD_ALPHA_GET_QUIZZES_DATA,
  //     'quizid=$quizId',
  //   );

  //   final result = await APIRequest.get<List<Question>>(uri, (json) {
  //     final data = json['question_data'];
  //     if (data == null || data is! List) {
  //       throw Exception('Invalid question_data');
  //     }

  //     return List<Question>.from(data.map((e) => Question.fromJson(e)));
  //   });
  //   return result;
  // }
}
