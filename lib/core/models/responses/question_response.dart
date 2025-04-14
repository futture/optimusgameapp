class QuestionResponse {
  final String id;
  final String utterance;
  final DateTime createdAt;
  final List<OptionAnswersResponse>? optionAnswers;

  QuestionResponse(
      {required this.id,
      required this.utterance,
      required this.createdAt,
      required this.optionAnswers});

  factory QuestionResponse.fromJson(Map<String, dynamic> json) =>
      QuestionResponse(
          id: json["id"],
          utterance: json["utterance"],
          createdAt: DateTime.parse(json["createdAt"]),
          optionAnswers: (json["optionAnswers"] as List<dynamic>)
              .map((e) => OptionAnswersResponse.fromJson(e))
              .toList());
}

class OptionAnswersResponse {
  final String id;
  final String codeOption;
  final String textOption;
  final DateTime createdAt;

  OptionAnswersResponse(
      {required this.id,
      required this.textOption,
      required this.codeOption,
      required this.createdAt});

  factory OptionAnswersResponse.fromJson(Map<String, dynamic> json) =>
      OptionAnswersResponse(
          id: json["id"],
          textOption: json["textOption"],
          codeOption: json["codeOption"],
          createdAt: DateTime.parse(json["createdAt"]));
}

class QuestionStats {
  String? questionId;
  List<ErrosResponse>? erros;
  List<HitsResponse>? hits;

  QuestionStats({this.questionId, this.erros, this.hits});

  QuestionStats.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
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
  int? score;

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
  int? score;

  HitsResponse({this.playerId, this.time, this.isCorrect, this.score});

  HitsResponse.fromJson(Map<String, dynamic> json) {
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
