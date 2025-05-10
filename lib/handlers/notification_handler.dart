import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/common/error_response.dart';
import 'package:projeto_game_quiz/core/models/responses/question_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/pages/tela06_salade_jogo/tela06_salade_jogo_widget.dart';
import 'package:projeto_game_quiz/pages/tela13_dados_de_partida/tela13_dados_de_partida_widget.dart';

class NotificationHandler {
  final UserService _userService = UserService();
  final MatchService _matchService = MatchService();

  /// Subscreve para tópicos de notificação de partida
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

  /// Configura os handlers para notificações recebidas
  void setupNotificationHandlers() {
    print(
        "Cheguei dfffffffffffffffffffffffffffffffffffffffffffffffffff fd       dfffffffffffffffffffffffffffff");
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
          await _handleJoinMatch(context, currentUser, matchInfo, participants);
          break;
        case 'ERR_START_TO_MATCH_SCHEDULED':
          await _handleMatchStartError(
              context, currentUser, message.data, matchInfo, participants);
          break;
        case 'SCHEDULED_MATCH_WILL_BEGIN':
          await _handleMatchWillBegin(
              context, currentUser, matchInfo, participants);
          break;
        case 'DISQUALIFIED_FROM_MATCH':
          await _handleDisqualification(
              context, currentUser, matchInfo, participants);
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
    );
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
}
