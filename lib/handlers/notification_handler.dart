import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/models/responses/question_response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/pages/tela06_salade_jogo/tela06_salade_jogo_widget.dart';
import 'package:projeto_game_quiz/pages/tela13_dados_de_partida/tela13_dados_de_partida_widget.dart';

class NotificationHandler {
  final matchService = MatchService();

  void setupNotificationHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final data = message.data;

      if (message.notification != null && data.containsKey("matchId")) {
        final context = appNavigatorKey.currentContext;
        if (data.containsKey("action")) {
          var matchInfo =
              await matchService.getMatchByMatchIdAsync(data["matchId"]);

          if (data["action"] == "START_TO_MATCH_SCHEDULED") {
            if (context != null) {
              final decodedMessage = jsonDecode(data["nextQuestion"]);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Tela06SaladeJogoWidget(
                    matchInfo: matchInfo["data"],
                    recebeuNotificaca: true,
                    nextQuestion:
                        QuestionResponse.fromJson(decodedMessage),
                  ),
                ),
              );
            }
          } else if (data["action"] == "TO_JOIN_THE_MATCH") {
            if (context != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Tela13DadosDePartidaWidget(
                      matchId: data["matchId"], recebeuNotificaca: true),
                ),
              );
            }
          }
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      final data = message.data;

      if (message.notification != null && data.containsKey("matchId")) {
        final context = appNavigatorKey.currentContext;
        var matchInfo =
            await matchService.getMatchByMatchIdAsync(data["matchId"]);

        if (data.containsKey("action")) {
          if (data["action"] == "START_TO_MATCH_SCHEDULED") {
            if (context != null) {
              final decodedMessage = jsonDecode(data["nextQuestion"]);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Tela06SaladeJogoWidget(
                    matchInfo: matchInfo["data"],
                    nextQuestion: QuestionResponse.fromJson(decodedMessage),
                  ),
                ),
              );
            }
          } else if (data["action"] == "TO_JOIN_THE_MATCH") {
            if (context != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Tela13DadosDePartidaWidget(
                      matchId: data["matchId"], recebeuNotificaca: true),
                ),
              );
            }
          }
        }
      }
    });
  }
}
