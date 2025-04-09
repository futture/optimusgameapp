import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/models/common/error_response.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/requests/user_request.dart';

class UserService {
  final httpService = HttpClientService();

  Future<dynamic> createFcmTokenAsync(
      String userId, CreateFcmTokenRequest request) async {
    try {
      final result = await httpService.request('/users/$userId/divice-info',
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
