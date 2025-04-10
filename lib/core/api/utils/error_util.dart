import 'package:projeto_game_quiz/core/models/common/error_response.dart';

class ErrorUtil {

    Map<String, dynamic> handleError(dynamic e) {
    if (e is DetailErrorResponse) {
      return {"isSuccess": false, "error": e};
    } else {
      return {
        "isSuccess": false,
        "error": {"message": "Ocorreu um erro inesperado"}
      };
    }
  }
}