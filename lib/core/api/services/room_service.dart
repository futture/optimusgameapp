
import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/utils/error_util.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';

class RoomService {
  
  ErrorUtil _errorUtil = ErrorUtil();
  final httpService = HttpClientService();

  Future<dynamic> getAllRoomAsync(bool isEvent) async {
    try {
      final successResult = await httpService.request<List<RoomResponse>>(
        '/rooms?isEvent=$isEvent',
        method: 'GET',
        successParser: (json) =>(json as List).map((item) => RoomResponse.fromJson(item)).toList(),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> createRoomAsync(CreateRoomRequest request) async {
    try {
      final result = await httpService.request('/room',
          method: 'POST', body: request.toJson());

      return {"isSuccess": true, "data": result};    

    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

 Future<dynamic> updateRoomConfigurationAsync(
      String roomId, UpdateRoomConfigurationRequest request) async {
    try {
      final result = await httpService.request(
          '/room/$roomId/room-configuration',
          method: 'PUT',
          body: request.toJson());

      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }
}
