import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/utils/error_util.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';

class RoomService {
  ErrorUtil _errorUtil = ErrorUtil();
  final httpService = HttpClientService();

  Future<dynamic> getAllRoomAsync({List<String>? roomTypes}) async {
    try {
      String queryString = '';

      if (roomTypes != null && roomTypes.isNotEmpty) {
        if (queryString.isNotEmpty) queryString += '&';
        queryString += roomTypes
            .map((s) => 'roomType=${Uri.encodeComponent(s)}')
            .join('&');
      }

      final route = queryString.isNotEmpty ? '/rooms?$queryString' : '/rooms?';
      print("[INFOdd] - url: $route");

      final successResult = await httpService.request<List<RoomResponse>>(
        route,
        method: 'GET',
        successParser: (json) =>
            (json as List).map((item) => RoomResponse.fromJson(item)).toList(),
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
