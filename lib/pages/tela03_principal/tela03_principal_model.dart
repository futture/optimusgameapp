import 'dart:async';

import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/account_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_web_socket_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/responses/account_response.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';

import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'tela03_principal_widget.dart' show Tela03PrincipalWidget;
import 'package:flutter/material.dart';

class Tela03PrincipalModel extends FlutterFlowModel<Tela03PrincipalWidget> {
  ///  State fields for stateful widgets in this page.
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
  // State field(s) for Timer widget.
  final timerInitialTimeMs = 10800000;
  int timerMilliseconds = 10800000;
  String timerValue =
      StopWatchTimer.getDisplayTime(10800000, milliSecond: false);
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));
  InstantTimer? instantTimer;

  @override
  void initState(BuildContext context) {}

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

  Future<void> checkPlayerAlreadyRegisteredMatchAsync(
      void Function(VoidCallback fn) setState, String matchId) async {
    var result = await matchService.checkPlayerAlreadyRegisteredMatchAsync(
        matchId, user!.id);
    if (result["isSuccess"]) {
      setState(() {
        isNotRegisteredMatch = false;
      });
    } else {
      if (result["error"].detail.code == "ERR_PLAYER_NOT_REGISTERED_MATCH") {
        setState(() {
          isNotRegisteredMatch = true;
        });
      }

      // Warning00ErrorUtil.showDialogMessageError(context,
      //     result["error"].detail.message, result["error"].detail.details);
    }
  }

  DateTime truncateToMinute(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute);
  }

  Future<void> loadMatches(void Function(VoidCallback fn) setState) async {
    isLoadingMatches = true;
    setState(() {});

    try {
      final response = await matchService.getAllMatchAsync(true, null);

      if (response['isSuccess']) {
        final List<MatchResponse> matches = response['data'];
        setState(() => matchList = matches);

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

      if (remaining.inSeconds <= 2 && !alerted) {
        alerted = true;
        await _callApiBeforeMatchStart(match.id);
        await startScheduledSatchAsync(setState, match);
      }

      if (remaining.isNegative) {
        timer.cancel();
        setState(() => alerted = false);
        loadMatches(setState);
      }
    });
  }

  Future<void> _callApiBeforeMatchStart(String matchId) async {
    try {
      var resultNotice = await matchService.getMatchStartNoticeAsync(matchId);
      if (!resultNotice["isSuccess"]) {
        Warning00ErrorUtil.showDialogMessageError(
            context,
            resultNotice["error"].detail.message,
            resultNotice["error"].detail.details);
      }
      print('API chamada com sucesso para a partida $matchId');
    } catch (e) {
      print('Erro ao chamar API: $e');
    }
  }

  Future<void> startScheduledSatchAsync(
      Function setState, MatchResponse match) async {
    _matchWebSocketService?.disconnect();

    _matchWebSocketService = MatchWebSocketService(
      matchInfo: match,
      context: context!,
      matchId: match.id,
      onScheduledMatchUpdate: (stats) {
        _matchWebSocketService?.disconnect();

        final isUserInMatch = stats.players.contains(user!.id);

        if (isUserInMatch) {
          Navigator.of(context!).pushReplacement(
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
      },
      onError: (e) => debugPrint("Erro no WebSocket: $e"),
      onDone: () => debugPrint("Conexão WebSocket encerrada."),
    );

    _matchWebSocketService?.connectStartScheduledSatch();
  }
}
