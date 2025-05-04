import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/ranking_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/responses/player_answers_response.dart';
import 'package:projeto_game_quiz/core/models/responses/ranking_response.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'tela09_historico_jodos_widget.dart' show Tela09HistoricoJodosWidget;
import 'package:flutter/material.dart';

class Tela09HistoricoJodosModel
    extends FlutterFlowModel<Tela09HistoricoJodosWidget> {
  String? userId = "";
  List<RankingResponse>? rankings;
  List<PlayerAnswersResponse>? historys;
  RankingService _rankingService = RankingService();
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  Future<void> getUserIdAsync() async {
    userId = await UserUtil.getUserId();
  }

  Future<void> load(Function setState) async {
    await getUserIdAsync();
    await getRankingByUserdAsync(setState);
  }

  Future<void> getRankingByUserdAsync(Function setState) async {
    var result = await _rankingService.getRankingByUserdAsync(userId!);

    if (result["isSuccess"]) {
      setState(() {
        rankings = result["data"];
      });
    } else {
      Warning00ErrorUtil.showDialogMessageError(
        context!,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }

  Future<void> getHistoryUserdAsync(Function setState, matchId) async {
    var result = await _rankingService.getHistoryUserdAsync(userId!, matchId);

    if (result["isSuccess"]) {
      setState(() {
        historys = result["data"];
      });
    } else {
      Warning00ErrorUtil.showDialogMessageError(
        context!,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }
}
