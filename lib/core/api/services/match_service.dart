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

  Future<dynamic> getMatchStartNoticeAsync(String matchId) async {
    try {
      final successResult = await httpService.request<MatchResponse>(
        '/match/$matchId/match-start-notice',
        method: 'GET',
        successParser: (json) => MatchResponse.fromJson(json),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> getAllMatchAsync(bool? isEvent, String? status) async {
    try {
      String route = "/match";

      if (isEvent != null) {
        route += "?isEvent=${isEvent}";
      } else if (status != null) {
        route += "?status=$status";
      } else if (isEvent != null && status != null) {
        route += "?isEvent=${isEvent}&status=$status";
      }

      final successResult = await httpService.request<List<MatchResponse>>(
        route,
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

  Future<dynamic> checkPlayerAlreadyRegisteredMatchAsync(
      String matchId, String userId) async {
    try {
      final successResult = await httpService
          .request('/match/${matchId}/user/${userId}', method: 'GET');
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

  Future<dynamic> leaveTheMatchAsync(String matchId, String userId) async {
    try {
      final result = await httpService
          .request('/match/$matchId/user/$userId', method: 'DELETE', body: {});

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
      final result = await httpService.request<MatchResultResponse>(
          '/match/$matchId/end-match',
          method: 'PATCH',
          body: {},
          successParser: (json) => MatchResultResponse.fromJson(json));

      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }
}
