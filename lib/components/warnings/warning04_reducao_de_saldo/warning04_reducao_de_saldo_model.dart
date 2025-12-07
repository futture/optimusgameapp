import 'dart:async';

import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_web_socket_service.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/handlers/notification_handler.dart';
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
  late UserService userService = UserService();
  late MatchResponse matchInfo;
  late BuildContext context;
  String userId = "";
  int playersConnected = 0;
  int minPlayers = 0;
  int numberOfPlayers = 0;
  bool isWaitingPlayers = false;
  VoidCallback? onStateUpdate;
  UserResponse? currentUser;
  List<UserResponse> participants = List.empty();
  final NotificationHandler _notificationHandler = NotificationHandler();

  @override
  void initState(BuildContext context) {
    this.context = context;
  }

  @override
  void dispose() {
    startTimeoutTimer?.cancel();
    _matchWebSocketService?.disconnect();
  }

  Future<void> getUserIdAsync(VoidCallback? callback, Function setState) async {
    userId = await UserUtil.getUserId() ?? "";
    currentUser = await UserUtil.getUserInfo();
    await getUsersByMatchId(setState, matchInfo.id);
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
    } else if (result["isSuccess"] && subscribe == true) {
      await _notificationHandler.subscribeToMatchTopic(
          "START_MATCH", matchInfo.id);
    } else {
      if (result.containsKey("error")) {
        await Warning00ErrorUtil.showDialogMessageError(context,
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
      onOther: (match) {
        if (!isWaitingPlayers) return;

        isWaitingPlayers = false;

        if (isShowWaitingDialogOpen && Navigator.of(context).canPop()) {
          Navigator.of(currentShowWaitingDialog).pop();
          isShowWaitingDialogOpen = false;
        }

        //_matchWebSocketService?.disconnect();

        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => Tela06SaladeJogoWidget(
                  matchInfo: matchInfo,
                  recebeuNotificaca: recebeuNotificaca,
                  nextQuestion: match.nextQuestion),
            ),
          );
        }
      },
      onMatchUpdate: (match) {
        isWaitingPlayers = true;
        playersConnected = match.playersConnected;
        minPlayers = match.minPlayers;
        numberOfPlayers = match.numberOfPlayers;
        showWaitingDialog();
        onStateUpdate?.call();
      },
      onError: (error) => print("Erro no WebSocket: $error"),
      onDone: () => print("Conexão WebSocket encerrada."),
    );

    _matchWebSocketService?.connect();
  }

  // void showWaitingDialog() {
  //   if (isShowWaitingDialogOpen || !context.mounted) return;

  //   isShowWaitingDialogOpen = true;

  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext dialogContext) {
  //       currentShowWaitingDialog = dialogContext;

  //       return StatefulBuilder(
  //         builder: (context, setStateDialog) {
  //           _matchWebSocketService?.onPlayersUpdate = (match) {
  //             setStateDialog(() {
  //               playersConnected = match.playersConnected;
  //               numberOfPlayers = match.numberOfPlayers;
  //             });
  //           };

  //           return AlertDialog(
  //             title: const Text("Aguardando jogadores..."),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 const CircularProgressIndicator(),
  //                 const SizedBox(height: 16),
  //                 Text(
  //                   "Esperando participantes conectarem",
  //                 ),
  //               ],
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () async {
  //                   await leaveTheMatchAsync(dialogContext);
  //                   _matchWebSocketService?.disconnect();
  //                   isShowWaitingDialogOpen = false;

  //                   if (dialogContext.mounted) {
  //                     Navigator.of(dialogContext).pop();
  //                   }

  //                   if (context.mounted) {
  //                     Navigator.of(context).pushReplacement(
  //                       MaterialPageRoute(
  //                         builder: (_) => Tela03PrincipalWidget(),
  //                       ),
  //                     );
  //                   }
  //                 },
  //                 child: const Text("Fechar"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void showWaitingDialog() {
    if (isShowWaitingDialogOpen) return;

    isShowWaitingDialogOpen = true;
    currentShowWaitingDialog = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) {
        final AnimationController progressController = AnimationController(
          duration: const Duration(seconds: 2),
          vsync: Navigator.of(context),
        )..repeat();

        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.all(40),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF01BF01),
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0)
                              .animate(progressController),
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 8,
                          ),
                        ),
                        Icon(
                          Icons.people_alt_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Título com animação de pulsação
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.95, end: 1.05),
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Text(
                          "Aguardando Jogadores",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Contador de jogadores com animação
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(participants.length),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${participants.length} / ${matchInfo.room!.roomConfiguration!.numberOfPlayers} conectados",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        List.generate(3, (index) => _buildAnimatedDot(index)),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    "Esperando participantes conectarem...",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () async {
                      progressController.dispose();
                      await leaveTheMatchAsync(context);
                      _matchWebSocketService?.disconnect();
                      isShowWaitingDialogOpen = false;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => Tela03PrincipalWidget(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "SAIR DA PARTIDA",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedDot(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Duration(milliseconds: 600 + (index * 200)),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
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

  // void showMatchParticipantsDialog() {
  //   if (isShowWaitingDialogOpen) return;

  //   isShowWaitingDialogOpen = true;
  //   currentShowWaitingDialog = context;

  //   if (currentUser != null) {
  //     participants.insert(0, currentUser!);
  //   }
  //   final minimumAmount =
  //       matchInfo.room?.roomConfiguration?.minimumAmountToPlay ?? 0;
  //   var infos = [
  //     {
  //       'title': 'Inscrição',
  //       'icon': Icons.attach_money,
  //       'value': '${minimumAmount}KZ',
  //     },
  //     {
  //       'title': 'Prêmio',
  //       'icon': Icons.wine_bar_rounded,
  //       'value': '${matchInfo.matchPrize?.totalGain ?? 0} KZ',
  //     },
  //     {
  //       'title': 'Nº Questões',
  //       'icon': Icons.numbers,
  //       'value': '${matchInfo.room!.roomConfiguration!.numberOfQuestions}',
  //     },
  //     {
  //       'title': 'Vagas',
  //       'icon': Icons.people,
  //       'value':
  //           '${matchInfo.matchPlayers?.length ?? 0}/${matchInfo.room?.roomConfiguration?.numberOfPlayers ?? 0}',
  //     },
  //   ];

  //   CommonDialogWidget.showMatchParticipantsDialog(
  //     context,
  //     infos,
  //     "Desafio",
  //     matchInfo,
  //     participants,
  //     currentUser,
  //     _buildDialogActions(),
  //   );
  // }

  // Widget _buildDialogActions() {
  //   return Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 16),
  //         child: Column(
  //           children: [
  //             const CircularProgressIndicator(
  //               color: Color(0xFFEC8D0D),
  //             ),
  //             const SizedBox(height: 8),
  //             Text(
  //               'Aguardando participantes...',
  //               style: FlutterFlowTheme.of(context).bodyMedium.override(
  //                     fontFamily: 'Inter',
  //                     color: const Color(0xFFEC8D0D),
  //                     fontSize: 14,
  //                     letterSpacing: 0,
  //                   ),
  //             ),
  //             Text(
  //               'Participantes conectados: ${participants.length}/${matchInfo.room!.roomConfiguration!.numberOfPlayers}',
  //               style: FlutterFlowTheme.of(context).bodySmall.override(
  //                     fontFamily: 'Inter',
  //                     letterSpacing: 0,
  //                   ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           FFButtonWidget(
  //             onPressed: () async {
  //               Navigator.of(currentShowWaitingDialog).pop();
  //               await leaveTheMatchAsync(context);
  //               _matchWebSocketService?.disconnect();
  //               isShowWaitingDialogOpen = false;
  //             },
  //             text: 'Cancelar',
  //             options: FFButtonOptions(
  //               height: 40,
  //               padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
  //               color: FlutterFlowTheme.of(context).error,
  //               textStyle: FlutterFlowTheme.of(context).titleSmall.override(
  //                     fontFamily: 'Inter',
  //                     color: Colors.white,
  //                     letterSpacing: 0,
  //                   ),
  //               elevation: 3,
  //               borderSide: const BorderSide(
  //                 color: Colors.transparent,
  //                 width: 1,
  //               ),
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Future<void> getUsersByMatchId(Function setState, matchId) async {
    var result = await userService.getPlayerByMatchIdAsync(matchId);

    if (result["isSuccess"]) {
      setState(() {
        participants = result["data"];
      });
    }
  }
}
