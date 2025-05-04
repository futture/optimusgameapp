import 'dart:convert';
import 'package:projeto_game_quiz/core/api/common/web_socket_api.dart';
import 'package:projeto_game_quiz/core/models/requests/question_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/question_response.dart';

class QuestionWebSocketService {
  final String userId;
  final MatchResponse matchInfo;
  final QuestionResponse question;

  final void Function(QuestionStats questionStats)? onAllPlayersResponded;
  final void Function(QuestionStats questionStats)? onUpdate;
  final void Function(QuestionStats questionStats)? onWaitingForPlayersResponse;
  final void Function(dynamic error)? onError;
  final void Function()? onDone;
  bool _isConnected = false;
  bool get isConnected => _isConnected;
  late final WebSocketService _webSocketService;

  QuestionWebSocketService({
    required this.matchInfo,
    required this.question,
    required this.userId,
    this.onAllPlayersResponded,
    this.onUpdate,
    this.onWaitingForPlayersResponse,
    this.onError,
    this.onDone,
  });

  void connect() {
    if (_isConnected) return;

    final url =
        '/match/${matchInfo.id}/question/${question.id}/user/${userId}/everyone-who-responded';

    _webSocketService = WebSocketService(
      url: url,
      onMessageReceived: (message) {
        final decodedMessage = jsonDecode(message);
        final questionStats = QuestionStats.fromJson(decodedMessage);

        onUpdate?.call(questionStats);

        if (questionStats.isReady == true) {
          onAllPlayersResponded?.call(questionStats);
        } else {
          Set<String?> allUserIds = {};

          if (questionStats.hits != null) {
            allUserIds.addAll(
              questionStats.hits!.map((hit) => hit.playerId).toSet(),
            );
          }
          if (questionStats.erros != null) {
            allUserIds.addAll(
              questionStats.erros!.map((erro) => erro.playerId).toSet(),
            );
          }
          if (allUserIds.contains(userId))
            onWaitingForPlayersResponse?.call(questionStats);
        }
      },
      onError: (e) {
        _isConnected = false;
        onError?.call(e);
      },
      onDone: () {
        _isConnected = false;
        onDone?.call();
      },
    );

    _webSocketService.connect();
    _isConnected = true;
  }

  void sendAnswerToWebSocket(PlayerAnswerRequest obj) {
    var strJson = jsonEncode(obj.toJson());
    _webSocketService.sendMessage(strJson);
  }

  Future<void> tryReconnect(
      {int retries = 3, Duration delay = const Duration(seconds: 2)}) async {
    for (int i = 0; i < retries; i++) {
      if (_isConnected) break;

      try {
        await Future.delayed(delay);
        connect();
        if (_isConnected) {
          print('Reconectado com sucesso na tentativa ${i + 1}');
          break;
        }
      } catch (e) {
        print('Falha ao reconectar (tentativa ${i + 1}): $e');
      }
    }
  }

  void disconnect() {
    if (!_isConnected) return;
    _webSocketService.disconnect();
  }
}
