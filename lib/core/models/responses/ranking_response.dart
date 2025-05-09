class RankingResponse {
  String? id;
  double? totalScore;
  DateTime? createdAt;
  int? totalCorrectAnswer;
  int? totalWrongAnswer;
  int? totalResponseTime;
  bool? isWinner;
  String? matchId;
  bool? isExpanded;
  bool? isCompleted;

  RankingResponse(
      {this.id,
      this.totalScore,
      this.createdAt,
      this.totalCorrectAnswer,
      this.totalWrongAnswer,
      this.totalResponseTime,
      this.isWinner,
      this.matchId,
      this.isExpanded});

  RankingResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalScore = json['totalScore'];
    createdAt = DateTime.parse(json['createdAt']);
    totalCorrectAnswer = json['totalCorrectAnswer'];
    totalWrongAnswer = json['totalWrongAnswer'];
    totalResponseTime = json['totalResponseTime'];
    isWinner = json['isWinner'];
    matchId = json['matchId'];
    isExpanded = false;
    isCompleted = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['totalScore'] = this.totalScore;
    data['createdAt'] = this.createdAt!.toIso8601String();
    data['totalCorrectAnswer'] = this.totalCorrectAnswer;
    data['totalWrongAnswer'] = this.totalWrongAnswer;
    data['totalResponseTime'] = this.totalResponseTime;
    data['isWinner'] = this.isWinner;
    data['matchId'] = this.matchId;
    return data;
  }
}

class RankingUser {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String phoneNumberMask;

  RankingUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.phoneNumberMask,
  });

  factory RankingUser.fromJson(Map<String, dynamic> json) {
    return RankingUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      phoneNumberMask: json['phone_number_mask'],
    );
  }
}

class RankingItem {
  final String id;
  final double totalScore;
  final String createdAt;
  final int totalCorrectAnswer;
  final int totalWrongAnswer;
  final int totalResponseTime;
  final bool isWinner;
  final String matchId;
  final int position;
  final RankingUser user;

  RankingItem({
    required this.id,
    required this.totalScore,
    required this.createdAt,
    required this.totalCorrectAnswer,
    required this.totalWrongAnswer,
    required this.totalResponseTime,
    required this.isWinner,
    required this.matchId,
    required this.position,
    required this.user,
  });

  factory RankingItem.fromJson(Map<String, dynamic> json) {
    return RankingItem(
      id: json['id'],
      totalScore: json['totalScore'],
      createdAt: json['createdAt'],
      totalCorrectAnswer: json['totalCorrectAnswer'],
      totalWrongAnswer: json['totalWrongAnswer'],
      totalResponseTime: json['totalResponseTime'],
      isWinner: json['isWinner'],
      matchId: json['matchId'],
      position: json['position'],
      user: RankingUser.fromJson(json['user']),
    );
  }
}

class RankingWithTopWinnersResponse {
  final List<RankingItem> top3;
  final List<RankingItem> allRankings;

  RankingWithTopWinnersResponse(
      {required this.top3, required this.allRankings});

  factory RankingWithTopWinnersResponse.fromJson(Map<String, dynamic> json) {
    return RankingWithTopWinnersResponse(
      top3: (json['top_3'] as List)
          .map((item) => RankingItem.fromJson(item))
          .toList(),
      allRankings: (json['all_rankings'] as List)
          .map((item) => RankingItem.fromJson(item))
          .toList(),
    );
  }
}
