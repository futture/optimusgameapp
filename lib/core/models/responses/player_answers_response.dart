import 'package:projeto_game_quiz/core/models/responses/question_response.dart';

class PlayerAnswersResponse {
  QuestionResponse? question;
  int? responseTimeInSecond;
  OptionAnswersResponse? optionAnswer;
  bool? isExpanded;
  PlayerAnswersResponse(
      {this.question,
      this.responseTimeInSecond,
      this.optionAnswer,
      this.isExpanded});

  PlayerAnswersResponse.fromJson(Map<String, dynamic> json) {
    question = json['question'] != null
        ? new QuestionResponse.fromJson(json['question'])
        : null;
    responseTimeInSecond = json['responseTimeInSecond'];
    optionAnswer = json['optionAnswer'] != null
        ? new OptionAnswersResponse.fromJson(json['optionAnswer'])
        : null;
    isExpanded = false;
  }
}
