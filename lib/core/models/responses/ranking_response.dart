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
