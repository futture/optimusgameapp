import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_web_socket_service.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/api/utils/super_match_util.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/common/error_response.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/question_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/dialogs/common_dialog_widget.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/pages/tela06_salade_jogo/tela06_salade_jogo_widget.dart';
import 'package:projeto_game_quiz/pages/tela13_dados_de_partida/tela13_dados_de_partida_widget.dart';

class NotificationHandler {
  final UserService _userService = UserService();
  final MatchService _matchService = MatchService();

  Future<void> subscribeToMatchTopic(String topic, String matchId) async {
    try {
      final topicName = "${topic}_$matchId";
      await FirebaseMessaging.instance.subscribeToTopic(topicName);
      debugPrint('Subscribed to match topic: $topicName');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
      rethrow;
    }
  }

  void setupNotificationHandlers() {
    print("Cheguei  ......");
    _setupForegroundNotificationHandler();
    _setupBackgroundNotificationHandler();
  }

  void _setupForegroundNotificationHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        await _handleNotification(message);
      } catch (e) {
        debugPrint('Error handling foreground notification: $e');
      }
    });
  }

  void _setupBackgroundNotificationHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      try {
        await _handleNotification(message, isBackground: true);
      } catch (e) {
        debugPrint('Error handling background notification: $e');
      }
    });
  }

  Future<void> _handleNotification(
    RemoteMessage message, {
    bool isBackground = false,
  }) async {
    if (!message.data.containsKey('matchId') ||
        !message.data.containsKey('action')) {
      return;
    }

    final context = appNavigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final currentUser = await UserUtil.getUserInfo();
      final matchId = message.data['matchId'];
      final action = message.data['action'];

      final matchInfo = await _matchService.getMatchByMatchIdAsync(matchId);
      final participants = await _getPlayerByMatchId(matchId);

      Navigator.of(context).pop();

      switch (action) {
        case 'START_TO_MATCH_SCHEDULED':
          await _handleMatchStart(context, message.data, matchInfo);
          break;
        case 'TO_JOIN_THE_MATCH':
          //Navigator.of(context).pop();
          await _handleJoinMatch(context, currentUser, matchInfo, participants);
          break;
        case 'ERR_START_TO_MATCH_SCHEDULED':
          //Navigator.of(context).pop();
          await _handleMatchStartError(
              context, currentUser, message.data, matchInfo, participants);
          break;
        case 'SCHEDULED_MATCH_WILL_BEGIN':
          //Navigator.of(context).pop();
          await _handleMatchWillBegin(
              context, currentUser, matchInfo, participants);
          break;
        case 'SCHEDULED_MATCH_START':
          MatchResponse _match = matchInfo["data"];
          await handlerScheduledMatchStart(
              context, _match, participants, currentUser);
          await SuperMatchUtil.savePreference(_match.id);
          await startScheduledSatchAsync(context, () {}, _match, currentUser);
          break;
        case 'DISQUALIFIED_FROM_MATCH':
          if (isBackground) {
            //Navigator.of(context).pop();
            await _handleDisqualification(
                context, currentUser, matchInfo, participants);
          }
          break;
        default:
          debugPrint('Unknown notification action: $action');
      }
    } catch (e) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      debugPrint('Error processing notification (): $e');
      _showGenericErrorDialog(context);
    }
  }

  Future<void> _handleMatchStart(
    BuildContext context,
    Map<String, dynamic> data,
    Map<String, dynamic> matchInfo,
  ) async {
    final decodedMessage = jsonDecode(data['nextQuestion']);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Tela06SaladeJogoWidget(
          matchInfo: matchInfo['data'],
          recebeuNotificaca: true,
          nextQuestion: QuestionResponse.fromJson(decodedMessage),
        ),
      ),
    );
  }

  Future<void> _handleJoinMatch(
    BuildContext context,
    UserResponse? currentUser,
    Map<String, dynamic> matchInfo,
    List<UserResponse> participants,
  ) async {
    final isPending = matchInfo['data']?.statusMatch == 'PENDING';

    DadosDaPartidaUtils.showMatchParticipantsDialog(
      ctx: context,
      currentUser: currentUser,
      matchInfo: matchInfo['data']!,
      participants: participants,
      timeCloseDialog: 30,
      widget: isPending
          ? null
          : _buildMatchStatusMessage(
              context,
              title: 'Partida terminada...',
              message: 'Partida já fechada',
            ),
    );
  }

  Future<void> _handleMatchStartError(
    BuildContext context,
    UserResponse? currentUser,
    Map<String, dynamic> data,
    Map<String, dynamic> matchInfo,
    List<UserResponse> participants,
  ) async {
    final decodedMessageErr = jsonDecode(data['error']);
    final error = DetailErrorResponse.fromJson(decodedMessageErr);

    DadosDaPartidaUtils.showMatchParticipantsDialog(
        ctx: context,
        title: 'Super Partida',
        currentUser: currentUser,
        matchInfo: matchInfo['data']!,
        participants: participants,
        timeCloseDialog: 50,
        widget: _buildErrorWidget(context, error),
        isError: true);
  }

  Future<void> _handleMatchWillBegin(
    BuildContext context,
    UserResponse? currentUser,
    Map<String, dynamic> matchInfo,
    List<UserResponse> participants,
  ) async {
    DadosDaPartidaUtils.showMatchParticipantsDialog(
        ctx: context,
        title: 'Super Partida',
        currentUser: currentUser,
        matchInfo: matchInfo['data']!,
        participants: participants,
        widget: _buildMatchStatusMessage(
          context,
          title: 'Partida começa em breve...',
          message: 'Fique atento para não perder',
        ),
        doNotDisplayButton: true,
        isProgressBar: true);
  }

  Future<void> _handleDisqualification(
    BuildContext context,
    UserResponse? currentUser,
    Map<String, dynamic> matchInfo,
    List<UserResponse> participants,
  ) async {
    DadosDaPartidaUtils.showMatchParticipantsDialog(
      ctx: context,
      isError: true,
      currentUser: currentUser,
      matchInfo: matchInfo['data']!,
      participants: participants,
      widget: _buildMatchStatusMessage(
        context,
        title: 'Jogador desqualificado...',
        message: 'Jogador desqualificado por inatividade',
      ),
    );
  }

  Widget _buildMatchStatusMessage(BuildContext context,
      {required String title, required String message, bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          if (isError)
            Icon(
              Icons.sentiment_very_dissatisfied,
              color: Colors.red,
              size: 40,
            ),
          const SizedBox(height: 8),
          Text(
            title,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: isError ? Colors.red : const Color(0xFFEC8D0D),
                  fontSize: isError ? 20 : 14,
                  letterSpacing: 0,
                ),
          ),
          Text(
            message,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, DetailErrorResponse error) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Icon(
            Icons.sentiment_very_dissatisfied,
            color: Colors.red,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            error.detail?.message ?? 'Ocorreu um erro',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: Colors.red,
                  fontSize: 20,
                  letterSpacing: 0,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error.detail?.details ?? 'Tente novamente mais tarde',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showGenericErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: const Text('Ocorreu um erro ao processar a notificação'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<List<UserResponse>> _getPlayerByMatchId(String matchId) async {
    try {
      final result = await _userService.getPlayerByMatchIdAsync(matchId);
      return result['isSuccess'] ? result['data'] : <UserResponse>[];
    } catch (e) {
      debugPrint('Error getting players by match ID: $e');
      return <UserResponse>[];
    }
  }

  Future<void> handlerScheduledMatchStart(
      BuildContext context,
      MatchResponse matchInfo,
      List<UserResponse> participants,
      UserResponse? currentUser) async {
    final minimumAmount =
        matchInfo.room?.roomConfiguration?.minimumAmountToPlay ?? 0;
    var infos = [
      {
        'title': 'Inscrição',
        'icon': Icons.attach_money,
        'value': '${minimumAmount}KZ',
      },
      {
        'title': 'Prêmio',
        'icon': Icons.wine_bar_rounded,
        'value': '${matchInfo.matchPrize?.totalGain ?? 0} KZ',
      },
      {
        'title': 'Nº Questões',
        'icon': Icons.numbers,
        'value': '${matchInfo.room!.roomConfiguration!.numberOfQuestions}',
      },
      {
        'title': 'Vagas',
        'icon': Icons.people,
        'value':
            '${matchInfo.matchPlayers?.length ?? 0}/${matchInfo.room?.roomConfiguration?.numberOfPlayers ?? 0}',
      },
    ];

    CommonDialogWidget.showMatchParticipantsDialog(
        context,
        infos,
        null,
        matchInfo,
        participants,
        currentUser,
        _buildDialogActions(context, participants, matchInfo),
        timeCloseDialog: 60,
        isProgressBar: false);
  }

  Widget _buildDialogActions(
      BuildContext context, List<UserResponse> parts, MatchResponse matchInfo) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFFEC8D0D),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aguardando participantes...',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: const Color(0xFFEC8D0D),
                        fontSize: 14,
                        letterSpacing: 0,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Participantes conectados: ${parts.length}/${matchInfo.room!.roomConfiguration!.numberOfPlayers}',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Inter',
                        letterSpacing: 0,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> startScheduledSatchAsync(BuildContext context, Function setState,
      MatchResponse match, UserResponse? currentUser) async {
    var _matchWebSocketService = MatchWebSocketService(
      userId: currentUser!.id,
      matchInfo: match,
      context: context,
      matchId: match.id,
      onScheduledMatchUpdate: (stats) {
        if (stats.error != null && stats.error!.detail != null) {
          _showErrorDialog(stats.error, match.id);
        } else {
          final isUserInMatch = stats.players?.contains(currentUser.id);
          if (isUserInMatch!) {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => Tela06SaladeJogoWidget(
                  matchInfo: match,
                  nextQuestion: stats.nextQuestion,
                ),
              ),
            );
          } else {
            debugPrint("Usuário não está na lista de jogadores desta partida.");
          }
        }
      },
      onError: (e) {
        handleWebSocketFailureIfNeeded(() => {});
        debugPrint("Erro no WebSocket: $e");
      },
      onDone: () {
        debugPrint("Conexão WebSocket encerrada.");
      },
    );

    _matchWebSocketService.connectStartScheduledSatch();
  }

  void handleWebSocketFailureIfNeeded(Function setState) {
    //   final totalQuestionsToRespond =
    //       matchInfo?.room?.roomConfiguration?.numberOfQuestions ?? 0;

    //   if (questionsAlreadyPresented >= totalQuestionsToRespond) {
    //     setState(() {
    //       isBtnEndGameManually = true;
    //     });
    //   } else {
    //     Navigator.of(context!).pushReplacement(
    //       MaterialPageRoute(
    //         builder: (_) => Tela03PrincipalWidget(),
    //       ),
    //     );
    //     //Navigator.of(context!).popUntil((route) => route.isFirst);
    //   }
  }

  void _showErrorDialog(error, matchId) {
    if (error == null) return;
    if (error.detail == null) return;
  }

  void closeDialogStartScheduledMatch() {}
//TODO endregion start super match
}
