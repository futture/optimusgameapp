import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/account_service.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/responses/account_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_ranking_metrics_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'tela04_perfil_widget.dart' show Tela04PerfilWidget;
import 'package:flutter/material.dart';

class Tela04PerfilModel extends FlutterFlowModel<Tela04PerfilWidget> {
  UserResponse? user;
  AccountResponse? userAccountInfo;
  final AccountService accountService = AccountService();
  UserRankingMetricsResponse? rankingMetrics;
  final UserService userService = UserService();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  Future<void> getUserInfoAndAccountInfoAsync(
      void Function(VoidCallback fn) setState, BuildContext context) async {
    await getUserInfo(setState);
    await getUserAccountInfo(setState);
    await getUserRankingMetrics(setState, context);
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

  Future<void> getUserRankingMetrics(
      void Function(VoidCallback fn) setState, BuildContext context) async {
    final userId = user?.id;
    if (userId == null) return;

    final result = await userService.getUserRankingMetricsAsync(userId);

    if (result["isSuccess"] == true) {
      setState(() {
        rankingMetrics = result["data"];
      });
    } else { 
      setState(() {
        rankingMetrics = UserRankingMetricsResponse(
          userId: userId,
          totalScore: 0,
          totalScoreFormatted: "0",
          totalWins: 0,
          winRate: 0,
        );
      });
    }
  }
}
