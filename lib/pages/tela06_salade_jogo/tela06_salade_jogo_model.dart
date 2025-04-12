import 'dart:async';

import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/common/web_socket_api.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/question_service.dart';
import 'package:projeto_game_quiz/core/api/services/question_web_socket_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/question_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/question_response.dart';
import 'package:projeto_game_quiz/pages/tela12_vitoria_view/tela12_vitoria_view_widget.dart';

import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'tela06_salade_jogo_widget.dart' show Tela06SaladeJogoWidget;
import 'package:flutter/material.dart';

class Tela06SaladeJogoModel extends FlutterFlowModel<Tela06SaladeJogoWidget> {
  final formKey = GlobalKey<FormState>();
  bool isDialogOpen = false;
  late BuildContext currentContext;

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
  String answerOptionId = "";
  int questionsAlreadyPresented = 0;
  late MatchResultResponse gameResult;
  late MatchResponse matchInfo;
  late QuestionResponse question;

  WebSocketService? _webSocketService;
  final _matchService = MatchService();
  QuestionWebSocketService? _questionWebSocketService;
  final _questionService = QuestionService();

  bool hasStarted =
      false; 

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    timerController.dispose();
    _questionWebSocketService?.disconnect();
  }

  String? get selectedOption => radioGroupValueController?.value;

  Timer? countdownTimer;
  int secondsRemaining = 10;

  void iniciarContadorRegressivo(Function setState) {
    secondsRemaining = timerMilliseconds ~/ 1000;

    countdownTimer?.cancel();

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        setState(() {});
      } else {
        timer.cancel();
        
      }
    });
  }

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
        responseTimeInSecond:
            (timerController.timer.rawTime.value / 1000).round(),
      ),
    );

    if (resultAnswerQuestion["isSuccess"]) {
      await getWebSocketEveryoneWhoRespondedAsync(setState);
    } else {
      Navigator.of(context!).pop();
    }
  }

  Future<void> fetchNextQuestionMatchAsync(Function setState) async {
    setState(() {
      isLoading = true;
      answerOptionId = "";
      radioGroupValueController?.value = null; 
    });

    if (questionsAlreadyPresented ==
            matchInfo.matchConfiguration!.numberOfQuestions &&
        !matchInfo.matchConfiguration!.isEvent!) {
      var result = await _matchService.endGameAsync(matchInfo.id);

      if (result["isSuccess"]) {
        setState(() {
          gameResult = result["data"];
        });
        Navigator.of(context!).push(
          MaterialPageRoute(
            builder: (_) => Tela12VitoriaViewWidget(),
          ),
        );
      } else {
        Warning00ErrorUtil.showDialogMessageError(
          context,
          result["error"].detail.message,
          result["error"].detail.details,
        );
      }
    } else {
      var resultQuestion =
          await _questionService.nextQuestionMatchAsync(matchInfo.id);

      if (resultQuestion["isSuccess"]) {
        setState(() {
          question = resultQuestion["data"];
          questionsAlreadyPresented += 1;
          isLoading = false;
        });

        iniciarContadorRegressivo(setState);
        _webSocketService?.disconnect();
      } else {
        Warning00ErrorUtil.showDialogMessageError(
          context,
          resultQuestion["error"].detail.message,
          resultQuestion["error"].detail.details,
        );
      }
    }
  }

  Future<void> getMatchStartNoticeAsync(Function setState) async {
    if (hasStarted) return; // Verificando se já foi chamado antes de executar

    setState(() {
      isLoading = true;
    });

    var resultQuestion =
        await _matchService.getMatchStartNoticeAsync(matchInfo.id);

    if (resultQuestion["isSuccess"]) {
      setState(() {
        hasStarted = true; // Marca como iniciado para evitar chamadas futuras
      });
    } else {
      // Se necessário, tratar falha
    }
  }

  Future<void> getWebSocketEveryoneWhoRespondedAsync(Function setState) async {
    // Garante que a conexão anterior seja encerrada
    _questionWebSocketService?.disconnect();

    mostrarDialogAguardando(context!); // Mostra o diálogo de espera

    _questionWebSocketService = QuestionWebSocketService(
      matchInfo: matchInfo,
      question: question,
      userId: userId!,
      onUpdate: (stats) {
        // atualizações intermediárias, se desejar
      },
      onAllPlayersResponded: (stats) {
        _questionWebSocketService?.disconnect();

        fecharDialogoAguardando();

        points += stats.hits
                ?.where((e) => e.playerId == userId)
                .fold(0.0, (sum, e) => sum! + (e.score?.toDouble() ?? 0.0)) ??
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

    _questionWebSocketService?.connect();
  }

  void fecharDialogoAguardando() {
    if (isDialogOpen && Navigator.canPop(currentContext)) {
      Navigator.of(currentContext).pop();
      isDialogOpen = false;
    }
  }

  void mostrarDialogAguardando(BuildContext context) {
    if (isDialogOpen) return;

    isDialogOpen = true;
    currentContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Aguardando jogadores..."),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Esperando todos responderem a pergunta..."),
          ],
        ),
      ),
    );
  }
}
