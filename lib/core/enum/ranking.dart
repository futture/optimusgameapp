enum RankingPeriod {
  daily,  
  weekly, 
  monthly, 
}


extension RankingPeriodExtension on RankingPeriod {
  String get value {
    switch (this) {
      case RankingPeriod.daily:
        return 'daily';
      case RankingPeriod.weekly:
        return 'weekly';
      case RankingPeriod.monthly:
        return 'monthly';
    }
  }
}
