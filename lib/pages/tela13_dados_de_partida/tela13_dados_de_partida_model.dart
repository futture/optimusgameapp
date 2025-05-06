import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'tela13_dados_de_partida_widget.dart' show Tela13DadosDePartidaWidget;
import 'package:flutter/material.dart';

class Tela13DadosDePartidaModel
    extends FlutterFlowModel<Tela13DadosDePartidaWidget> {
  MatchResponse? matchInfo;
  bool isLoading = false;
  final matchService = MatchService();
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  Future<void> fetchMatchById(Function setState, matchId) async {
    setState(() {
      isLoading = true;
    });
    final result = await matchService.getMatchByMatchIdAsync(matchId!);
    if (result["isSuccess"] == true) {
      setState(() {
        matchInfo = result["data"];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
