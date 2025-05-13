import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/utils/error_util.dart';
import 'package:projeto_game_quiz/core/models/responses/push_notification_response.dart';

class UserPushNotificationService {
  ErrorUtil _errorUtil = ErrorUtil();

  final httpService = HttpClientService();

  Future<dynamic> getPuahNotificationByUserIdAsync(String userId) async {
    try {
      final successResult =
          await httpService.request<List<PushNotificationResponse>>(
        '/user/${userId}/push-notification',
        method: 'GET',
        successParser: (json) => (json as List)
            .map((item) => PushNotificationResponse.fromJson(item))
            .toList(),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }
}
