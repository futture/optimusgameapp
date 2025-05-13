import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/ranking_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/player_answers_response.dart';
import 'package:projeto_game_quiz/core/models/responses/ranking_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'tela09_historico_jodos_widget.dart' show Tela09HistoricoJodosWidget;
import 'package:flutter/material.dart';

class Param {
  bool? isEvent;
  String? status;
  DateTime? startDate;
  DateTime? endDate;
  Param({this.isEvent, this.status, this.endDate, this.startDate});
}

class Tela09HistoricoJodosModel
    extends FlutterFlowModel<Tela09HistoricoJodosWidget> {
  Param param = Param();
  String? userId = "";
  MatchResponse? matchInfo;
  UserResponse? currentUser;
  bool isLoadingRanking = false;
  bool isLoadingHistory = false;
  bool isLoadingLeave = false;
  List<MatchResponse> matches = List.empty();
  List<RankingResponse> rankings = List.empty();
  List<PlayerAnswersResponse> historys = List.empty();
  MatchService _matchService = MatchService();
  RankingService _rankingService = RankingService();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  Future<void> getUserIdAsync() async {
    userId = await UserUtil.getUserId();
    currentUser = await UserUtil.getUserInfo();
  }

  Future<void> load(Function setState) async {
    await getUserIdAsync();
    await getMatchByUserIdAsync(setState, userId!);
    await getRankingByUserdAsync(setState);
  }

  Future<void> getRankingByUserdAsync(Function setState) async {
    setState(() {
      isLoadingRanking = true;
    });
    var result = await _rankingService.getRankingByUserdAsync(userId!);

    if (result["isSuccess"]) {
      setState(() {
        rankings = result["data"];

        rankings.sort((a, b) => (b.createdAt ??
                DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)));
        isLoadingRanking = false;
      });
    } else {
      setState(() {
        isLoadingRanking = false;
      });
      Warning00ErrorUtil.showDialogMessageError(
        context!,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }

  Future<void> getHistoryUserdAsync(Function setState, matchId) async {
    await getMatchByMatchIdAsync(setState, matchId);
    setState(() {
      isLoadingHistory = true;
    });
    var result = await _rankingService.getHistoryUserdAsync(userId!, matchId);

    if (result["isSuccess"]) {
      setState(() {
        historys = result["data"];
        isLoadingHistory = false;
      });
    } else {
      setState(() {
        isLoadingHistory = false;
      });
      Warning00ErrorUtil.showDialogMessageError(
        context!,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }

  Future<void> getMatchByMatchIdAsync(Function setState, matchId) async {
    var result = await _matchService.getMatchByMatchIdAsync(matchId);

    if (result["isSuccess"]) {
      setState(() {
        matchInfo = result["data"];
      });
    } else {
      Warning00ErrorUtil.showDialogMessageError(
        context!,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }

  Future<void> getMatchByUserIdAsync(Function setState, matchId) async {
    var result = await _matchService.getMatchByUserIdAsync(userId!,
        endDate: param.endDate,
        isEvent: param.isEvent,
        startDate: param.startDate,
        status: param.status);

    if (result["isSuccess"]) {
      setState(() {
        matches = result["data"];

        matches.sort((a, b) => (b.matchStartDate).compareTo(a.matchStartDate));
      });
    } else {
      Warning00ErrorUtil.showDialogMessageError(
        context!,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }

  Future<void> leaveTheMatchAsync(Function setState, matchId) async {
    setState(() {
      isLoadingLeave = true;
    });
    var result = await _matchService.leaveTheMatchAsync(matchId, userId!);

    if (result["isSuccess"]) {
      await getMatchByUserIdAsync(setState, matchId);
      setState(() {
        isLoadingLeave = false;
      });
    } else {
      setState(() {
        isLoadingLeave = false;
      });
      Warning00ErrorUtil.showDialogMessageError(
        context!,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }
}
