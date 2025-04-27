import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/utils/error_util.dart';
import 'package:projeto_game_quiz/core/models/requests/account_request.dart';
import 'package:projeto_game_quiz/core/models/requests/transaction_request.dart';
import 'package:projeto_game_quiz/core/models/responses/account_response.dart';
import 'package:projeto_game_quiz/core/models/responses/transaction_response.dart';

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

  Future<dynamic> createTransactionAsync(TransactionRequest request) async {
    try {
      print(request.toJson());
      final result = await httpService.request('/transactions',
          method: 'POST', body: request.toJson());
      return {"isSuccess": true, "data": result};
    } catch (e) {
      print(e);
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> listDepositTransactionsAsync(String accountId) async {
    try {
      final successResult =
          await httpService.request<List<TransactionResponse>>(
        '/accounts/$accountId/transactions',
        method: 'GET',
        successParser: (json) => (json as List)
            .map((item) => TransactionResponse.fromJson(item))
            .toList(),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }
}
