import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/core/api/common/web_socket_api.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/pages/tela06_salade_jogo/tela06_salade_jogo_widget.dart';

class MatchWebSocketService {
  final String matchId;
  final MatchResponse matchInfo;
  final String userId;
  final BuildContext context;

  WebSocketService? _webSocketService;
  late final MatchService _matchService = MatchService();

  void Function(MatchTotalNumberPlayerResponse matchInfo)? onMatchUpdate;
  void Function(dynamic error)? onError;
  void Function()? onDone;
  void Function()? onOther;

  MatchWebSocketService(
      {required this.matchId,
      required this.userId,
      required this.context,
      required this.matchInfo,
      this.onMatchUpdate,
      this.onError,
      this.onDone,
      this.onOther});

  void connect() {
    final url = '/wait-for-players/match/$matchId/user/$userId';

    _webSocketService = WebSocketService(
      url: url,
      onMessageReceived: (message) async {
        var decodedMessage = jsonDecode(message);
        var matchUpdate =
            MatchTotalNumberPlayerResponse.fromJson(decodedMessage);

        onMatchUpdate?.call(matchUpdate);

        if (matchUpdate.playersConnected >= matchUpdate.minPlayers) {
          await startMatchAsync();

          if (onOther != null) onOther!();
        }
      },
      onError: onError,
      onDone: onDone,
    );

    _webSocketService?.connect();
  }

  Future<void> startMatchAsync() async {
    try {
      final resultStartMatch =
          await _matchService.startMatchAsync(matchInfo.id);

      if (resultStartMatch["isSuccess"]) {
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => Tela06SaladeJogoWidget(matchInfo: matchInfo),
          ),
        );
        print("Partida iniciada com sucesso!");
      } else {
        print("Falha ao iniciar a partida: ${resultStartMatch["message"]}");
      }
    } catch (e) {
      print("Erro ao iniciar a partida: $e");
    }
  }

  void disconnect() {
    _webSocketService?.disconnect();
  }
}
