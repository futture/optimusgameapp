class UserRankingMetricsResponse {
  final String userId;
  final double totalScore;
  final String totalScoreFormatted;
  final int totalWins;
  final double winRate;

  UserRankingMetricsResponse({
    required this.userId,
    required this.totalScore,
    required this.totalScoreFormatted,
    required this.totalWins,
    required this.winRate,
  });

  factory UserRankingMetricsResponse.fromJson(Map<String, dynamic> json) {
    return UserRankingMetricsResponse(
      userId: json['userId'],
      totalScore: (json['totalScore'] as num).toDouble(),
      totalScoreFormatted: json['totalScoreFormatted'],
      totalWins: json['totalWins'],
      winRate: (json['winRate'] as num).toDouble(),
    );
  }

  factory UserRankingMetricsResponse.empty() {
    return UserRankingMetricsResponse(
      userId: '',
      totalScore: 0,
      totalScoreFormatted: '0',
      totalWins: 0,
      winRate: 0,
    );
  }
}
