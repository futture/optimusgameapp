enum TrofeuTipo { ouro, prata, bronze, perdedor }

enum Status {
  Pendente('Pendente'),
  AguardandoInicio('Aguardando inicio');

  final String label;
  const Status(this.label);
}

class CreateRoomRequest {
  final String nameRoom;
  final bool isCustomized;
  final CreateRoomConfigurationRequest roomConfiguration;

  CreateRoomRequest(
      {required this.nameRoom,
      required this.isCustomized,
      required this.roomConfiguration});

  Map<String, dynamic> toJson() => {
        "code": "AAA",
        "name": this.nameRoom,
        "isCustomized": this.isCustomized,
        "roomConfiguration": this.roomConfiguration.toJson()
      };
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
  final List<String>? playerIds;

  AddPlayerMatchRequest({required this.playerId, this.playerIds});

  Map<String, dynamic> toJson() =>
      {"playerId": playerId, "partPlayersId": playerIds};
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

class CreateRoomConfigurationRequest {
  final bool isEvent;
  final bool isSingleWinner;
  final bool isSimpleQuestions;
  final int timeToRespond;
  final int numberOfPlayers;
  final int numberOfQuestions;
  final int numberOfAnswerOptions;
  final int minimumNumberOfPlayers;
  final double minimumAmountToPlay;
  final double premiumRate;

  CreateRoomConfigurationRequest(
      {required this.isEvent,
      required this.isSingleWinner,
      required this.timeToRespond,
      required this.numberOfPlayers,
      required this.isSimpleQuestions,
      required this.numberOfQuestions,
      required this.numberOfAnswerOptions,
      required this.minimumNumberOfPlayers,
      required this.minimumAmountToPlay,
      required this.premiumRate});

  Map<String, dynamic> toJson() => {
        "isEvent": isEvent,
        "isSingleWinner": isSingleWinner,
        "timeToRespond": timeToRespond,
        "isSimpleQuestions": isSimpleQuestions,
        "numberOfPlayers": numberOfPlayers,
        "numberOfQuestions": numberOfQuestions,
        "numberOfAnswerOptions": numberOfAnswerOptions,
        "minimumNumberOfPlayers": minimumNumberOfPlayers,
        "minimumAmountToPlay": minimumAmountToPlay,
        "premiumRate": premiumRate
      };
}

class JogadorResultado {
  final String id;
  final String nome;
  final double pontos;
  final double premio;
  final int perguntasCertas;
  final int perguntasErradas;
  final int? top3vezes;
  final int posicao;
  final bool isWinner;
  TrofeuTipo trofeu;
  final double accuracyRate;
  final double timeRate;
  final double hitRateWeight;
  final double timeRateWeight;
  final double taxAmount;

  JogadorResultado({
    required this.id,
    required this.nome,
    required this.pontos,
    required this.premio,
    required this.perguntasCertas,
    required this.perguntasErradas,
    required this.top3vezes,
    required this.posicao,
    required this.isWinner,
    required this.accuracyRate,
    required this.taxAmount,
    required this.timeRate,
    required this.hitRateWeight,
    required this.timeRateWeight,
    this.trofeu = TrofeuTipo.perdedor,
  });
}
