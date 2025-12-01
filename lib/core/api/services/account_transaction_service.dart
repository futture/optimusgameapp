import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/utils/error_util.dart';
import 'package:projeto_game_quiz/core/models/requests/generate_reference_request.dart';
import 'package:projeto_game_quiz/core/models/responses/generate_reference_response.dart';

class AccountTransactionService {
  ErrorUtil _errorUtil = ErrorUtil();

  final httpService = HttpClientService();

  Future<dynamic> generateReference(GenerateReferenceRequest obj) async {
    try {
      final successResult =
          await httpService.request<GenerateReferenceResponse>(
        '/transactions/generate-reference',
        method: 'POST',
        body: obj.toJson(),
        successParser: (json) => GenerateReferenceResponse.fromJson(json),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }
}
