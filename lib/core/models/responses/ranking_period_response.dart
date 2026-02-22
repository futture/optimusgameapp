//ranking_period_response.dart

import 'package:projeto_game_quiz/core/enum/ranking.dart';

class RankingDetailResponse {
  final String id;
  final RankingResultTypeEnum result_type;
  final double cash_amount;
  final String score_display;
  final String color;
  final bool is_winner;
  final String? match_id;
  final String? match_prize_id;
  final double entry_fee;
  final double prize_amount;
  final bool has_player_prize;
  
  // Campos do ranking (já existentes no backend)
  final double? total_score;
  final int? correct_answers;
  final int? wrong_answers;
  final double? total_response_time;
  final double? average_response_time;
  
  // NOVOS CAMPOS DA MATCH
  final DateTime? match_start_date;
  final DateTime? match_end_date;
  final String? match_status;
  
  final DateTime? created_at;
  final DateTime? updated_at;

  RankingDetailResponse({
    required this.id,
    required this.result_type,
    required this.cash_amount,
    required this.score_display,
    required this.color,
    required this.is_winner,
    required this.match_id,
    required this.match_prize_id,
    required this.entry_fee,
    required this.prize_amount,
    required this.has_player_prize,
    
    // Campos do ranking
    this.total_score,
    this.correct_answers,
    this.wrong_answers,
    this.total_response_time,
    this.average_response_time,
    
    // Novos campos da match
    this.match_start_date,
    this.match_end_date,
    this.match_status,
    
    this.created_at,
    this.updated_at,
  });

  factory RankingDetailResponse.fromJson(Map<String, dynamic> json) {
    return RankingDetailResponse(
      id: json['id'] ?? '',
      result_type: _parseResultType(json['result_type']),
      cash_amount: (json['cash_amount'] as num?)?.toDouble() ?? 0.0,
      score_display: json['score_display'] ?? '',
      color: json['color'] ?? '',
      is_winner: json['is_winner'] ?? false,
      match_id: json['match_id'],
      match_prize_id: json['match_prize_id'],
      entry_fee: (json['entry_fee'] as num?)?.toDouble() ?? 0.0,
      prize_amount: (json['prize_amount'] as num?)?.toDouble() ?? 0.0,
      has_player_prize: json['has_player_prize'] ?? false,
      
      // Campos do ranking (pode ser null se não vier do backend)
      total_score: (json['total_score'] as num?)?.toDouble(),
      correct_answers: (json['correct_answers'] as num?)?.toInt(),
      wrong_answers: (json['wrong_answers'] as num?)?.toInt(),
      total_response_time: (json['total_response_time'] as num?)?.toDouble(),
      average_response_time: (json['average_response_time'] as num?)?.toDouble(),
      
      // Novos campos da match
      match_start_date: json['match_start_date'] != null 
          ? DateTime.parse(json['match_start_date']) 
          : null,
      match_end_date: json['match_end_date'] != null 
          ? DateTime.parse(json['match_end_date']) 
          : null,
      match_status: json['match_status'],
      
      created_at: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updated_at: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  static RankingResultTypeEnum _parseResultType(dynamic value) {
    if (value == null) return RankingResultTypeEnum.DERROTA;
    
    final String valueStr = value.toString().toUpperCase().trim();
    
    // Corrige para aceitar "VITÓRIA" ou "VITORIA"
    if (valueStr == 'VITÓRIA' || valueStr == 'VITORIA') {
      return RankingResultTypeEnum.VITORIA;
    } else if (valueStr == 'DERROTA') {
      return RankingResultTypeEnum.DERROTA;
    }
    
    return RankingResultTypeEnum.DERROTA;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'result_type': result_type == RankingResultTypeEnum.VITORIA ? 'VITÓRIA' : 'DERROTA',
      'cash_amount': cash_amount,
      'score_display': score_display,
      'color': color,
      'is_winner': is_winner,
      'match_id': match_id,
      'match_prize_id': match_prize_id,
      'entry_fee': entry_fee,
      'prize_amount': prize_amount,
      'has_player_prize': has_player_prize,
      'total_score': total_score,
      'correct_answers': correct_answers,
      'wrong_answers': wrong_answers,
      'total_response_time': total_response_time,
      'average_response_time': average_response_time,
      'match_start_date': match_start_date?.toIso8601String(),
      'match_end_date': match_end_date?.toIso8601String(),
      'match_status': match_status,
      'created_at': created_at?.toIso8601String(),
      'updated_at': updated_at?.toIso8601String(),
    };
  }
}