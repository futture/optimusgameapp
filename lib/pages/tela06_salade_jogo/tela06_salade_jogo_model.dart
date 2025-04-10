import 'package:projeto_game_quiz/core/api/common/web_socket_api.dart';
import 'package:projeto_game_quiz/core/api/services/question_service.dart';
import 'package:projeto_game_quiz/core/api/services/question_web_socket_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/question_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/question_response.dart';

import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'tela06_salade_jogo_widget.dart' show Tela06SaladeJogoWidget;
import 'package:flutter/material.dart';

class Tela06SaladeJogoModel extends FlutterFlowModel<Tela06SaladeJogoWidget> {
  final formKey = GlobalKey<FormState>();

  final timerInitialTimeMs = 10000;
  int timerMilliseconds = 10000;
  String timerValue = StopWatchTimer.getDisplayTime(
    10000,
    hours: false,
    minute: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  FormFieldController<String>? radioGroupValueController;

  String? userId = '';
  double points = 0;
  bool isLoading = true;
  int questionsAlreadyPresented = 0;

  late MatchResponse matchInfo;
  late QuestionResponse question;

  WebSocketService? _webSocketService;
  late final QuestionWebSocketService _questionWebSocketService;
  final _questionService = QuestionService();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    timerController.dispose();
    _questionWebSocketService.disconnect();
  }

  String? get selectedOption => radioGroupValueController?.value;

  Future<void> getUserIdAsync(Function setState) async {
    userId = await UserUtil.getUserId();
    setState(() {});
  }

  Future<void> sendUserResponseAsync(
      String optionAnswerId, Function setState) async {
    var resultAnswerQuestion = await _questionService.answerQuestionAsync(
      userId!,
      PlayerAnswerRequest(
        matchId: matchInfo.id,
        questionId: question.id,
        optionAnswerId: optionAnswerId,
        answeredAt: DateTime.now().add(Duration(seconds: 10)),
      ),
    );

    if (resultAnswerQuestion["isSuccess"]) {
      await getWebSocketEveryoneWhoRespondedAsync(setState);
    }
  }

  Future<void> fetchNextQuestionMatchAsync(Function setState) async {
    setState(() {
      isLoading = true;
    });

    var resultQuestion =
        await _questionService.nextQuestionMatchAsync(matchInfo.id);

    if (resultQuestion["isSuccess"]) {
      question = resultQuestion["data"];
      questionsAlreadyPresented += 1;
      isLoading = false;
      _webSocketService?.disconnect();
      setState(() {});
    }
  }

  Future<void> getWebSocketEveryoneWhoRespondedAsync(Function setState) async {
    _questionWebSocketService = QuestionWebSocketService(
      matchInfo: matchInfo,
      question: question,
      userId: userId!,
      onUpdate: (stats) {
        // opcional
      },
      onAllPlayersResponded: (stats) {
        points += stats.hits
                ?.where((e) => e.playerId == userId)
                .fold(0.0, (sum, e) => sum! + (e.score ?? 0.0)) ??
            0.0;

        fetchNextQuestionMatchAsync(setState);
      },
      onError: (error) {
        print("Erro no WebSocket: $error");
      },
      onDone: () {
        print("Conexão WebSocket encerrada.");
      },
    );

    _questionWebSocketService.connect();
  }
}
