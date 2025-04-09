
import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/models/common/error_response.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';

class RoomService {
  final httpService = HttpClientService();

  Future<dynamic> getAllRoomAsync() async {
    try {
      final successResult = await httpService.request<List<RoomResponse>>(
        '/rooms',
        method: 'GET',
        successParser: (json) =>(json as List).map((item) => RoomResponse.fromJson(item)).toList(),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return {"isSuccess": false, "error": e};
    }
  }

  Future<dynamic> createRoomAsync(CreateRoomRequest request) async {
    try {
      final result = await httpService.request('/room',
          method: 'POST', body: request.toJson());

      return {"isSuccess": true, "data": result};    

    } catch (e) {
      if (e is ErrorResponse) {
        return {"isSuccess": false, "error": e};
      } else {
        return {"isSuccess": false, "error": {"message":"Ocorreu um erro inesperado"}};
      }
    }
  }
}
