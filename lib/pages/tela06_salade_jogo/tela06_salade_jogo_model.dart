import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/pages/tela03_principal/tela03_principal_widget.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
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
import 'tela06_salade_jogo_widget.dart' show Tela06SaladeJogoWidget;

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
  int position = 0;
  bool isLoading = true;
  bool hasStarted = false;
  int secondsRemaining = 10;
  int elapsedSeconds = 0;
  bool isDialogOpen = false;
  bool gameFinished = false;
  bool isButtonDisabled = false;
  int timerMilliseconds = 10000;
  bool isBtnEndGameManually = false;
  int questionsAlreadyPresented = 0;
  int? playersConnected = 0;
  int repeatedQuestionAttempts = 0;
  final int maxRepeatedAttempts = 3;
  bool isDialogFinishingMatchOpen = false;

  String timerValue = StopWatchTimer.getDisplayTime(
    10000,
    hours: false,
    minute: false,
    milliSecond: false,
  );

  String answerOptionId = "";
  String? get selectedOption => radioGroupValueController?.value;

  MatchResponse? matchInfo;
  late MatchResultResponse gameResult;
  late QuestionResponse question;

  QuestionWebSocketService? _questionWebSocketService;
  Timer? countupTimer;
  Timer? countdownTimer;
  Set<String> shownQuestionIds = {};
  late BuildContext currentContext;
  late BuildContext currentDialogFinishingMatchOpenContext;

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
    final timeToRespond =
        matchInfo?.room?.roomConfiguration?.timeToRespond ?? 10;
    secondsRemaining = timeToRespond;
    elapsedSeconds = 0;

    countdownTimer?.cancel();
    countupTimer?.cancel();

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (--secondsRemaining == 0) {
        timer.cancel();
        await sendUserResponseAsync("", setState);
      }
      setState(() {});
    });

    countupTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (++elapsedSeconds == timeToRespond) {
        timer.cancel();
      }
    });
  }

  Future<void> getUserIdAsync(Function setState) async {
    userId = await UserUtil.getUserId();
    setState(() {});
  }

  Future<void> sendUserResponseAsync(
    String optionAnswerId,
    Function setState,
  ) async {
    final result = await _questionService.answerQuestionAsync(
      userId!,
      PlayerAnswerRequest(
        matchId: matchInfo!.id,
        questionId: question.id,
        optionAnswerId: optionAnswerId,
        responseTimeInSecond: elapsedSeconds,
      ),
    );

    if (!result["isSuccess"]) {
      if (result["error"].detail.code != "ERR_QUESTION_NOTFOUND") {
        Warning00ErrorUtil.showDialogMessageError(
          context,
          result["error"].detail.message,
          result["error"].detail.details,
        );
      } else {
        //TODO logica para forçar a proxima questão.
        var forceNextQuestion =
            await _questionService.nextQuestionMatchAsync(matchInfo!.id);
        if (forceNextQuestion["isSuccess"]) {
          await fetchNextQuestionMatchAsync(
              setState, forceNextQuestion["data"]);
        }
      }
    } else {
      await getWebSocketEveryoneWhoRespondedAsync(setState);
    }
  }

  Future<void> fetchNextQuestionMatchAsync(
    Function setState,
    QuestionResponse? nextQuestion,
  ) async {
    if (userId == null || userId == "") await getUserIdAsync(setState);

    var numberTimesDisplayed =
        shownQuestionIds.where((e) => e == nextQuestion!.id);
    while (numberTimesDisplayed.length > 0) {
      if (numberTimesDisplayed.length > 1) {
        countdownTimer?.cancel();
        _questionWebSocketService?.disconnect();

        Warning00ErrorUtil.showDialogMessageError(
          context,
          "Erro ao carregar nova pergunta",
          "Detectamos perguntas repetidas consecutivamente. A partida será finalizada.",
        );

        Navigator.of(context!).pushReplacement(
          MaterialPageRoute(
            builder: (_) => Tela03PrincipalWidget(),
          ),
        );
        return;
      }

      var forceNextQuestion =
          await _questionService.nextQuestionMatchAsync(matchInfo!.id);

      if (!forceNextQuestion["isSuccess"]) {
        // Warning00ErrorUtil.showDialogMessageError(
        //   context,
        //   forceNextQuestion["error"].detail.message,
        //   forceNextQuestion["error"].detail.details,
        // );
        return;
      }

      nextQuestion = forceNextQuestion["data"];
    }

    repeatedQuestionAttempts = 0;
    shownQuestionIds.add(nextQuestion!.id);

    setState(() {
      isLoading = true;
      answerOptionId = "";
      radioGroupValueController?.value = null;
    });

    setState(() {
      question = nextQuestion!;
      isButtonDisabled = false;
      isLoading = false;
    });

    iniciarContadorRegressivo(setState);
  }

  Future<void> getMatchStartNoticeAsync(Function setState) async {
    if (hasStarted) return;

    setState(() => isLoading = true);

    final result = await _matchService.getMatchStartNoticeAsync(matchInfo!.id);

    if (result["isSuccess"]) {
      setState(() => hasStarted = true);
    }
  }

  Future<void> getWebSocketEveryoneWhoRespondedAsync(Function setState) async {
    _questionWebSocketService?.disconnect();

    _questionWebSocketService = QuestionWebSocketService(
      matchInfo: matchInfo!,
      question: question,
      userId: userId!,
      onUpdate: (_) {},
      onWaitingForPlayersResponse: (stats) {
        if (!isDialogOpen) {
          showDialogWaitingPlayer(context!);
        }
      },
      onAllPlayersResponded: (stats) {
        _questionWebSocketService?.disconnect();
        closeDialogWaitingPlayer();

        points += stats.hits
                ?.where((e) => e.playerId == userId)
                .fold(0.0, (sum, e) => sum! + (e.score?.toDouble() ?? 0.0)) ??
            0.0;

        questionsAlreadyPresented = stats.totalQuestionsResponded!;

        if (stats.gameFinished == true) {
          endGameFlow(setState, gameResultFromBackend: stats.gameResult);
        } else if (stats.nextQuestion != null) {
          fetchNextQuestionMatchAsync(setState, stats.nextQuestion);
        }
      },
      onError: (e) {
        print("Erro no WebSocket: $e");
        handleWebSocketFailureIfNeeded(setState);
      },
      onDone: () => print("Conexão WebSocket encerrada."),
    );

    _questionWebSocketService?.connect();
  }

  void showDialogWaitingPlayer(BuildContext context) {
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

  void showDialogFinishingMatch(BuildContext context) {
    if (isDialogFinishingMatchOpen) return;

    isDialogFinishingMatchOpen = true;
    currentDialogFinishingMatchOpenContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("Finalizando a partida..."),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Preparar os resultados da partida, aguardem..."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Fechar"),
          ),
          if (isBtnEndGameManually)
            TextButton(
              onPressed: () async {
                await endGameFlow(() => {});
              },
              child: const Text("Terminar manualmente"),
            ),
        ],
      ),
    );
  }

  void closeDialogWaitingPlayer() {
    if (isDialogOpen && Navigator.canPop(currentContext)) {
      Navigator.of(currentContext).pop();
      isDialogOpen = false;
    }
  }

  void closeDialogEndingGame() {
    if (isDialogFinishingMatchOpen &&
        Navigator.canPop(currentDialogFinishingMatchOpenContext)) {
      Navigator.of(currentDialogFinishingMatchOpenContext).pop();
      isDialogFinishingMatchOpen = false;
    }
  }

  Future<void> endGameFlow(Function setState,
      {dynamic gameResultFromBackend}) async {
    gameFinished = true;
    countdownTimer?.cancel();
    countupTimer?.cancel();
    shownQuestionIds.clear();
    closeDialogWaitingPlayer();
    _questionWebSocketService?.disconnect();

    showDialogFinishingMatch(context!);

    try {
      if (gameResultFromBackend == null) {
        var resultEndGame = await _matchService.endGameAsync(matchInfo!.id);
        if (resultEndGame["isSuccess"]) {
          Navigator.of(context!).pushReplacement(
            MaterialPageRoute(
              builder: (_) => Tela14FimPartidaViewWidget(
                gameResultInfo: resultEndGame["data"],
                matchInfo: matchInfo,
              ),
            ),
          );
        } else {
          closeDialogEndingGame();
          Warning00ErrorUtil.showDialogMessageError(
            context,
            resultEndGame["error"].detail.message,
            resultEndGame["error"].detail.details,
          );
        }
      }

      setState(() => gameResult = gameResultFromBackend);
      closeDialogEndingGame();

      Navigator.of(context!).pushReplacement(
        MaterialPageRoute(
          builder: (_) => Tela14FimPartidaViewWidget(
            gameResultInfo: gameResult,
            matchInfo: matchInfo,
          ),
        ),
      );
    } catch (e) {
      //if(){
      var resultEndGame = await _matchService.endGameAsync(matchInfo!.id);
      if (resultEndGame["isSuccess"]) {
        Navigator.of(context!).pushReplacement(
          MaterialPageRoute(
            builder: (_) => Tela14FimPartidaViewWidget(
              gameResultInfo: resultEndGame["data"],
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
      // closeDialogEndingGame();
      // Warning00ErrorUtil.showDialogMessageError(
      //   context,
      //   "Erro ao finalizar partida",
      //   e.toString(),
      // );
    }
  }

  void handleWebSocketFailureIfNeeded(Function setState) {
    final totalQuestionsToRespond =
        matchInfo?.room?.roomConfiguration?.numberOfQuestions ?? 0;

    if (questionsAlreadyPresented >= totalQuestionsToRespond) {
      setState(() {
        isBtnEndGameManually = true;
      });
    } else {
      Navigator.of(context!).pushReplacement(
        MaterialPageRoute(
          builder: (_) => Tela03PrincipalWidget(),
        ),
      );
    }
  }

  Future<void> inactivatePlayerInMatchAsync() async {
    var result = await _matchService.inactivatePlayerInMatchAsync(
        matchInfo!.id, userId!);

    if(result["isSuccess"]){
      
    }
    else{

    }
  }
}
