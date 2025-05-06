import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/push_notification_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/responses/push_notification_response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';
import 'package:projeto_game_quiz/pages/tela17_notificacao/tela17_notificacao_widget.dart';

class Tela17NotificacaoModel
    extends FlutterFlowModel<Tela17NotificacaoViewWidget> {
  String? userId = "";
  bool isLoading = false;
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
  }

  Future<void> getPushNotificationByUserIdAsync(Function setState) async {
    setState(() {
      isLoading = true;
    });
    var result = await userPushNotificationService
        .getPuahNotificationByUserIdAsync(userId!);

    if (result["isSuccess"]) {
      setState(() {
        pushNotifications = result["data"];
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
  }
}
