import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';
import 'package:projeto_game_quiz/pages/tela03_principal/tela03_principal_widget.dart';
import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/question_service.dart';
import 'package:projeto_game_quiz/core/api/services/question_web_socket_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/question_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/question_response.dart';
import 'package:projeto_game_quiz/pages/tela14_fim_partida/tela14_fim_partida_widget.dart';

import '/flutter_flow/form_field_controller.dart';
import 'tela06_salade_jogo_widget.dart' show Tela06SaladeJogoWidget;

class Tela06SaladeJogoModel extends FlutterFlowModel<Tela06SaladeJogoWidget> {
  final formKey = GlobalKey<FormState>();
  final _matchService = MatchService();
  final _questionService = QuestionService();

  double points = 0;
  String? userId = '';
  bool isLoading = true;
  int? playersConnected;
  int elapsedSeconds = 0;
  int secondsRemaining = 10;
  String answerOptionId = "";
  String? lastQuestionHandled;
  bool isButtonDisabled = false;
  int questionsAlreadyPresented = 0;
  FormFieldController<String>? radioGroupValueController;

  MatchResponse? matchInfo;
  QuestionResponse? question;

  QuestionWebSocketService? _questionWebSocketService;
  Timer? countdownTimer;
  Timer? countupTimer;
  Timer? safetyTimeout;
  bool isDialogOpen = false;
  bool gameFinished = false;
  BuildContext? currentContext;

  void initState(BuildContext context) {
    currentContext = context;
  }

  void dispose() {
    countdownTimer?.cancel();
    countupTimer?.cancel();
    //_questionWebSocketService?.disconnect();
  }

  void cancelarTimers() {
    countdownTimer?.cancel();
    countupTimer?.cancel();
  }

  Future<void> getUserIdAsync() async {
    userId = await UserUtil.getUserId();
  }

  Future<void> sendUserResponseAsync(
      String optionAnswerId, Function setState) async {
    final result = await _questionService.answerQuestionAsync(
      userId!,
      PlayerAnswerRequest(
        matchId: matchInfo!.id,
        questionId: question!.id,
        optionAnswerId: optionAnswerId,
        responseTimeInSecond: elapsedSeconds,
      ),
    );

    if (!result["isSuccess"] &&
        result["error"].detail.code != "ERR_QUESTION_NOTFOUND") {
      if (result["error"].detail.code == "ERR_MATCH_PLAYER_INATIVE") {
        Navigator.of(currentContext!).push(
          MaterialPageRoute(builder: (_) => Tela03PrincipalWidget()),
        );
        return;
      }
      Warning00ErrorUtil.showDialogMessageError(
        currentContext!,
        result["error"].detail.message,
        result["error"].detail.details,
      );
      return;
    }

    //await getWebSocketEveryoneWhoRespondedAsync(setState);
    //  _questionWebSocketService?.sendAnswerToWebSocket(PlayerAnswerRequest(
    //     matchId: matchInfo!.id,
    //     questionId: question!.id,
    //     optionAnswerId: optionAnswerId,
    //     responseTimeInSecond: secondsRemaining,
    //   ));
  }

  Future<void> setupGame(
      Function setState, QuestionResponse? nextQuestion) async {
    await fetchNextQuestionMatchAsync(setState, nextQuestion);
    await getWebSocketEveryoneWhoRespondedAsync(setState);
  }

  Future<void> fetchNextQuestionMatchAsync(
      Function setState, QuestionResponse? nextQuestion) async {
    if (userId == null || userId!.isEmpty) await getUserIdAsync();

    setState(() {
      isLoading = true;
      answerOptionId = "";
      radioGroupValueController?.value = null;
    });

    if (nextQuestion != null) {
      setState(() {
        question = nextQuestion;
        isButtonDisabled = false;
        isLoading = false;
      });
      _startCountdownTimer(setState);
    }
  }

