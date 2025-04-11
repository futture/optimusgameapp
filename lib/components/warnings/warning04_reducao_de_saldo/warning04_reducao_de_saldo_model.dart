import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_web_socket_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/pages/tela06_salade_jogo/tela06_salade_jogo_widget.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'warning04_reducao_de_saldo_widget.dart'
    show Warning04ReducaoDeSaldoWidget;
import 'package:flutter/material.dart';

class Warning04ReducaoDeSaldoModel
    extends FlutterFlowModel<Warning04ReducaoDeSaldoWidget> {
  /// Serviços e variáveis
  final MatchService _matchService = MatchService();
  MatchWebSocketService? _matchWebSocketService;

  late MatchResponse matchInfo;
  late BuildContext context;
  String userId = "";
  int playersConnected = 0;
  int minPlayers = 1;
  bool isWaitingPlayers = false;

  VoidCallback? onStateUpdate;

  @override
  void initState(BuildContext context) {
    this.context = context;
  }

  @override
  void dispose() {
    _matchWebSocketService?.disconnect();
  }

  Future<void> getUserIdAsync(VoidCallback? callback) async {
    userId = await UserUtil.getUserId() ?? "";
    callback?.call();
  }

  Future<void> joinTheMatchAsync(bool? subscribe) async {
    var result = await _matchService.addPlayerMatchAsync(
      matchInfo.id,
      AddPlayerMatchRequest(
        playerId: userId,
      ),
    );

    if (result["isSuccess"] && subscribe == null) {
      await getWebSocketWaitForPlayerAsync();
      onStateUpdate?.call();
    } else {
      Warning00ErrorUtil.showDialogMessageError(context,
          result["error"].detail.message, result["error"].detail.details);
    }
  }

  Future<void> getWebSocketWaitForPlayerAsync() async {
    _matchWebSocketService = MatchWebSocketService(
      matchId: matchInfo.id,
      context: context,
      matchInfo: matchInfo,
      onMatchUpdate: (match) {
        playersConnected = match.playersConnected;
        minPlayers = match.minPlayers;
        isWaitingPlayers = true;
        onStateUpdate?.call();
      },
      onError: (error) => print("Erro no WebSocket: $error"),
      onDone: () => print("Conexão WebSocket encerrada."),
    );

    _matchWebSocketService?.connect();
  }

  Future<void> startMatchAsync() async {
    var resultStartMatch = await _matchService.startMatchAsync(matchInfo.id);

    if (resultStartMatch["isSuccess"]) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => Tela06SaladeJogoWidget(matchInfo: matchInfo),
        ),
      );
    }
  }
}
