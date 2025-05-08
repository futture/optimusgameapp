import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
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
  int currentposition = 0;
  String answerOptionId = "";
  String? lastQuestionHandled;
  bool isButtonDisabled = false;
  int questionsAlreadyPresented = 0;
  Map<String, double> totalScorePerPlayer = {};

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
    safetyTimeout?.cancel();
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
    await fetchNextQuestionMatchAsync(setState, nextQuestion, 0);
    await getWebSocketEveryoneWhoRespondedAsync(setState);
  }

  Future<void> fetchNextQuestionMatchAsync(
      Function setState, QuestionResponse? nextQuestion, pts) async {
    if (userId == null || userId!.isEmpty) await getUserIdAsync();

    setState(() {
      isLoading = true;
      answerOptionId = "";
      radioGroupValueController?.value = null;
    });

    final _currentposition = getPlayerPosition(userId!, totalScorePerPlayer);

    if (nextQuestion != null) {
      setState(() {
        question = nextQuestion;
        isButtonDisabled = false;
        isLoading = false;
        points += pts;
        currentposition = _currentposition;
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

          if (safetyTimeout?.isActive ?? false) {
            safetyTimeout?.cancel();
          }

          safetyTimeout = Timer(const Duration(seconds: 120), () {
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

          var pts = stats.hits
                  ?.where((e) => e.playerId == userId)
                  .fold(0.0, (sum, e) => sum + (e.score?.toDouble() ?? 0.0)) ??
              0.0;
          print("[INFO] - Pontos: ${pts}");
          for (var hit in stats.hits ?? []) {
            final playerId = hit.playerId;
            final score = hit.score?.toDouble() ?? 0.0;

            if (totalScorePerPlayer.containsKey(playerId)) {
              totalScorePerPlayer[playerId] =
                  totalScorePerPlayer[playerId]! + score;
            } else {
              totalScorePerPlayer[playerId] = score;
            }
          }

          closeDialogWaitingPlayer();
          questionsAlreadyPresented = stats.totalQuestionsResponded!;

          if (stats.gameFinished!) {
            gameFinished = true;
            await endGameFlow(setState,
                gameResultFromBackend: stats.gameResult);
          } else if (stats.nextQuestion != null) {
            await fetchNextQuestionMatchAsync(
                setState, stats.nextQuestion, pts);
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
      barrierColor: Colors.black54,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.all(40),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF01BF01),
                  FlutterFlowTheme.of(context).secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 8,
                      ),
                      Icon(
                        Icons.people_alt_rounded,
                        size: 36,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.95, end: 1.05),
                  duration: const Duration(seconds: 1),
                  //repeat: true,
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Text(
                        "Aguardando Jogadores",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAnimatedDot(0),
                    _buildAnimatedDot(1),
                    _buildAnimatedDot(2),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  "Esperando todos responderem...",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    _questionWebSocketService?.disconnect();
                    Navigator.of(currentContext!).push(
                      MaterialPageRoute(
                          builder: (_) => Tela03PrincipalWidget()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "SAIR DA PARTIDA",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedDot(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Duration(milliseconds: 600 + (index * 200)),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
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
        builder: (_) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () {
                      _questionWebSocketService!.disconnect();
                      Navigator.of(currentContext!).push(
                        MaterialPageRoute(
                            builder: (_) => Tela03PrincipalWidget()),
                      );
                    },
                    child: const Text("Voltar ao início"),
                  ),
                ],
              ),
            ));
  }

  int getPlayerPosition(String userId, Map<String, double> ranking) {
    final orderedList = ranking.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (int i = 0; i < orderedList.length; i++) {
      if (orderedList[i].key == userId) {
        return i + 1;
      }
    }
    return -1;
  }
}
