import 'package:projeto_game_quiz/core/models/responses/user_response.dart';

class RoomResponse {
  final String id;
  final String nameRoom;

  RoomResponse({required this.id, required this.nameRoom});

  factory RoomResponse.fromJson(Map<String, dynamic> json) =>
      RoomResponse(id: json["id"], nameRoom: json["name"]);
}

class MatchResponse {
  final String id;
  final String statusMatch;
  final DateTime createdAt;
  final RoomResponse? room;
  final List<MatchPlayerResponse>? matchPlayers;
  final MatchConfigurationResponse? matchConfiguration;

  MatchResponse(
      {required this.id,
      required this.createdAt,
      required this.statusMatch,
      required this.room,
      required this.matchPlayers,
      required this.matchConfiguration});

  factory MatchResponse.fromJson(Map<String, dynamic> json) {
    return MatchResponse(
      id: json["id"],
      statusMatch: json["statusMatch"],
      createdAt: DateTime.parse(json["createdAt"]),
      room: RoomResponse.fromJson(json["room"]),
      matchPlayers: (json["matchPlayers"] as List<dynamic>)
          .map((e) => MatchPlayerResponse.fromJson(e))
          .toList(),
      matchConfiguration: json["matchConfiguration"] != null
          ? MatchConfigurationResponse.fromJson(json["matchConfiguration"])
          : null,
    );
  }
}

class MatchPlayerResponse {
  final bool isHost;
  final UserResponse? userResponse;

  MatchPlayerResponse({required this.isHost, required this.userResponse});

  factory MatchPlayerResponse.fromJson(Map<String, dynamic> json) =>
      MatchPlayerResponse(
          isHost: json["isHost"],
          userResponse: json["user"] != null
              ? UserResponse.FromJson(json["user"])
              : null);
}

class MatchConfigurationResponse {
  final String id;
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

  MatchConfigurationResponse(
      {required this.id,
      required this.isSingleWinner,
      required this.timeToRespond,
      required this.numberOfPlayers,
      required this.matchStartDate,
      required this.endDateOfMatch,
      required this.numberOfQuestions,
      required this.minimumAmountToPlay,
      required this.minimumNumberOfPlayers,
      required this.numberOfAnswerOptions,
      required this.premiumRate});

  factory MatchConfigurationResponse.fromJson(Map<String, dynamic> json) =>
      MatchConfigurationResponse(
          id: json["id"],
          premiumRate: json["premiumRate"],
          isSingleWinner: json["isSingleWinner"],
          timeToRespond: json["timeToRespond"],
          numberOfPlayers: json["numberOfPlayers"],
          matchStartDate: DateTime.parse(json["matchStartDate"]),
          endDateOfMatch: DateTime.parse(json["endDateOfMatch"]),
          numberOfQuestions: json["numberOfQuestions"],
          minimumAmountToPlay: json["minimumAmountToPlay"],
          minimumNumberOfPlayers: json["minimumNumberOfPlayers"],
          numberOfAnswerOptions: json["numberOfAnswerOptions"]);
}

class MatchTotalNumberPlayerResponse {
  final String matchId;
  final int playersConnected;
  final int minPlayers;
  final bool isReady;

  MatchTotalNumberPlayerResponse(
      {required this.matchId,
      required this.playersConnected,
      required this.minPlayers,
      required this.isReady});

  factory MatchTotalNumberPlayerResponse.fromJson(Map<String, dynamic> json) =>
      MatchTotalNumberPlayerResponse(
        matchId: json["matchId"],
        isReady: json["isReady"],
        minPlayers: json["minPlayers"],
        playersConnected: json["playersConnected"],
      );
}
