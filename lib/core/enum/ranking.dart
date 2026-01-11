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

enum RankingResultTypeEnum {
  VITORIA,
  DERROTA,
}

enum RankingPeriodEnum {
  TODAY('daily'),
  WEEKLY('weekly'),
  MONTHLY('monthly'),
  DATE('date'),
  ALL_TIME('all_time');

  final String value;
  const RankingPeriodEnum(this.value);
}