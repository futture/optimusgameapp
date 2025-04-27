import 'package:projeto_game_quiz/core/models/responses/match_response.dart';

class QuestionResponse {
  final String id;
  final String utterance;
  //final DateTime createdAt;
  final List<OptionAnswersResponse>? optionAnswers;

  QuestionResponse(
      {required this.id,
      required this.utterance,
      //required this.createdAt,
      required this.optionAnswers});

  factory QuestionResponse.fromJson(Map<String, dynamic> json) =>
      QuestionResponse(
          id: json["id"],
          utterance: json["utterance"],
          //createdAt: DateTime.parse(json["createdAt"]),
          optionAnswers: (json["optionAnswers"] as List<dynamic>)
              .map((e) => OptionAnswersResponse.fromJson(e))
              .toList());
}

class OptionAnswersResponse {
  final String id;
  final String codeOption;
  final String textOption;
  //final DateTime createdAt;

  OptionAnswersResponse({
    required this.id,
    required this.textOption,
    required this.codeOption,
    //required this.createdAt
  });

  factory OptionAnswersResponse.fromJson(Map<String, dynamic> json) =>
      OptionAnswersResponse(
        id: json["id"],
        textOption: json["textOption"],
        codeOption: json["codeOption"],
        //createdAt: DateTime.parse(json["createdAt"])
      );
}

class QuestionStats {
  bool? isReady;
  String? questionId;
  bool? gameFinished;
  int? totalQuestionsResponded;
  int? totalMatchQuestions;
  QuestionResponse? nextQuestion;
  List<ErrosResponse>? erros;
  List<HitsResponse>? hits;
  dynamic gameResult;

  QuestionStats(
      {this.questionId,
      this.erros,
      this.hits,
      this.nextQuestion,
      this.gameFinished,
      this.totalMatchQuestions,
      this.totalQuestionsResponded,
      this.gameResult});

  QuestionStats.fromJson(Map<String, dynamic> json) {
    isReady = json['isReady'];
     if (json["gameResult"] != null) {
      gameResult = MatchResultResponse.fromJson(json["gameResult"]);
    }
    gameFinished = json['gameFinished'];
    totalMatchQuestions = json['totalMatchQuestions'];
    totalQuestionsResponded = json['totalQuestionsResponded'];
    questionId = json['questionId'];
    if (json["nextQuestion"] != null) {
      nextQuestion = QuestionResponse.fromJson(json["nextQuestion"]);
    }
    if (json['erros'] != null) {
      erros = <ErrosResponse>[];
      json['erros'].forEach((v) {
        erros!.add(new ErrosResponse.fromJson(v));
      });
    }
    if (json['hits'] != null) {
      hits = <HitsResponse>[];
      json['hits'].forEach((v) {
        hits!.add(new HitsResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
    if (this.erros != null) {
      data['erros'] = this.erros!.map((v) => v.toJson()).toList();
    }
    if (this.hits != null) {
      data['hits'] = this.hits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ErrosResponse {
  String? playerId;
  int? time;
  bool? isCorrect;
  double? score;

  ErrosResponse({this.playerId, this.time, this.isCorrect, this.score});

  ErrosResponse.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'];
    time = json['time'];
    isCorrect = json['isCorrect'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playerId'] = this.playerId;
    data['time'] = this.time;
    data['isCorrect'] = this.isCorrect;
    data['score'] = this.score;
    return data;
  }
}

class HitsResponse {
  String? playerId;
  int? time;
  bool? isCorrect;
  double? score;

  HitsResponse({this.playerId, this.time, this.isCorrect, this.score});

  HitsResponse.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'];
    time = json['time'];
    isCorrect = json['isCorrect'];
    score =  json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playerId'] = this.playerId;
    data['time'] = this.time;
    data['isCorrect'] = this.isCorrect;
    data['score'] = this.score;
    return data;
  }
}
