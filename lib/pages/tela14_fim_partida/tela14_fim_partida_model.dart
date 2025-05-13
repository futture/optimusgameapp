import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'tela14_fim_partida_widget.dart' show Tela14FimPartidaViewWidget;
import 'package:flutter/material.dart';

class Tela14FimPartidaViewModel
    extends FlutterFlowModel<Tela14FimPartidaViewWidget> {
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }

  List<JogadorResultado> processarResultados(
      MatchResultResponse? gameResultInfo) {
    final resultados = gameResultInfo?.generalRanking.map((ranking) {
          return JogadorResultado(
            id: ranking.playerId,
            nome: ranking.playerName,
            pontos: ranking.points,
            premio: ranking.prize,
            perguntasCertas: ranking.hits,
            perguntasErradas: ranking.errors,
            top3vezes: ranking.timesInTop3,
            posicao: ranking.position,
            accuracyRate: ranking.accuracyRate,
            hitRateWeight: ranking.hitRateWeight,
            timeRate: ranking.timeRate,
            timeRateWeight: ranking.timeRateWeight,
            isWinner: ranking.winner == true,
          );
        }).toList() ??
        [];

    resultados.sort((a, b) => a.posicao.compareTo(b.posicao));

    final vencedores = resultados.where((r) => r.isWinner).toList();

    if (vencedores.length == 1) {
      vencedores[0].trofeu = TrofeuTipo.ouro;
    } else if (vencedores.length > 1) {
      for (int i = 0; i < vencedores.length && i < 3; i++) {
        switch (i) {
          case 0:
            vencedores[i].trofeu = TrofeuTipo.ouro;
            break;
          case 1:
            vencedores[i].trofeu = TrofeuTipo.prata;
            break;
          case 2:
            vencedores[i].trofeu = TrofeuTipo.bronze;
            break;
        }
      }
    }

    return resultados;
  }
}
