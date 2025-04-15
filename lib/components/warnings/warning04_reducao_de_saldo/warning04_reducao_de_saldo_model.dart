import 'dart:async';

import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_web_socket_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/index.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'warning04_reducao_de_saldo_widget.dart'
    show Warning04ReducaoDeSaldoWidget;
import 'package:flutter/material.dart';

class Warning04ReducaoDeSaldoModel
    extends FlutterFlowModel<Warning04ReducaoDeSaldoWidget> {
  Timer? startTimeoutTimer;
  final Duration timeoutDuration = Duration(seconds: 20);
  bool isShowWaitingDialogOpen = false;
  late BuildContext currentShowWaitingDialog;
  final MatchService _matchService = MatchService();
  MatchWebSocketService? _matchWebSocketService;

  late MatchResponse matchInfo;
  late BuildContext context;
  String userId = "";
  int playersConnected = 0;
  int minPlayers = 1;
  int numberOfPlayers = 1;
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

  Future<void> joinTheMatchAsync(
      bool? subscribe, bool? recebeuNotificaca) async {
    var result = await _matchService.addPlayerMatchAsync(
      matchInfo.id,
      AddPlayerMatchRequest(
        playerId: userId,
      ),
    );

    if (result["isSuccess"] && subscribe == null) {
      await getWebSocketWaitForPlayerAsync(recebeuNotificaca);
      onStateUpdate?.call();
    } else {
      if (result.containsKey("error")) {
        Warning00ErrorUtil.showDialogMessageError(context,
            result["error"].detail.message, result["error"].detail.details);
      } else {}
    }
  }

  Future<void> getWebSocketWaitForPlayerAsync(bool? recebeuNotificaca) async {
    _matchWebSocketService = MatchWebSocketService(
      userId: userId,
      matchId: matchInfo.id,
      context: context,
      matchInfo: matchInfo,
      onOther: () {
        if (!isWaitingPlayers) return;

        isWaitingPlayers = false;

        if (isShowWaitingDialogOpen && Navigator.of(context).canPop()) {
          Navigator.of(currentShowWaitingDialog).pop();
          isShowWaitingDialogOpen = false;
        }

        _matchWebSocketService?.disconnect();

        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => Tela06SaladeJogoWidget(
                matchInfo: matchInfo,
                
                recebeuNotificaca: recebeuNotificaca,
              ),
            ),
          );
        }
      },
      onMatchUpdate: (match) {
        showWaitingDialog();
        playersConnected = match.playersConnected;
        minPlayers = match.minPlayers;
        numberOfPlayers = match.numberOfPlayers;
        isWaitingPlayers = true;
        onStateUpdate?.call();

        startTimeoutTimer ??= Timer(timeoutDuration, () async {
          if (playersConnected >= minPlayers) {
            await _matchWebSocketService?.startMatchAsync();

            isWaitingPlayers = false;

            if (isShowWaitingDialogOpen && Navigator.of(context).canPop()) {
              Navigator.of(currentShowWaitingDialog).pop();
              isShowWaitingDialogOpen = false;
            }

            _matchWebSocketService?.disconnect();

            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => Tela06SaladeJogoWidget(
                    matchInfo: matchInfo,
                    recebeuNotificaca: recebeuNotificaca,
                    playersConnected: playersConnected,
                  ),
                ),
              );
            }
          }
          startTimeoutTimer = null;
        });
      },
      onError: (error) => print("Erro no WebSocket: $error"),
      onDone: () => print("Conexão WebSocket encerrada."),
    );

    _matchWebSocketService?.connect();
  }

  void showWaitingDialog() {
    if (isShowWaitingDialogOpen) return;

    isShowWaitingDialogOpen = true;
    currentShowWaitingDialog = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Aguardando jogadores..."),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Esperando participantes conectarem, Participante conectados: $playersConnected / $numberOfPlayers",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await leaveTheMatchAsync(context);
              _matchWebSocketService?.disconnect();
              isShowWaitingDialogOpen = false;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => Tela03PrincipalWidget(),
                ),
              );
            },
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  Future<void> leaveTheMatchAsync(context) async {
    var result = await _matchService.leaveTheMatchAsync(matchInfo.id, userId);
    if (result["isSuccess"]) {
      Navigator.of(context).pop();
      _matchWebSocketService?.disconnect();
    } else {
      await Warning00ErrorUtil.showDialogMessageError(
        context,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }
}
