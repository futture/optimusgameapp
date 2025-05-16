import 'dart:async';

import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/account_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_web_socket_service.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/api/utils/super_match_util.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/account_response.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/dialogs/common_dialog_widget.dart';
import 'package:projeto_game_quiz/dialogs/success-dialog-widget.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';

class Tela03PrincipalModel extends FlutterFlowModel<Tela03PrincipalWidget> {
  List<MatchResponse> matchList = [];
  MatchResponse? nextMatch;
  bool isLoadingMatches = true;
  bool alerted = false;
  UserResponse? user;
  AccountResponse? userAccountInfo;
  bool isNotRegisteredMatch = false;
  MatchWebSocketService? _matchWebSocketService;
  final AccountService accountService = AccountService();
  final MatchService matchService = MatchService();
  final UserService userService = UserService();
  final timerInitialTimeMs = 10800000;
  int timerMilliseconds = 10800000;
  String timerValue =
      StopWatchTimer.getDisplayTime(10800000, milliSecond: false);
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));
  InstantTimer? instantTimer;
  bool isDialogStartScheduledMatchOpen = false;
  List<UserResponse> users = List.empty();
  late BuildContext currentDialogStartScheduledMatchOpenContext;
  bool hasStartedMatch = false;

  @override
  void initState(BuildContext context) {
    currentDialogStartScheduledMatchOpenContext = context;
  }

  @override
  void dispose() {
    timerController.dispose();
    instantTimer?.cancel();
    _matchWebSocketService?.disconnect();
  }

  Future<void> getUserInfoAndAccountInfoAsync(
      void Function(VoidCallback fn) setState, BuildContext context) async {
    await getUserInfo(setState);
    await getUserAccountInfo(setState);
  }

  Future<void> getUserInfo(void Function(VoidCallback fn) setState) async {
    var _user = await UserUtil.getUserInfo();
    setState(() {
      user = _user!;
    });
  }

  Future<void> getUserAccountInfo(
      void Function(VoidCallback fn) setState) async {
    var result = await accountService.getAccountByUserIdAsync(user!.id);
    if (result["isSuccess"]) {
      setState(() {
        userAccountInfo = result["data"];
      });
    } else {
      Warning00ErrorUtil.showDialogMessageError(context,
          result["error"].detail.message, result["error"].detail.details);
    }
  }

  Future<bool> checkPlayerAlreadyRegisteredMatchAsync(
      void Function(VoidCallback fn) setState, String matchId) async {
    var result = await matchService.checkPlayerAlreadyRegisteredMatchAsync(
        matchId, user!.id);
    if (result["isSuccess"]) {
      setState(() {
        isNotRegisteredMatch = false;
      });
      return true;
    } else {
      if (result["error"].detail.code == "ERR_PLAYER_NOT_REGISTERED_MATCH") {
        setState(() {
          isNotRegisteredMatch = true;
        });
        return false;
      }
    }
    return false;
  }

  DateTime truncateToMinute(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute);
  }

  Future<void> loadMatches(void Function(VoidCallback fn) setState) async {
    isLoadingMatches = true;
    setState(() {});

    try {
      var _dateTime = DateTime.now();
      final response = await matchService.getAllMatchAsync(
          isEvent: true,
          status: [Status.Pendente.label, Status.AguardandoInicio.label],
          startDate: _dateTime);

      if (response['isSuccess']) {
        final List<MatchResponse> matches = response['data'];
        matches.sort((a, b) => a.matchStartDate.compareTo(b.matchStartDate));

        setState(() => matchList = matches);

        for (var match in matches) {
          bool isRegistered =
              await checkPlayerAlreadyRegisteredMatchAsync(setState, match.id);
          match.isUserRegistered = isRegistered;
        }

        final now = truncateToMinute(DateTime.now());

        final futureMatches = matches
            .where((m) => truncateToMinute(m.matchStartDate).isAfter(now))
            .toList();

        if (futureMatches.isNotEmpty) {
          futureMatches
              .sort((a, b) => a.matchStartDate.compareTo(b.matchStartDate));
          final closestMatch = futureMatches.first;

          _startCountdown(closestMatch, setState);
        } else {
          setState(() => nextMatch = null);
        }
      }
    } catch (e) {
      print('Erro ao carregar partidas: $e');
    } finally {
      setState(() => isLoadingMatches = false);
    }
  }

  void _startCountdown(
      MatchResponse match, void Function(VoidCallback fn) setState) {
    final now = DateTime.now();
    final initialDuration = match.matchStartDate.difference(now);

    setState(() {
      nextMatch = match;
      timerMilliseconds = initialDuration.inMilliseconds;
      timerController = FlutterFlowTimerController(
        StopWatchTimer(mode: StopWatchMode.countDown),
      );
      timerController.onStartTimer();
    });

    Timer.periodic(Duration(seconds: 1), (timer) async {
      final remaining = match.matchStartDate.difference(DateTime.now());

      setState(() {
        timerMilliseconds = remaining.inMilliseconds;
      });

      if (remaining.inSeconds == 2 && !hasStartedMatch) {
        var superMatchPref = await SuperMatchUtil.getSuperMatch();

        if (superMatchPref == null) {
          hasStartedMatch = true;
          setState(() => alerted = false);

          var isExist =
              await checkPlayerAlreadyRegisteredMatchAsync(setState, match.id);
          if (isExist) {
            await getUsersByMatchId(setState, match.id);
            showMatchParticipantsDialog(match);
            await startScheduledSatchAsync(setState, match);
            return;
          }
        }
      }

      if (remaining.isNegative) {
        timer.cancel();
        setState(() {
          alerted = false;
          hasStartedMatch = false;
        });
        loadMatches(setState);
      }
    });
  }

  // Future<void> _callApiBeforeMatchStart(String matchId) async {
  //   try {
  //     var resultNotice = await matchService.getMatchStartNoticeAsync(matchId);
  //     if (!resultNotice["isSuccess"]) {
  //       Warning00ErrorUtil.showDialogMessageError(
  //           context,
  //           resultNotice["error"].detail.message,
  //           resultNotice["error"].detail.details);
  //     }
  //     print('API chamada com sucesso para a partida $matchId');
  //   } catch (e) {
  //     print('Erro ao chamar API: $e');
  //   }
  // }

  Future<void> startScheduledSatchAsync(
      Function setState, MatchResponse match) async {
    _matchWebSocketService = MatchWebSocketService(
      userId: user!.id,
      matchInfo: match,
      context: context!,
      matchId: match.id,
      onScheduledMatchUpdate: (stats) {
        if (stats.error != null && stats.error!.detail != null) {
          _showErrorDialog(stats.error, match.id);
          closeDialogStartScheduledMatch();
        } else {
          closeDialogStartScheduledMatch();
          final isUserInMatch = stats.players?.contains(user!.id);

          if (isUserInMatch!) {
            Navigator.of(context!).pop();
            Navigator.of(context!).push(
              MaterialPageRoute(
                builder: (_) => Tela06SaladeJogoWidget(
                  matchInfo: match,
                  nextQuestion: stats.nextQuestion,
                ),
              ),
            );
          } else {
            debugPrint("Usuário não está na lista de jogadores desta partida.");
          }
        }
      },
      onError: (e) {
        handleWebSocketFailureIfNeeded(() => {});
        debugPrint("Erro no WebSocket: $e");
      },
      onDone: () {
        debugPrint("Conexão WebSocket encerrada.");
      },
    );

    _matchWebSocketService?.connectStartScheduledSatch();
  }

  void handleWebSocketFailureIfNeeded(Function setState) {
    //   final totalQuestionsToRespond =
    //       matchInfo?.room?.roomConfiguration?.numberOfQuestions ?? 0;

    //   if (questionsAlreadyPresented >= totalQuestionsToRespond) {
    //     setState(() {
    //       isBtnEndGameManually = true;
    //     });
    //   } else {
    //     Navigator.of(context!).pushReplacement(
    //       MaterialPageRoute(
    //         builder: (_) => Tela03PrincipalWidget(),
    //       ),
    //     );
    //     //Navigator.of(context!).popUntil((route) => route.isFirst);
    //   }
  }

  void _showErrorDialog(error, matchId) {
    if (error == null) return;
    if (error.detail == null) return;

    showDialog(
      context: context!,
      builder: (BuildContext _dialogContext) {
        bool isRetrying = false;
        bool isLeaving = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(error.detail.message!),
              content: Text(error.detail.details!),
              actions: <Widget>[
                TextButton(
                  onPressed: isRetrying
                      ? null
                      : () {
                          setState(() => isRetrying = true);
                          startScheduledSatchAsync(() {}, nextMatch!)
                              .whenComplete(() {
                            if (Navigator.of(_dialogContext).canPop()) {
                              Navigator.of(_dialogContext).pop();
                            }
                          });
                        },
                  child: isRetrying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Tentar Novamente"),
                ),
                if (error.detail.code == "ERR_INSUFFICIENT_NUMBER_PLAYERS")
                  TextButton(
                    onPressed: isLeaving
                        ? null
                        : () async {
                            setState(() => isLeaving = true);
                            if (Navigator.of(_dialogContext).canPop()) {
                              Navigator.of(_dialogContext).pop();
                            }
                            await leaveTheMatchAsync(
                                matchId, () {}, _dialogContext);
                          },
                    child: isLeaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Sair Da Partida"),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> leaveTheMatchAsync(
      matchId, void Function()? func, BuildContext _dialogContext) async {
    var result = await matchService.leaveTheMatchAsync(matchId, user!.id);
    if (!result["isSuccess"]) {
      Warning00ErrorUtil.showDialogMessageError(context,
          result["error"].detail.message, result["error"].detail.details);
    } else {
      if (Navigator.of(_dialogContext).canPop()) {
        Navigator.of(_dialogContext).pop();
      }
      SuccessDialogWidgetUtil.showDialogMessageSuccess(
          context, "Sair da partida", "", func);
    }
  }

  Future<void> leaveMatchAsync(matchId) async {
    var result = await matchService.leaveTheMatchAsync(matchId, user!.id);
    if (!result["isSuccess"]) {
      Warning00ErrorUtil.showDialogMessageError(context,
          result["error"].detail.message, result["error"].detail.details);
    }
  }

  void showDialogStartScheduledMatch(BuildContext context) {
    if (isDialogStartScheduledMatchOpen) return;

    isDialogStartScheduledMatchOpen = true;
    currentDialogStartScheduledMatchOpenContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("Iniciando a partida..."),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Preparar tudo para a partida, aguardem..."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Fechar"),
          ),
          // if (isBtnEndGameManually)
          //   TextButton(
          //     onPressed: () async {
          //       await endGameFlow(() => {});
          //     },
          //     child: const Text("Terminar manualmente"),
          //   ),
        ],
      ),
    );
  }

  void closeDialogStartScheduledMatch() {
    if (isDialogStartScheduledMatchOpen &&
        Navigator.canPop(currentDialogStartScheduledMatchOpenContext)) {
      Navigator.of(currentDialogStartScheduledMatchOpenContext).pop();
      isDialogStartScheduledMatchOpen = false;
    }
  }

  Future<void> getUsersByMatchId(Function setState, matchId) async {
    var result = await userService.getPlayerByMatchIdAsync(matchId);

    if (result["isSuccess"]) {
      setState(() {
        users = result["data"];
      });
    }
  }

  void showMatchParticipantsDialog(MatchResponse matchInfo) {
    if (isDialogStartScheduledMatchOpen) return;
    var participants = users;
    var currentUser = user;
    isDialogStartScheduledMatchOpen = true;
    currentDialogStartScheduledMatchOpenContext = context!;
    final minimumAmount =
        matchInfo.room?.roomConfiguration?.minimumAmountToPlay ?? 0;
    var infos = [
      {
        'title': 'Inscrição',
        'icon': Icons.attach_money,
        'value': '${minimumAmount}KZ',
      },
      {
        'title': 'Prêmio',
        'icon': Icons.wine_bar_rounded,
        'value': '${matchInfo.matchPrize?.totalGain ?? 0} KZ',
      },
      {
        'title': 'Nº Questões',
        'icon': Icons.numbers,
        'value': '${matchInfo.room!.roomConfiguration!.numberOfQuestions}',
      },
      {
        'title': 'Vagas',
        'icon': Icons.people,
        'value':
            '${matchInfo.matchPlayers?.length ?? 0}/${matchInfo.room?.roomConfiguration?.numberOfPlayers ?? 0}',
      },
    ];

    CommonDialogWidget.showMatchParticipantsDialog(
        currentDialogStartScheduledMatchOpenContext,
        infos,
        null,
        matchInfo,
        participants,
        currentUser,
        _buildDialogActions(participants, matchInfo),
        isPlaySound: true,
        isProgressBar: false);
  }

  Widget _buildDialogActions(
      List<UserResponse> parts, MatchResponse matchInfo) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFFEC8D0D),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aguardando participantes...',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(
                          currentDialogStartScheduledMatchOpenContext)
                      .bodyMedium
                      .override(
                        fontFamily: 'Inter',
                        color: const Color(0xFFEC8D0D),
                        fontSize: 14,
                        letterSpacing: 0,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Participantes conectados: ${parts.length}/${matchInfo.room!.roomConfiguration!.numberOfPlayers}',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(
                          currentDialogStartScheduledMatchOpenContext)
                      .bodySmall
                      .override(
                        fontFamily: 'Inter',
                        letterSpacing: 0,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
