import 'package:projeto_game_quiz/core/models/responses/question_response.dart';
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
  final bool? isEvent;
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
      required this.isEvent,
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
          isEvent: json["isEvent"],
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

class MatchResultResponse {
  final List<QuestionStatsResponse> questions;
  final List<PlayerRankingResponse> generalRanking;

  MatchResultResponse({required this.generalRanking, required this.questions});

  factory MatchResultResponse.fromJson(Map<String, dynamic> json) =>
      MatchResultResponse(
          generalRanking: (json["generalRanking"] as List<dynamic>)
              .map((e) => PlayerRankingResponse.fromJson(e))
              .toList(),
          questions: (json["questions"] as List<dynamic>)
              .map((e) => QuestionStatsResponse.fromJson(e))
              .toList());
}

class PlayerRankingResponse {
  final String playerName;
  final String playerId;
  final int hits;
  final int errors;
  final double totalResponseTime;
  final int timesInTop3;
  final int points;
  final double prize;
  final bool winner;
  final int position;

  PlayerRankingResponse(
      {required this.playerName,
      required this.playerId,
      required this.hits,
      required this.errors,
      required this.totalResponseTime,
      required this.timesInTop3,
      required this.points,
      required this.prize,
      required this.winner,
      required this.position});

  factory PlayerRankingResponse.fromJson(Map<String, dynamic> json) =>
      PlayerRankingResponse(
          playerName: json["playerName"],
          playerId: json["playerId"],
          hits: json["hits"],
          errors: json["errors"],
          totalResponseTime: json["totalResponseTime"],
          timesInTop3: json["timesInTop3"],
          points: json["points"],
          prize: json["prize"],
          winner: json["winner"],
          position: json["position"]);
}

class QuestionStatsResponse {
  final String questionId;
  final List<ErrosResponse> erros;
  final List<HitsResponse> hits;

  QuestionStatsResponse(
      {required this.questionId, required this.erros, required this.hits});

  factory QuestionStatsResponse.fromJson(Map<String, dynamic> json) =>
      QuestionStatsResponse(
        questionId: json["questionId"],
        erros: (json["erros"] as List<dynamic>)
            .map((e) => ErrosResponse.fromJson(e))
            .toList(),
        hits: (json["hits"] as List<dynamic>)
            .map((e) => HitsResponse.fromJson(e))
            .toList(),
      );
}
