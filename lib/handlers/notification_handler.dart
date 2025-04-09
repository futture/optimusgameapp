import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/pages/tela13_dados_de_partida/tela13_dados_de_partida_widget.dart';

class NotificationHandler {
  void setupNotificationHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final data = message.data;

      if (message.notification != null && data.containsKey("matchId")) {
        final context = appNavigatorKey.currentContext;
        if (context != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Tela13DadosDePartidaWidget(
                  matchId: data["matchId"]),
            ),
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final data = message.data;

      if (message.notification != null && data.containsKey("matchId")) {
        final context = appNavigatorKey.currentContext;
        if (context != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Tela13DadosDePartidaWidget(
                  matchId: data["matchId"]),
            ),
          );
        }
      }
    });
  }
}
