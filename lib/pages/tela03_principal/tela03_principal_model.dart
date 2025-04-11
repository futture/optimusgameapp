import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/account_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/responses/account_response.dart';
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
  UserResponse? user;
  AccountResponse? userAccountInfo;
  bool isNotRegisteredMatch = false;
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
      if ("Jogador não inscrito na partida".toUpperCase() ==
          result["error"].detail.details.toUpperCase()) {
        setState(() {
          isNotRegisteredMatch = true;
        });
      }

      // Warning00ErrorUtil.showDialogMessageError(context,
      //     result["error"].detail.message, result["error"].detail.details);
    }
  }
}
