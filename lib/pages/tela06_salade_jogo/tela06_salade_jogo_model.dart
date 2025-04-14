import 'dart:async';
import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/question_service.dart';
import 'package:projeto_game_quiz/core/api/services/question_web_socket_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/question_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/question_response.dart';
import 'package:projeto_game_quiz/pages/tela14_fim_partida/tela14_fim_partida_widget.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'tela06_salade_jogo_widget.dart' show Tela06SaladeJogoWidget;
import 'package:flutter/material.dart';

class Tela06SaladeJogoModel extends FlutterFlowModel<Tela06SaladeJogoWidget> {
  final formKey = GlobalKey<FormState>();
  final _matchService = MatchService();
  final _questionService = QuestionService();

  FlutterFlowTimerController timerController = FlutterFlowTimerController(
    StopWatchTimer(mode: StopWatchMode.countDown),
  );

  FormFieldController<String>? radioGroupValueController;

  String? userId = '';
  double points = 0;
  bool isLoading = true;
  bool hasStarted = false;
  bool isDialogOpen = false;
  bool gameFinished = false;

  int timerMilliseconds = 10000;
  int secondsRemaining = 10;
  int questionsAlreadyPresented = 0;

  String timerValue = StopWatchTimer.getDisplayTime(
    10000,
    hours: false,
    minute: false,
    milliSecond: false,
  );

  String answerOptionId = "";
  String? get selectedOption => radioGroupValueController?.value;

  late MatchResponse matchInfo;
  late MatchResultResponse gameResult;
  late QuestionResponse question;

  QuestionWebSocketService? _questionWebSocketService;
  Timer? countdownTimer;
  late BuildContext currentContext;

  @override
  void initState(BuildContext context) {
    currentContext = context;
    getUserIdAsync((_) {});
  }

  @override
  void dispose() {
    timerController.dispose();
    _questionWebSocketService?.disconnect();
  }

  void iniciarContadorRegressivo(Function setState) {
    secondsRemaining = timerMilliseconds ~/ 1000;
    countdownTimer?.cancel();

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (--secondsRemaining <= 0) {
        timer.cancel();
        await sendUserResponseAsync("", setState);
      }
      setState(() {});
    });
  }

  Future<void> getUserIdAsync(Function setState) async {
    userId = await UserUtil.getUserId();
    setState(() {});
  }

  Future<void> sendUserResponseAsync(
      String optionAnswerId, Function setState) async {
    final result = await _questionService.answerQuestionAsync(
      userId!,
      PlayerAnswerRequest(
        matchId: matchInfo.id,
        questionId: question.id,
        optionAnswerId: optionAnswerId,
        responseTimeInSecond:
            (timerController.timer.rawTime.value / 1000).round(),
      ),
    );

    if (result["isSuccess"]) {
      await getWebSocketEveryoneWhoRespondedAsync(setState);
    } else {
      Warning00ErrorUtil.showDialogMessageError(
        context,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }

  Future<void> fetchNextQuestionMatchAsync(Function setState) async {
    if (gameFinished) return;
    setState(() {
      isLoading = true;
      answerOptionId = "";
      radioGroupValueController?.value = null;
    });

    questionsAlreadyPresented += 1;

    if (questionsAlreadyPresented >
            matchInfo.matchConfiguration!.numberOfQuestions &&
        !matchInfo.matchConfiguration!.isEvent!) {
      gameFinished = true;
      await endGameFlow(setState);
      return;
    }

    final result = await _questionService.nextQuestionMatchAsync(matchInfo.id);

    if (result["isSuccess"]) {
      setState(() {
        question = result["data"];
        isLoading = false;
      });
      iniciarContadorRegressivo(setState);
    } else {
      Warning00ErrorUtil.showDialogMessageError(
        context,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }

  Future<void> getMatchStartNoticeAsync(Function setState) async {
    if (hasStarted) return;

    setState(() => isLoading = true);

    final result = await _matchService.getMatchStartNoticeAsync(matchInfo.id);

    if (result["isSuccess"]) {
      setState(() => hasStarted = true);
    }
  }

  Future<void> getWebSocketEveryoneWhoRespondedAsync(Function setState) async {
    mostrarDialogAguardando(context!);

    _questionWebSocketService = QuestionWebSocketService(
      matchInfo: matchInfo,
      question: question,
      userId: userId!,
      onUpdate: (_) {},
      onAllPlayersResponded: (stats) {
        _questionWebSocketService?.disconnect();

        fecharDialogoAguardando();

        if (!gameFinished) {
          points += stats.hits
                  ?.where((e) => e.playerId == userId)
                  .fold(0.0, (sum, e) => sum! + (e.score?.toDouble() ?? 0.0)) ??
              0.0;

          fetchNextQuestionMatchAsync(setState);
        }
      },
      onError: (e) => print("Erro no WebSocket: $e"),
      onDone: () => print("Conexão WebSocket encerrada."),
    );

    _questionWebSocketService?.connect();
  }

  void mostrarDialogAguardando(BuildContext context) {
    if (isDialogOpen) return;

    isDialogOpen = true;
    currentContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("Aguardando jogadores..."),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Esperando todos responderem a pergunta..."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _questionWebSocketService?.disconnect();
            },
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  void fecharDialogoAguardando() {
    if (isDialogOpen && Navigator.canPop(currentContext)) {
      Navigator.of(currentContext).pop();
      isDialogOpen = false;
    }
  }

  Future<void> endGameFlow(Function setState) async {
    gameFinished = true;
    countdownTimer?.cancel();
    fecharDialogoAguardando();
    _questionWebSocketService?.disconnect();

    final resultEndGame = await _matchService.endGameAsync(matchInfo.id);
    if (resultEndGame["isSuccess"]) {
      setState(() => gameResult = resultEndGame["data"]);
      Navigator.of(context!).pushReplacement(
        MaterialPageRoute(
          builder: (_) => Tela14FimPartidaViewWidget(
            gameResultInfo: gameResult,
            matchInfo: matchInfo,
          ),
        ),
      );
    } else {
      Warning00ErrorUtil.showDialogMessageError(
        context,
        resultEndGame["error"].detail.message,
        resultEndGame["error"].detail.details,
      );
    }
  }
}
