import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/common/web_socket_api.dart';
import 'package:projeto_game_quiz/core/models/common/error_response.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';

class MatchService {
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
      return {"isSuccess": false, "error": e};
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
      return {"isSuccess": false, "error": e};
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
      return {"isSuccess": false, "error": e};
    }
  }

  Future<dynamic> createMatchAsync(
      String roomId, CreateMatchRequest request) async {
    try {
      final result = await httpService.request('/room/$roomId/match',
          method: 'POST', body: request.toJson());

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

  Future<dynamic> addPlayerMatchAsync(
      String matchId, AddPlayerMatchRequest request) async {
    try {
      final result = await httpService.request('/match/$matchId',
          method: 'PATCH', body: request.toJson());

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

  Future<dynamic> startMatchAsync(String matchId) async {
    try {
      final result = await httpService
          .request('/match/$matchId/start-match', method: 'PATCH', body: {});

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

  Future<dynamic> endGameAsync(String matchId) async {
    try {
      final result = await httpService
          .request('/match/$matchId/end-match', method: 'PATCH', body: {});

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
