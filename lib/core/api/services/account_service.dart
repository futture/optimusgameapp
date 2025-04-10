import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/utils/error_util.dart';
import 'package:projeto_game_quiz/core/models/requests/account_request.dart';
import 'package:projeto_game_quiz/core/models/responses/account_response.dart';

class AccountService {
  ErrorUtil _errorUtil = ErrorUtil();

  final httpService = HttpClientService();

  Future<dynamic> getAccountByUserIdAsync(String userId) async {
    try {
      final successResult = await httpService.request<AccountResponse>(
        '/user/$userId/account',
        method: 'GET',
        successParser: (json) => AccountResponse.fromJson(json),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> createAccountAsync(
      String userId, CreateAccountRequest request) async {
    try {
      final result = await httpService.request('/user/$userId/account',
          method: 'POST', body: request.toJson());

      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

}