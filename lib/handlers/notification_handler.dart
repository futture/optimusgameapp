import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/common/error_response.dart';
import 'package:projeto_game_quiz/core/models/responses/question_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/pages/tela06_salade_jogo/tela06_salade_jogo_widget.dart';
import 'package:projeto_game_quiz/pages/tela13_dados_de_partida/tela13_dados_de_partida_widget.dart';
import 'package:projeto_game_quiz/pages/tela16_erro_informacao_partida/tela16_erro_informacao_partida_widget.dart';

class NotificationHandler {
  final userService = UserService();
  final matchService = MatchService();
  Future<void> subscribeToMatchTopic(String topic, String matchId) async {
    try {
      var _topic = "${topic}_${matchId}";

      await FirebaseMessaging.instance.subscribeToTopic(_topic);
      print('Inscrito no tópico match-start $topic');
    } catch (e) {
      print('Erro ao se inscrever no tópico: $e');
    }
  }

  void setupNotificationHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final data = message.data;
      UserResponse? currentUser = await UserUtil.getUserInfo();

      if (message.notification != null && data.containsKey("matchId")) {
        final context = appNavigatorKey.currentContext;
        if (data.containsKey("action")) {
          var matchInfo =
              await matchService.getMatchByMatchIdAsync(data["matchId"]);

          var parts = await getPlayerByMatchIdAsync(data["matchId"]);

          if (data["action"] == "START_TO_MATCH_SCHEDULED") {
            if (context != null) {
              final decodedMessage = jsonDecode(data["nextQuestion"]);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Tela06SaladeJogoWidget(
                    matchInfo: matchInfo["data"],
                    recebeuNotificaca: true,
                    nextQuestion: QuestionResponse.fromJson(decodedMessage),
                  ),
                ),
              );
            }
          } else if (data["action"] == "TO_JOIN_THE_MATCH") {
            if (context != null) {
              DadosDaPartidaUtils.showMatchParticipantsDialog(
                context,
                currentUser,
                matchInfo["data"],
                parts,
                matchInfo["data"]!.statusMatch == "PENDING"
                    ? null
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              'Partida terminada...',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: const Color(0xFFEC8D0D),
                                    fontSize: 14,
                                    letterSpacing: 0,
                                  ),
                            ),
                            Text(
                              'Partida ja fechada',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0,
                                  ),
                            ),
                          ],
                        ),
                      ),
              );

              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (_) => Tela13DadosDePartidaWidget(
              //         matchId: data["matchId"], recebeuNotificaca: true),
              //   ),
              // );
            }
          } else if (data["action"] == "ERR_START_TO_MATCH_SCHEDULED") {
            final decodedMessageErr = jsonDecode(data["error"]);

            if (context != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Tela16ErroInformacaoPartidaViewWidget(
                    matchResponse: matchInfo["data"],
                    error: DetailErrorResponse.fromJson(decodedMessageErr),
                  ),
                ),
              );
            }
          } else if (data["action"] == "SCHEDULED_MATCH_WILL_BEGIN") {
            if (context != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Tela13DadosDePartidaWidget(
                    matchId: data["matchId"],
                    notDisplayButton: true,
                  ),
                ),
              );
            }
          }
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      final data = message.data;
      UserResponse? currentUser = await UserUtil.getUserInfo();

      if (message.notification != null && data.containsKey("matchId")) {
        final context = appNavigatorKey.currentContext;
        var matchInfo =
            await matchService.getMatchByMatchIdAsync(data["matchId"]);
        var parts = await getPlayerByMatchIdAsync(data["matchId"]);

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
              DadosDaPartidaUtils.showMatchParticipantsDialog(
                context,
                currentUser,
                matchInfo["data"],
                parts,
                matchInfo["data"]!.statusMatch == "PENDING"
                    ? null
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              'Partida terminada...',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: const Color(0xFFEC8D0D),
                                    fontSize: 14,
                                    letterSpacing: 0,
                                  ),
                            ),
                            Text(
                              'Partida ja fechada',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0,
                                  ),
                            ),
                          ],
                        ),
                      ),
              );
            }
          } else if (data["action"] == "ERR_START_TO_MATCH_SCHEDULED") {
            final decodedMessageErr = jsonDecode(data["error"]);

            if (context != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Tela16ErroInformacaoPartidaViewWidget(
                    matchResponse: matchInfo["data"],
                    error: DetailErrorResponse.fromJson(decodedMessageErr),
                  ),
                ),
              );
            }
          } else if (data["action"] == "SCHEDULED_MATCH_WILL_BEGIN") {
            if (context != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Tela13DadosDePartidaWidget(
                    matchId: data["matchId"],
                    notDisplayButton: true,
                  ),
                ),
              );
            }
          } else if (data["action"] == "DISQUALIFIED_FROM_MATCH") {
            if (context != null) {
              var matchInfo =
                  await matchService.getMatchByMatchIdAsync(data["matchId"]);
              var parts = await getPlayerByMatchIdAsync(data["matchId"]);
              DadosDaPartidaUtils.showMatchParticipantsDialog(
                context,
                currentUser,
                matchInfo["data"]!,
                parts,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Jogador desqualificado...',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: const Color(0xFFEC8D0D),
                              fontSize: 14,
                              letterSpacing: 0,
                            ),
                      ),
                      Text(
                        'Jogador desqualificado por inatividade',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        }
      }
    });
  }

  Future<List<UserResponse>> getPlayerByMatchIdAsync(matchId) async {
    var result = await userService.getPlayerByMatchIdAsync(matchId);
    if (result["isSuccess"]) {
      return result["data"];
    }
    return List.empty();
  }
}
