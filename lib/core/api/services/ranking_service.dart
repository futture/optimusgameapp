//ranking_service

import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/utils/error_util.dart';
import 'package:projeto_game_quiz/core/enum/ranking.dart';
import 'package:projeto_game_quiz/core/models/responses/player_answers_response.dart';
import 'package:projeto_game_quiz/core/models/responses/ranking_response.dart';

class RankingService {
  ErrorUtil _errorUtil = ErrorUtil();

  final httpService = HttpClientService();

  Future<dynamic> getRankingByUserdAsync(String userId,
      {DateTime? startDate, DateTime? endDate}) async {
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
      final successResult = await httpService.request<Map<String, dynamic>>(
        '/ranking/period/${period.value}',
        method: 'GET',
      );
      if (successResult != null && successResult is Map<String, dynamic>) {
        final rankingResponse =
            RankingWithTopWinnersResponse.fromJson(successResult);
        return {"isSuccess": true, "data": rankingResponse};
      } else {
        return {
          "isSuccess": false,
          "message": "Dados inválidos recebidos da API"
        };
      }
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> getEarningsLossesByPeriodAsync({
    required String userId,
    required String periodType,
    DateTime? specificDate,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'period_type': periodType,
        'specific_date': specificDate?.toIso8601String(),
      };

      body.removeWhere((key, value) => value == null);

      final successResult = await httpService.request<Map<String, dynamic>>(
        '/earning-losses/$userId',
        method: 'POST',
        body: body,
      );

      if (successResult != null && successResult is Map<String, dynamic>) {
        return {
          "isSuccess": true,
          "data": {
            'total_cash_wins': successResult['total_cash_wins'] ?? 0.0,
            'total_cash_losses': successResult['total_cash_losses'] ?? 0.0,
            'total_cash_balance': successResult['total_cash_balance'] ?? 0.0,
            'rankings': successResult['rankings'] ?? [],
            'ranking_count': successResult['ranking_count'] ?? 0,
            'period_type': successResult['period_type'],
            'start_date': successResult['start_date'],
            'end_date': successResult['end_date'],
          }
        };
      } else {
        return {
          "isSuccess": false,
          "message": "Dados inválidos recebidos da API"
        };
      }
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }
}
