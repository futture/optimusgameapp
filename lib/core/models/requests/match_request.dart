class CreateRoomRequest {
  final String nameRoom;

  CreateRoomRequest({required this.nameRoom});

  Map<String, dynamic> toJson() => {"name": this.nameRoom, "code": "AAA"};
}

class CreateMatchRequest {
  final bool isEvent;
  final bool isSingleWinner;
  final int timeToRespond;
  final int numberOfPlayers;
  final DateTime matchStartDate;
  final DateTime endDateOfMatch;
  final int numberOfQuestions;
  final int numberOfAnswerOptions;
  final int minimumNumberOfPlayers;
  final double minimumAmountToPlay;
  final double premiumRate;

  CreateMatchRequest(
      {required this.isEvent,
      required this.isSingleWinner,
      required this.timeToRespond,
      required this.numberOfPlayers,
      required this.matchStartDate,
      required this.endDateOfMatch,
      required this.numberOfQuestions,
      required this.numberOfAnswerOptions,
      required this.minimumNumberOfPlayers,
      required this.minimumAmountToPlay,
      required this.premiumRate});

  Map<String, dynamic> toJson() => {
        "isEvent": isEvent,
        "isSingleWinner": isSingleWinner,
        "timeToRespond": timeToRespond,
        "numberOfPlayers": numberOfPlayers,
        "matchStartDate": matchStartDate.toIso8601String(),
        "endDateOfMatch": endDateOfMatch.toIso8601String(),
        "numberOfQuestions": numberOfQuestions,
        "numberOfAnswerOptions": numberOfAnswerOptions,
        "minimumNumberOfPlayers": minimumNumberOfPlayers,
        "minimumAmountToPlay": minimumAmountToPlay,
        "premiumRate": premiumRate
      };
}

class AddPlayerMatchRequest {
  final String playerId;

  AddPlayerMatchRequest({required this.playerId});

  Map<String, dynamic> toJson() => {"playerId": playerId};
}
