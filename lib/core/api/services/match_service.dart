import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/utils/error_util.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/utils/matchStatusUtil.dart';

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
      final successResult = await httpService.request(
        '/match/$matchId/match-start-notice',
        method: 'GET',
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> getAllMatchAsync(
      {List<String>? roomTypes,
      List<String>? status,
      DateTime? startDate,
      DateTime? endDate}) async {
    try {
      String queryString = '';

      if (status != null && status.isNotEmpty) {
        queryString +=
            status.map((s) => 'status=${Uri.encodeComponent(s)}').join('&');
      }

      if (roomTypes != null && roomTypes.isNotEmpty) {
        if (queryString.isNotEmpty) queryString += '&';
        queryString += roomTypes
            .map((s) => 'roomType=${Uri.encodeComponent(s)}')
            .join('&');
      }

      if (startDate != null) {
        if (queryString.isNotEmpty) queryString += '&';
        queryString +=
            'startDate=${Uri.encodeComponent(startDate.toIso8601String())}';
      }

      if (endDate != null) {
        if (queryString.isNotEmpty) queryString += '&';
        queryString +=
            'endDate=${Uri.encodeComponent(endDate.toIso8601String())}';
      }

      final route = queryString.isNotEmpty ? '/match?$queryString' : '/match';
      print("[INFOdd] - url: $route");

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

  Future<dynamic> getMatchByUserIdAsync(String userId,
      {List<String>? roomTypes,
      List<String>? status,
      DateTime? startDate,
      DateTime? endDate}) async {
    try {
      String queryString = '';

      if (status != null && status.isNotEmpty) {
        queryString +=
            status.map((s) => 'status=${Uri.encodeComponent(s)}').join('&');
      }

      if (roomTypes != null && roomTypes.isNotEmpty) {
        if (queryString.isNotEmpty) queryString += '&';
        queryString += roomTypes
            .map((s) => 'roomType=${Uri.encodeComponent(s)}')
            .join('&');
      }

      if (startDate != null) {
        if (queryString.isNotEmpty) queryString += '&';
        queryString +=
            'startDate=${Uri.encodeComponent(startDate.toIso8601String())}';
      }

      if (endDate != null) {
        if (queryString.isNotEmpty) queryString += '&';
        queryString +=
            'endDate=${Uri.encodeComponent(endDate.toIso8601String())}';
      }

      var route = queryString.isNotEmpty
          ? "/user/${userId}/match?$queryString"
          : "/user/${userId}/match";

      print("[INFOdd] - url: $route");

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

  Future<dynamic> inactivatePlayerInMatchAsync(
      String matchId, String userId) async {
    try {
      final result = await httpService.request<MatchResultResponse>(
          '/match/${matchId}/user/${userId}/inactivate-player',
          method: 'PATCH',
          body: {},
          successParser: (json) => MatchResultResponse.fromJson(json));

      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> activatePlayerInMatchAsync(
      String matchId, String userId) async {
    try {
      final result = await httpService.request<MatchResultResponse>(
          '/match/${matchId}/user/${userId}/activate-player',
          method: 'PATCH',
          body: {},
          successParser: (json) => MatchResultResponse.fromJson(json));

      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> checkUserHasMatchInProgressToday(String userId) async {
    try {
      
      final nowUtc = DateTime.now().toUtc();

      var startOfTodayUtc = DateTime.utc(
        nowUtc.year,
        nowUtc.month,
        nowUtc.day,
      ); 
      final endOfTodayUtc = startOfTodayUtc.add(const Duration(days: 1)); 
      final statusValue = MatchStatusUtil.toBackendValue("IN_PROGRESS"); 
      final queryString = 'status=${Uri.encodeComponent(statusValue)}&'
          'startDate=${Uri.encodeComponent(startOfTodayUtc.toIso8601String())}&'
          'endDate=${Uri.encodeComponent(endOfTodayUtc.toIso8601String())}';

      final route = "/user/$userId/match?$queryString";

      final successResult = await httpService.request<List<MatchResponse>>(
        route,
        method: 'GET',
        successParser: (json) =>
            (json as List).map((item) => MatchResponse.fromJson(item)).toList(),
      );

      return {
        "isSuccess": true,
        "hasMatchToday": successResult.isNotEmpty,
        "matchCount": successResult.length,
        "matches": successResult,
      };
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }
}
