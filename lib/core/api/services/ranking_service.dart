import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/utils/error_util.dart';
import 'package:projeto_game_quiz/core/models/responses/player_answers_response.dart';
import 'package:projeto_game_quiz/core/models/responses/ranking_response.dart';

class RankingService {
  ErrorUtil _errorUtil = ErrorUtil();

  final httpService = HttpClientService();

  Future<dynamic> getRankingByUserdAsync(String userId) async {
    try {
      final successResult = await httpService.request<List<RankingResponse>>(
        '/user/${userId}/ranking',
        method: 'GET',
        successParser: (json) => (json as List)
            .map((item) => RankingResponse.fromJson(item))
            .toList(),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> getHistoryUserdAsync(String userId, String matchId) async {
    try {
      final successResult =
          await httpService.request<List<PlayerAnswersResponse>>(
        '/player-anwer/user/${userId}/match/${matchId}',
        method: 'GET',
        successParser: (json) => (json as List)
            .map((item) => PlayerAnswersResponse.fromJson(item))
            .toList(),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }
}
