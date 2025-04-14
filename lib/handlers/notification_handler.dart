import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/pages/tela06_salade_jogo/tela06_salade_jogo_widget.dart';
import 'package:projeto_game_quiz/pages/tela13_dados_de_partida/tela13_dados_de_partida_widget.dart';

class NotificationHandler {
  final matchService = MatchService();

  void setupNotificationHandler() {
    // Notificação recebida enquanto o app está em primeiro plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final data = message.data;

      if (message.notification != null && data.containsKey("matchId")) {
        final context = appNavigatorKey.currentContext;
        if (data.containsKey("action")) {
          var matchInfo =
              await matchService.getMatchByMatchIdAsync(data["matchId"]);

          if (data["action"] == "START_TO_MATCH") {
            if (context != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Tela06SaladeJogoWidget(
                    matchInfo: matchInfo["data"],
                    recebeuNotificaca: true,
                  ),
                ),
              );
            }
          } else {
            if (context != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      Tela13DadosDePartidaWidget(matchId: data["matchId"], recebeuNotificaca: true),
                ),
              );
            }
          }
        }
      }
    });

    // Notificação recebida enquanto o app estava em segundo plano
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      final data = message.data;

      if (message.notification != null && data.containsKey("matchId")) {
        final context = appNavigatorKey.currentContext;
        var matchInfo =
            await matchService.getMatchByMatchIdAsync(data["matchId"]);

        if (data.containsKey("action")) {
          if (data["action"] == "START_TO_MATCH") {
            if (context != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Tela06SaladeJogoWidget(
                      matchInfo: matchInfo["data"], recebeuNotificaca: true),
                ),
              );
            }
          } else {
            if (context != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      Tela13DadosDePartidaWidget(matchId: data["matchId"],recebeuNotificaca: true),
                ),
              );
            }
          }
        }
      }
    });
  }
}
