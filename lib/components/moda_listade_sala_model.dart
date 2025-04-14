import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_web_socket_service.dart';
import 'package:projeto_game_quiz/core/api/services/room_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/pages/tela06_salade_jogo/tela06_salade_jogo_widget.dart';

import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'moda_listade_sala_widget.dart' show ModaListadeSalaWidget;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';

class ModaListadeSalaModel extends FlutterFlowModel<ModaListadeSalaWidget> {
  bool isShowWaitingDialogOpen = false;
  late BuildContext currentShowWaitingDialog;

  /// State fields
  final timerInitialTimeMs = 60000;
  int timerMilliseconds = 60000;
  String timerValue = StopWatchTimer.getDisplayTime(60000, milliSecond: false);
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  /// Serviços
  final roomService = RoomService();
  final matchService = MatchService();

  /// Variáveis de estado
  late BuildContext context;
  String userId = "";
  int minPlayers = 1;
  String matchId = "";
  MatchResponse? matchInfo;
  int playersConnected = 0;
  bool isWaitingPlayers = false;

  MatchWebSocketService? _matchWebSocketService;

  /// Callbacks externos
  VoidCallback? onWaitingPlayersCallback;

  @override
  void initState(BuildContext context) {
    this.context = context;
  }

  @override
  void dispose() {
    timerController.dispose();
    _matchWebSocketService?.disconnect();
  }

  Future<void> getUserIdAsync(VoidCallback? callback) async {
    userId = await UserUtil.getUserId() ?? "";
    callback?.call();
  }

  Future<void> createMatch(
      int numberOfPlayers, int numberOfQuestions, String nameRoom) async {
    const int timeToRespond = 10;

    try {
      final roomResult = await roomService.createRoomAsync(
        CreateRoomRequest(nameRoom: nameRoom),
      );

      if (roomResult["isSuccess"] != true) {
        await Warning00ErrorUtil.showDialogMessageError(
          context,
          roomResult["error"].detail.message,
          roomResult["error"].detail.details,
        );
        return;
      }

      final String createdRoomId = roomResult["data"]["id"];
      final matchRequest = CreateMatchRequest(
        isEvent: false,
        isSingleWinner: true,
        timeToRespond: timeToRespond,
        numberOfPlayers: numberOfPlayers,
        matchStartDate: DateTime.now(),
        endDateOfMatch: DateTime.now()
            .add(Duration(seconds: timeToRespond * numberOfQuestions)),
        numberOfQuestions: numberOfQuestions,
        numberOfAnswerOptions: 5,
        minimumNumberOfPlayers: numberOfPlayers,
        minimumAmountToPlay: 500,
        premiumRate: 0.75,
      );

      final matchResult =
          await matchService.createMatchAsync(createdRoomId, matchRequest);

      if (matchResult["isSuccess"] != true) {
        await Warning00ErrorUtil.showDialogMessageError(
          context,
          matchResult["error"].detail.message,
          matchResult["error"].detail.details,
        );
        return;
      }

      matchId = matchResult["data"]["id"];

      final playerResult = await matchService.addPlayerMatchAsync(
        matchId,
        AddPlayerMatchRequest(playerId: userId),
      );

      if (playerResult["isSuccess"] != true) {
        await Warning00ErrorUtil.showDialogMessageError(
          context,
          playerResult["error"].detail.message,
          playerResult["error"].detail.details,
        );
        return;
      }

      await getMatchByMatchIdAsyncdd(matchId);
      await getWebSocketWaitForPlayerAsync();
    } catch (e) {
      print("Erro inesperado ao criar partida: $e");
    }
  }

  Future<void> getMatchByMatchIdAsync() async {
    final resultMatch = await matchService.getMatchByMatchIdAsync(matchId);
    if (resultMatch["isSuccess"]) {
      matchInfo = resultMatch["data"];
    }
  }

  Future<void> getMatchByMatchIdAsyncdd(matchId) async {
    final resultMatch = await matchService.getMatchByMatchIdAsync(matchId);
    if (resultMatch["isSuccess"]) {
      matchInfo = resultMatch["data"];
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (_) => Tela06SaladeJogoWidget(
      //       matchInfo: matchInfo,
      //       recebeuNotificaca: false,
      //     ),
      //   ),
      // );
    }
  }

  Future<void> getWebSocketWaitForPlayerAsync() async {
    _matchWebSocketService = MatchWebSocketService(
      matchId: matchId,
      context: context,
      matchInfo: matchInfo!,
      onOther: () {
        if (!isWaitingPlayers) return;

        isWaitingPlayers = false;

        if (isShowWaitingDialogOpen && Navigator.of(context).canPop()) {
          Navigator.of(currentShowWaitingDialog).pop();
          isShowWaitingDialogOpen = false;
        }

        _matchWebSocketService?.disconnect();

        onWaitingPlayersCallback?.call();

        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => Tela06SaladeJogoWidget(
                matchInfo: matchInfo,
                recebeuNotificaca: false,
              ),
            ),
          );
        }
      },
      onMatchUpdate: (match) {
        playersConnected = match.playersConnected;
        minPlayers = match.minPlayers;
        isWaitingPlayers = true;
        showWaitingDialog();
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
              "Esperando participantes conectarem, Participante conectados: $playersConnected / $minPlayers",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _matchWebSocketService?.disconnect();
              isShowWaitingDialogOpen = false;
            },
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }
}
