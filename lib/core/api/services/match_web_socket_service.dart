import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/core/api/common/web_socket_api.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';

class MatchWebSocketService {
  final String? matchId;
  final MatchResponse? matchInfo;
  final String? userId;
  final BuildContext context;

  WebSocketService? _webSocketService;
  void Function(MatchTotalNumberPlayerResponse matchInfo)? onMatchUpdate;
  void Function(dynamic error)? onError;
  void Function()? onDone;
  void Function(MatchTotalNumberPlayerResponse matchInfo)? onOther;
  void Function(MatchTotalNumberPlayerResponse)? onPlayersUpdate;
  void Function(ScheduledMatchStartResponse)? onScheduledMatchUpdate;

  MatchWebSocketService(
      {this.matchId,
      this.userId,
      required this.context,
      this.matchInfo,
      this.onMatchUpdate,
      this.onError,
      this.onDone,
      this.onOther,
      this.onPlayersUpdate,
      this.onScheduledMatchUpdate});

  void connect() {
    final url = '/wait-for-players/match/$matchId/user/$userId';

    _webSocketService = WebSocketService(
      url: url,
      onMessageReceived: (message) async {
        var decodedMessage = jsonDecode(message);
        var matchUpdate =
            MatchTotalNumberPlayerResponse.fromJson(decodedMessage);

        onMatchUpdate?.call(matchUpdate);
        onPlayersUpdate?.call(matchUpdate);

        if (matchUpdate.isReady) {
          if (onOther != null) onOther!(matchUpdate);
        }
      },
      onError: onError,
      onDone: onDone,
    );

    _webSocketService?.connect();
  }

  void connectStartScheduledSatch() {
    final url = '/start-scheduled-match/match/$matchId/player/$userId';

    _webSocketService = WebSocketService(
      url: url,
      onMessageReceived: (message) async {
        var decodedMessage = jsonDecode(message);
        var scheduledMatch =
            ScheduledMatchStartResponse.fromJson(decodedMessage);

        if (onScheduledMatchUpdate != null)
          onScheduledMatchUpdate!(scheduledMatch);
      },
      onError: onError,
      onDone: onDone,
    );

    _webSocketService?.connect();
  }

  void disconnect() {
    _webSocketService?.disconnect();
  }
}
