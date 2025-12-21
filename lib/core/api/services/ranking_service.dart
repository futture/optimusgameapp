import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/utils/error_util.dart';
import 'package:projeto_game_quiz/core/enum/ranking.dart';
import 'package:projeto_game_quiz/core/models/responses/player_answers_response.dart';
import 'package:projeto_game_quiz/core/models/responses/ranking_response.dart';

class RankingService {
  ErrorUtil _errorUtil = ErrorUtil();

  final httpService = HttpClientService();

  Future<dynamic> getRankingByUserdAsync(String userId, {DateTime? startDate,
      DateTime? endDate}) async {
    try {
      final queryParams = <String, String>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toString();
      }
      String queryString = Uri(queryParameters: queryParams).query;

      var route = queryString.isNotEmpty
          ? "/user/${userId}/ranking?$queryString"
          : "/user/${userId}/ranking";

      final successResult = await httpService.request<List<RankingResponse>>(
        route,
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

  Future<dynamic> getRankingByPeriodAsync(RankingPeriod period) async {
  try {
    // Aqui, fazemos a requisição para obter os dados brutos
    final successResult = await httpService.request<Map<String, dynamic>>(
      '/ranking/period/${period.value}',
      method: 'GET',
    );

    // Verificando se os dados da resposta são válidos
    if (successResult != null && successResult is Map<String, dynamic>) {
      // Convertemos os dados brutos para o objeto RankingWithTopWinnersResponse
      final rankingResponse = RankingWithTopWinnersResponse.fromJson(successResult);
      return {"isSuccess": true, "data": rankingResponse};
    } else {
      // Caso os dados recebidos não sejam válidos
      return {"isSuccess": false, "message": "Dados inválidos recebidos da API"};
    }
  } catch (e) {
    // Tratamento de erros
    return _errorUtil.handleError(e);
  }
}

}
