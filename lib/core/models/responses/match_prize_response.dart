class MatchPrizeResponse {
  String? id;
  double? totalGain;
  double? netPremium;
  double? houseFee;
  bool? isExpanded;
  List<PlayerMatchPrizeResponse>? playerMatchPrize;

  MatchPrizeResponse(
      {this.id,
      this.totalGain,
      this.netPremium,
      this.houseFee,
      this.isExpanded,
      this.playerMatchPrize});

  MatchPrizeResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalGain = json['totalGain'];
    netPremium = json['netPremium'];
    houseFee = json['houseFee'];
    isExpanded = false;
    playerMatchPrize = (json["playerMatchPrize"] as List<dynamic>)
        .map((e) => PlayerMatchPrizeResponse.fromJson(e))
        .toList();
  }
}

class PlayerMatchPrizeResponse {
  String? playerId;
  double? netPremium;
  List<ImposedAppliedPlayerResponse>? imposedApplied;

  PlayerMatchPrizeResponse(
      {this.playerId, this.netPremium, this.imposedApplied});

  PlayerMatchPrizeResponse.fromJson(Map<String, dynamic> json) {
    playerId = json["playerId"];
    netPremium = json["netPremium"];
    imposedApplied = (json["imposedApplied"] as List<dynamic>)
        .map((e) => ImposedAppliedPlayerResponse.fromJson(e))
        .toList();
  }
}

class ImposedResponse {
  String? id;
  String? name;
  double? rate;
  String? description;

  ImposedResponse({this.id, this.name, this.rate, this.description});

  ImposedResponse.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    rate = json["rate"];
    description = json["description"];
  }
}

class ImposedAppliedPlayerResponse {
  double? taxValue;
  double? baseValue;
  ImposedResponse? imposed;

  ImposedAppliedPlayerResponse({this.taxValue, this.baseValue, this.imposed});

  ImposedAppliedPlayerResponse.fromJson(Map<String, dynamic> json) {
    taxValue = json["taxValue"] == null ? 0.0 : json["taxValue"];
    baseValue = json["baseValue"] == null ? 0.0 : json["baseValue"];
    imposed = ImposedResponse.fromJson(json["imposed"]);
  }
}
