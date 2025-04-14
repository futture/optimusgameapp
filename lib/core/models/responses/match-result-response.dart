import 'package:projeto_game_quiz/core/models/question-stats.dart';

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