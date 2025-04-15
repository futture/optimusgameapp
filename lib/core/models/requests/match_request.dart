enum TrofeuTipo { ouro, prata, bronze, perdedor }

class CreateRoomRequest {
  final String nameRoom;

  CreateRoomRequest({required this.nameRoom});

  Map<String, dynamic> toJson() => {"name": this.nameRoom, "code": "AAA"};
}

class CreateMatchRequest {
  final DateTime matchStartDate;
  final DateTime endDateOfMatch;

  CreateMatchRequest(
      {required this.matchStartDate, required this.endDateOfMatch});

  Map<String, dynamic> toJson() => {
        "matchStartDate": matchStartDate.toIso8601String(),
        "endDateOfMatch": endDateOfMatch.toIso8601String(),
      };
}

class AddPlayerMatchRequest {
  final String playerId;

  AddPlayerMatchRequest({required this.playerId});

  Map<String, dynamic> toJson() => {"playerId": playerId};
}

class UpdateRoomConfigurationRequest {
  final bool isSingleWinner;
  final int timeToRespond;
  final int numberOfPlayers;
  final int numberOfQuestions;
  final int numberOfAnswerOptions;
  final int minimumNumberOfPlayers;
  final double minimumAmountToPlay;
  final double premiumRate;

  UpdateRoomConfigurationRequest(
      {required this.isSingleWinner,
      required this.timeToRespond,
      required this.numberOfPlayers,
      required this.numberOfQuestions,
      required this.numberOfAnswerOptions,
      required this.minimumNumberOfPlayers,
      required this.minimumAmountToPlay,
      required this.premiumRate});

  Map<String, dynamic> toJson() => {
        "isSingleWinner": isSingleWinner,
        "timeToRespond": timeToRespond,
        "numberOfPlayers": numberOfPlayers,
        "numberOfQuestions": numberOfQuestions,
        "numberOfAnswerOptions": numberOfAnswerOptions,
        "minimumNumberOfPlayers": minimumNumberOfPlayers,
        "minimumAmountToPlay": minimumAmountToPlay,
        "premiumRate": premiumRate
      };
}

class JogadorResultado {
  final String nome;
  final int pontos;
  final double premio;
  final int perguntasCertas;
  final int perguntasErradas;
  final int? top3vezes;
  final int posicao;
  final bool isWinner;
  TrofeuTipo trofeu;

  JogadorResultado({
    required this.nome,
    required this.pontos,
    required this.premio,
    required this.perguntasCertas,
    required this.perguntasErradas,
    required this.top3vezes,
    required this.posicao,
    required this.isWinner,
    this.trofeu = TrofeuTipo.perdedor,
  });
}
