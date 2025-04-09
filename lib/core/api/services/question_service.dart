import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/models/common/error_response.dart';
import 'package:projeto_game_quiz/core/models/requests/question_request.dart';
import 'package:projeto_game_quiz/core/models/responses/question_response.dart';

class QuestionService {
  final httpService = HttpClientService();

  Future<dynamic> getQuestionByMatchIdAsync(String matchId) async {
    try {
      final successResult = await httpService.request<List<QuestionResponse>>(
        '/match/$matchId/questions',
        method: 'GET',
        successParser: (json) => (json as List)
            .map((item) => QuestionResponse.fromJson(item))
            .toList(),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return {"isSuccess": false, "error": e};
    }
  }

  Future<dynamic> nextQuestionMatchAsync(String matchId) async {
    try {
      final result = await httpService.request<QuestionResponse>(
        '/questions/match/$matchId/next-question',
        method: 'GET',
        successParser: (json) => QuestionResponse.fromJson(json),
      );

      return {"isSuccess": true, "data": result};
    } catch (e) {
      if (e is ErrorResponse) {
        return {"isSuccess": false, "error": e};
      } else {
        return {
          "isSuccess": false,
          "error": {"message": "Ocorreu um erro inesperado"}
        };
      }
    }
  }

  Future<dynamic> answerQuestionAsync(String userId, PlayerAnswerRequest obj) async {
    try {
      final result = await httpService.request(
          '/question/user/$userId/answer-question',
          method: 'POST',
          body: obj.toJson());

      return {"isSuccess": true, "data": result};
    } catch (e) {
      if (e is ErrorResponse) {
        return {"isSuccess": false, "error": e};
      } else {
        return {
          "isSuccess": false,
          "error": {"message": "Ocorreu um erro inesperado"}
        };
      }
    }
  }

}
