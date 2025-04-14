import 'dart:convert';
import 'package:projeto_game_quiz/core/api/common/web_socket_api.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/question_response.dart';

class QuestionWebSocketService {
  final String userId;
  final MatchResponse matchInfo;
  final QuestionResponse question;
  late final WebSocketService _webSocketService;

  final void Function(QuestionStats questionStats)? onAllPlayersResponded;

  final void Function(QuestionStats questionStats)? onUpdate;

  final void Function(dynamic error)? onError;

  final void Function()? onDone;

  QuestionWebSocketService({
    required this.matchInfo,
    required this.question,
    required this.userId,
    this.onAllPlayersResponded,
    this.onUpdate,
    this.onError,
    this.onDone,
  });

  void connect() {
    final url =
        '/match/${matchInfo.id}/question/${question.id}/user/${userId}/everyone-who-responded';

    _webSocketService = WebSocketService(
      url: url,
      onMessageReceived: (message) {
        final decodedMessage = jsonDecode(message);
        final questionStats = QuestionStats.fromJson(decodedMessage);

        onUpdate?.call(questionStats);

        final playerQuestionStats = {
          ...?questionStats.erros?.map((e) => e.playerId),
          ...?questionStats.hits?.map((e) => e.playerId),
        }.toList();

        if (playerQuestionStats.length ==
            matchInfo.matchConfiguration?.numberOfPlayers) {
          onAllPlayersResponded?.call(questionStats);
        } else {
          print("Aguardando todos responderem...");
        }
      },
      onError: onError,
      onDone: onDone,
    );

    _webSocketService.connect();
  }

  void disconnect() {
    _webSocketService.disconnect();
  }

}