  void _startCountdownTimer(Function setState) {
    final timeToRespond =
        matchInfo?.room?.roomConfiguration?.timeToRespond ?? 10;
    elapsedSeconds = 0;
    secondsRemaining = timeToRespond;

    countdownTimer?.cancel();
    countupTimer?.cancel();

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (--secondsRemaining == 0) {
        showDialogWaitingPlayer(currentContext!);
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

  Future<void> getWebSocketEveryoneWhoRespondedAsync(Function setState) async {
    //_questionWebSocketService?.disconnect();
    _questionWebSocketService = QuestionWebSocketService(
        matchInfo: matchInfo!,
        question: question!,
        userId: userId!,
        onWaitingForPlayersResponse: (stats) {
          closeDialogWaitingPlayer();
          showDialogWaitingPlayer(currentContext!);

          safetyTimeout = Timer(const Duration(seconds: 60), () {
            if (!gameFinished) {
              _questionWebSocketService?.disconnect();
              Navigator.of(currentContext!).push(
                MaterialPageRoute(builder: (_) => Tela03PrincipalWidget()),
              );
            }
          });
        },
        onAllPlayersResponded: (stats) async {
          safetyTimeout?.cancel();
          if (stats.gameFinished!) {
            print("estou para terminar");
          }

          if (stats.nextQuestion != null) {
            if (lastQuestionHandled == stats.nextQuestion!.id &&
                !stats.gameFinished!) {
              try {
                await _questionService.removeQuestionForMatchAsync(
                    matchInfo!.id, stats.nextQuestion!.id);
              } catch (e) {
                print("[WARN] - Ocorreu erro ao deletar a questão da partida ");
              }
              return;
            }
          }

          lastQuestionHandled =
              stats.gameFinished! ? stats.questionId : stats.nextQuestion!.id;

          setState(() {
            points += stats.hits?.where((e) => e.playerId == userId).fold(
                    0.0, (sum, e) => sum! + (e.score?.toDouble() ?? 0.0)) ??
                0.0;
          });
          closeDialogWaitingPlayer();
          questionsAlreadyPresented = stats.totalQuestionsResponded!;

          if (stats.gameFinished!) {
            gameFinished = true;
            await endGameFlow(setState,
                gameResultFromBackend: stats.gameResult);
          } else if (stats.nextQuestion != null) {
            await fetchNextQuestionMatchAsync(setState, stats.nextQuestion);
          }
        },
        onError: (e) {
          if (!gameFinished) {
            closeDialogWaitingPlayer();
            showDialogErrorAndExit(
                "Erro de conexão", "Perdemos a conexão com o servidor.");
          }
        },
        onDone: () async {
          print("Conexão WebSocket encerrada.");

          if (!gameFinished) {
            await _questionWebSocketService?.tryReconnect();
            if (!_questionWebSocketService!.isConnected) {
              closeDialogWaitingPlayer();
              showDialogErrorAndExit(
                "Conexão encerrada",
                "O servidor foi desconectado e não foi possível reconectar.",
              );
            }
          }
        });

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
        title: const Text("Aguardando jogadores..."),
        content: const Column(
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
              _questionWebSocketService?.disconnect();
              Navigator.of(currentContext!).push(
                MaterialPageRoute(builder: (_) => Tela03PrincipalWidget()),
              );
            },
            child: const Text("Sair"),
          ),
        ],
      ),
    );
  }

  void closeDialogWaitingPlayer() {
    if (isDialogOpen && Navigator.canPop(currentContext!)) {
      Navigator.of(currentContext!).pop();
      isDialogOpen = false;
    }
  }

  Future<void> endGameFlow(Function setState,
      {dynamic gameResultFromBackend}) async {
    gameFinished = true;
    cancelarTimers();
    closeDialogWaitingPlayer();
    if (gameResultFromBackend == null) {
      var resultEndGame = await _matchService.endGameAsync(matchInfo!.id);
      if (resultEndGame["isSuccess"]) {
        gameResultFromBackend = resultEndGame["data"];
      }
    }

    Navigator.of(currentContext!).pushReplacement(
      MaterialPageRoute(
        builder: (_) => Tela14FimPartidaViewWidget(
          gameResultInfo: gameResultFromBackend,
          matchInfo: matchInfo,
        ),
      ),
    );
  }

  Future<void> inactivatePlayerInMatchAsync() async {
    await _matchService.inactivatePlayerInMatchAsync(matchInfo!.id, userId!);
  }

  void showDialogErrorAndExit(String title, String message) {
    showDialog(
      context: currentContext!,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              _questionWebSocketService!.disconnect();
              Navigator.of(currentContext!).push(
                MaterialPageRoute(builder: (_) => Tela03PrincipalWidget()),
              );
            },
            child: const Text("Voltar ao início"),
          ),
        ],
      ),
    );
  }
}
