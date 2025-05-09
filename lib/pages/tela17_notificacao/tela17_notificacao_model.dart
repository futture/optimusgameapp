import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/push_notification_service.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/push_notification_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';
import 'package:projeto_game_quiz/pages/tela17_notificacao/tela17_notificacao_widget.dart';

class Tela17NotificacaoModel
    extends FlutterFlowModel<Tela17NotificacaoViewWidget> {
  String? userId = "";
  MatchResponse? match;
  bool isLoading = false;
  UserResponse? currentUser;
  List<UserResponse> players = List.empty();
  UserService userService = UserService();
  MatchService matchService = MatchService();

  List<PushNotificationResponse> pushNotifications = List.empty();
  UserPushNotificationService userPushNotificationService =
      UserPushNotificationService();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
  Future<void> loadAsync(Function setState) async {
    await getUserIdAsync();
    await getPushNotificationByUserIdAsync(setState);
  }

  Future<void> getUserIdAsync() async {
    userId = await UserUtil.getUserId() ?? "";
    currentUser = await UserUtil.getUserInfo();
  }

  Future<void> getPushNotificationByUserIdAsync(Function setState) async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await userPushNotificationService
          .getPuahNotificationByUserIdAsync(userId!);

      if (result["isSuccess"]) {
        List<PushNotificationResponse> notifications = result["data"];
        setState(() {
          pushNotifications = notifications
              .where((n) => n.createdAt != null)
              .toList()
            ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
          ;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        await Warning00ErrorUtil.showDialogMessageError(
          context,
          result["error"].detail.message,
          result["error"].detail.details,
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      await Warning00ErrorUtil.showDialogMessageError(
        context,
        "Erro ao carregar notificações",
        e.toString(),
      );
    }
  }

  Future<List<UserResponse>> getPlayerByMatchIdAsync(
      Function setState, String matchId) async {
    var result = await userService.getPlayerByMatchIdAsync(matchId);
    if (result["isSuccess"]) {
      setState(() {
        players = result["data"];
      });
    }
    return List.empty();
  }

  Future<List<UserResponse>> getMatchByMatchIdAsync(
      Function setState, String matchId) async {
    var result = await matchService.getMatchByMatchIdAsync(matchId);
    if (result["isSuccess"]) {
      setState(() {
        match = result["data"];
      });
    }
    return List.empty();
  }
}
