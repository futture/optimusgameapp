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
  List<Erros>? erros;
  List<Hits>? hits;

  QuestionStats({this.questionId, this.erros, this.hits});

  QuestionStats.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    if (json['erros'] != null) {
      erros = <Erros>[];
      json['erros'].forEach((v) {
        erros!.add(new Erros.fromJson(v));
      });
    }
    if (json['hits'] != null) {
      hits = <Hits>[];
      json['hits'].forEach((v) {
        hits!.add(new Hits.fromJson(v));
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

class Erros {
  String? playerId;
  double? time;
  bool? isCorrect;
  int? score;

  Erros({this.playerId, this.time, this.isCorrect, this.score});

  Erros.fromJson(Map<String, dynamic> json) {
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

class Hits {
  String? playerId;
  double? time;
  bool? isCorrect;
  int? score;

  Hits({this.playerId, this.time, this.isCorrect, this.score});

  Hits.fromJson(Map<String, dynamic> json) {
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
