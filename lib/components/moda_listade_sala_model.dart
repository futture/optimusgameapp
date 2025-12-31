import 'dart:async';

import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_web_socket_service.dart';
import 'package:projeto_game_quiz/core/api/services/room_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/dialogs/common_dialog_widget.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_widgets.dart';
import 'package:projeto_game_quiz/pages/tela06_salade_jogo/tela06_salade_jogo_widget.dart';

import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'moda_listade_sala_widget.dart' show ModaListadeSalaWidget;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';

class ModaListadeSalaModel extends FlutterFlowModel<ModaListadeSalaWidget> {
  bool isShowWaitingDialogOpen = false;
  late BuildContext currentShowWaitingDialog;
  Timer? startTimeoutTimer;
  bool isLoadingRooms = false;
  final Duration timeoutDuration = Duration(seconds: 20);

  /// State fields
  final timerInitialTimeMs = 60000;
  int timerMilliseconds = 60000;
  String timerValue = StopWatchTimer.getDisplayTime(60000, milliSecond: false);
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  /// Serviços
  final roomService = RoomService();
  final matchService = MatchService();
  UserResponse? currentUser;

  /// Variáveis de estado
  late BuildContext context;
  String userId = "";
  int minPlayers = 1;
  int numberOfPlayers = 1;
  String matchId = "";
  MatchResponse? matchInfo;
  int playersConnected = 0;
  bool isWaitingPlayers = false;
  List<RoomResponse> rooms = List.empty();
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
    startTimeoutTimer?.cancel();
    _matchWebSocketService?.disconnect();
  }

  Future<void> getUserIdAsync(VoidCallback? callback) async {
    userId = await UserUtil.getUserId() ?? "";
    currentUser = await UserUtil.getUserInfo();
    callback?.call();
  }

  Future<void> getRoomAsync(void Function(VoidCallback) setState) async {
    setState(() {
      isLoadingRooms = true;
    });
    final resultRoom = await roomService.getAllRoomAsync(
        roomTypes: [RoomType.NORMAL.label, RoomType.FREE.label]);

    if (resultRoom["isSuccess"] == true) {
      final fetchedRooms = resultRoom["data"];
      setState(() {
        rooms = fetchedRooms;
        isLoadingRooms = false;
      });
    } else {
      final error = resultRoom["error"].detail;
      await Warning00ErrorUtil.showDialogMessageError(
        context,
        error.message,
        error.details,
      );
    }
  }

  Future<void> createMatch(int numberOfPlayers, int numberOfQuestions,
      int timeToRespond, String roomId) async {
    try {
      final matchRequest = CreateMatchRequest(
          matchStartDate: DateTime.now(),
          endDateOfMatch: DateTime.now()
              .add(Duration(seconds: timeToRespond * numberOfQuestions)));

      final matchResult =
          await matchService.createMatchAsync(roomId, matchRequest);

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

      await getMatchByMatchIdAsync();
      bool isFree = matchInfo!.room!.roomType == RoomType.FREE.label;
      if (isFree) {
        showMatchParticipantsDialog(isFree: isFree);
      }
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

  Future<void> getWebSocketWaitForPlayerAsync() async {
    _matchWebSocketService = MatchWebSocketService(
      matchId: matchId,
      userId: userId,
      context: context,
      matchInfo: matchInfo!,
      onOther: (match) {
        if (!isWaitingPlayers) return;

        isWaitingPlayers = false;

        if (isShowWaitingDialogOpen && Navigator.of(context).canPop()) {
          Navigator.of(currentShowWaitingDialog).pop();
          isShowWaitingDialogOpen = false;
        }

        //_matchWebSocketService?.disconnect();

        onWaitingPlayersCallback?.call();

        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => Tela06SaladeJogoWidget(
                matchInfo: matchInfo,
                recebeuNotificaca: false,
                nextQuestion: match.nextQuestion,
              ),
            ),
          );
        }
      },
      onMatchUpdate: (match) {
        playersConnected = match.playersConnected;
        minPlayers = match.minPlayers;
        numberOfPlayers = match.numberOfPlayers;
        isWaitingPlayers = true;
        showMatchParticipantsDialog();
      },
      onError: (error) => print("Erro no WebSocket: $error"),
      onDone: () => print("Conexão WebSocket encerrada."),
    );

    _matchWebSocketService?.connect();
  }

  Future<void> leaveTheMatchAsync(context) async {
    var result = await matchService.leaveTheMatchAsync(matchId, userId);
    if (result["isSuccess"]) {
      _matchWebSocketService?.disconnect();
    } else {
      await Warning00ErrorUtil.showDialogMessageError(
        context,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }

  // void showWaitingDialog() {
  //   if (isShowWaitingDialogOpen) return;

  //   isShowWaitingDialogOpen = true;
  //   currentShowWaitingDialog = context;

  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => AlertDialog(
  //       title: const Text("Aguardando jogadores..."),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           CircularProgressIndicator(),
  //           SizedBox(height: 16),
  //           Text(
  //             "Esperando participantes conectarem, Participante conectados: $playersConnected / $numberOfPlayers",
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () async {
  //             await leaveTheMatchAsync(context);
  //             _matchWebSocketService?.disconnect();
  //             isShowWaitingDialogOpen = false;
  //           },
  //           child: const Text("Fechar"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void showMatchParticipantsDialog({bool isFree = false}) {
    if (isShowWaitingDialogOpen) return;

    isShowWaitingDialogOpen = true;
    currentShowWaitingDialog = context;
    List<UserResponse> participants = [currentUser!];

    final minimumAmount =
        matchInfo!.room?.roomConfiguration?.minimumAmountToPlay ?? 0;
    var infos = [
      {
        'title': 'Inscrição',
        'icon': Icons.attach_money,
        'value': '${minimumAmount}KZ',
      },
      {
        'title': 'Prêmio',
        'icon': Icons.wine_bar_rounded,
        'value': '${matchInfo!.matchPrize?.totalGain ?? 0} KZ',
      },
      {
        'title': 'Nº Questões',
        'icon': Icons.numbers,
        'value': '${matchInfo!.room!.roomConfiguration!.numberOfQuestions}',
      },
      {
        'title': 'Vagas',
        'icon': Icons.people,
        'value':
            '${matchInfo!.matchPlayers?.length ?? 0}/${matchInfo!.room?.roomConfiguration?.numberOfPlayers ?? 0}',
      },
    ];
    CommonDialogWidget.showMatchParticipantsDialog(
        context,
        infos,
        "Desafio",
        matchInfo!,
        participants,
        currentUser,
        _buildDialogActions(isFree: isFree),
        timeCloseDialog: 3600,
        isPlaySound: false,
        isProgressBar: false, onClose: () async {
      await leaveTheMatchAsync(context);
      _matchWebSocketService?.disconnect();
      isShowWaitingDialogOpen = false;
    });
  }

  Widget _buildDialogActions({bool isFree = false}) {
    return Column(
      children: [
        if (isWaitingPlayers) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFFEC8D0D),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aguardando participantes...',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: const Color(0xFFEC8D0D),
                        fontSize: 14,
                        letterSpacing: 0,
                      ),
                ),
                Text(
                  'Participantes conectados: $playersConnected/$numberOfPlayers',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Inter',
                        letterSpacing: 0,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (isFree) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFFEC8D0D),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aguarde...',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: const Color(0xFFEC8D0D),
                        fontSize: 14,
                        letterSpacing: 0,
                      ),
                ),
                Text(
                  'Preparando a partida: $playersConnected/$numberOfPlayers',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Inter',
                        letterSpacing: 0,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FFButtonWidget(
              onPressed: () async {
                Navigator.of(currentShowWaitingDialog).pop();
                await leaveTheMatchAsync(context);
                _matchWebSocketService?.disconnect();
                isShowWaitingDialogOpen = false;
              },
              text: 'Cancelar',
              options: FFButtonOptions(
                height: 40,
                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                color: FlutterFlowTheme.of(context).error,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                elevation: 3,
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
