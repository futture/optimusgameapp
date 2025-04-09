import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/utils/error_util.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';

class MatchService {

  ErrorUtil _errorUtil = ErrorUtil();

  final httpService = HttpClientService();

  Future<dynamic> getMatchByMatchIdAsync(String matchId) async {
    try {
      final successResult = await httpService.request<MatchResponse>(
        '/match/$matchId',
        method: 'GET',
        successParser: (json) => MatchResponse.fromJson(json),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> getAllMatchAsync() async {
    try {
      final successResult = await httpService.request<List<MatchResponse>>(
        '/match',
        method: 'GET',
        successParser: (json) =>
            (json as List).map((item) => MatchResponse.fromJson(item)).toList(),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> getMatchByRoomIdAsync(String roomId) async {
    try {
      final successResult = await httpService.request<MatchResponse>(
        '/room/$roomId/match',
        method: 'GET',
        successParser: (json) => MatchResponse.fromJson(json),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> createMatchAsync(
      String roomId, CreateMatchRequest request) async {
    try {
      final result = await httpService.request('/room/$roomId/match',
          method: 'POST', body: request.toJson());

      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> addPlayerMatchAsync(
      String matchId, AddPlayerMatchRequest request) async {
    try {
      final result = await httpService.request('/match/$matchId',
          method: 'PATCH', body: request.toJson());

      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> startMatchAsync(String matchId) async {
    try {
      final result = await httpService
          .request('/match/$matchId/start-match', method: 'PATCH', body: {});

      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> endGameAsync(String matchId) async {
    try {
      final result = await httpService
          .request('/match/$matchId/end-match', method: 'PATCH', body: {});

      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

}
