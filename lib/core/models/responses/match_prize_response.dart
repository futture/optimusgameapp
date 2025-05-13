class MatchPrizeResponse {
  String? id;
  double? totalGain;
  double? netPremium;
  double? houseFee;
  bool? isExpanded;

  MatchPrizeResponse(
      {this.id,
      this.totalGain,
      this.netPremium,
      this.houseFee,
      this.isExpanded});

  MatchPrizeResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalGain = json['totalGain'];
    netPremium = json['netPremium'];
    houseFee = json['houseFee'];
    isExpanded = false;
  }
}
