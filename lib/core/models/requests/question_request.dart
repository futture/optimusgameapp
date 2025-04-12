class PlayerAnswerRequest {
  final String matchId;
  final String questionId;
  final int responseTimeInSecond;
  final String optionAnswerId;

  PlayerAnswerRequest(
      {required this.matchId,
      required this.questionId,
      required this.optionAnswerId,
      required this.responseTimeInSecond});

  Map<String, dynamic> toJson() => {
        "matchId": matchId,
        "questionId": questionId,
        "responseTimeInSecond": responseTimeInSecond,
        "optionAnswerId": optionAnswerId
      };
}
