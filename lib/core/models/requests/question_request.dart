class PlayerAnswerRequest {
  final String matchId;
  final String questionId;
  final DateTime answeredAt;
  final String optionAnswerId;

  PlayerAnswerRequest(
      {required this.matchId,
      required this.questionId,
      required this.optionAnswerId,
      required this.answeredAt});

  Map<String, dynamic> toJson() => {
        "matchId": matchId,
        "questionId": questionId,
        "answeredAt": answeredAt.toIso8601String(),
        "optionAnswerId": optionAnswerId
      };
}
