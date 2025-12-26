import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';

class CommonDialogWidget {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/alert.wav'));
    } catch (e) {
      debugPrint('Erro ao reproduzir som: $e');
    }
  }

  static void showMatchParticipantsDialog(
      BuildContext context,
      List<dynamic> infos,
      String? title,
      MatchResponse match,
      List<UserResponse> participants,
      UserResponse? currentUser,
      Widget widget,
      {bool? isError,
      int timeCloseDialog = 10,
      bool isProgressBar = true,
      bool isPlaySound = true}) async {
    if (currentUser == null) return;

    if (isPlaySound) await _playSound();

    final minimumAmount =
        match.room?.roomConfiguration?.minimumAmountToPlay ?? 0;

    if (infos.isEmpty) {
      infos = [
        {
          'title': 'Inscrição',
          'icon': Icons.attach_money,
          'value': '${minimumAmount}KZ',
        },
        {
          'title': 'Prêmio',
          'icon': Icons.wine_bar_rounded,
          'value': '${match.matchPrize!.netPremium} KZ',
        },
        {
          'title': 'Horário',
          'icon': Icons.schedule,
          'value': formatHour(match.matchStartDate),
        },
        {
          'title': 'Vagas',
          'icon': Icons.people,
          'value':
              '${match.matchPlayers?.length ?? 0}/${match.room?.roomConfiguration?.numberOfPlayers ?? 0}',
        },
      ];
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        AnimationController? progressController;

        if (isProgressBar) {
          progressController = AnimationController(
            vsync: Navigator.of(context),
            duration: Duration(seconds: timeCloseDialog),
          )..forward();

          progressController.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Navigator.of(context).pop();
            }
          });
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return AnimatedBuilder(
              animation: progressController ?? AlwaysStoppedAnimation(0),
              builder: (context, child) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isError == true
                                ? Colors.red
                                : const Color(0xFFEC8D0D),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title == null ? 'Super Partida' : title,
                                      style: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .override(
                                            fontFamily: 'Inter Tight',
                                            color: Colors.white,
                                            fontSize: 20,
                                            letterSpacing: 0,
                                          ),
                                    ),
                                    Text(
                                      '${formatHour(match.matchStartDate)} • ${match.matchPlayers?.length ?? 0} participantes',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white),
                                onPressed: () {
                                  progressController?.dispose();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: infos.map((info) {
                                  return _buildInfoItem(
                                    icon: info['icon'] as IconData,
                                    title: info['title'] as String,
                                    value: info['value'] as String,
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Participantes:',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              _buildParticipantsList(
                                  context, match, participants, currentUser),
                              const SizedBox(height: 16),
                              widget
                            ],
                          ),
                        ),
                        if (isProgressBar)
                          SizedBox(
                            height: 4,
                            child: LinearProgressIndicator(
                              value: progressController?.value ?? 0,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isError == true
                                    ? Colors.red
                                    : const Color(0xFFEC8D0D),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  static Widget _buildInfoItem(
      {required IconData icon, required String title, required String value}) {
    return Column(
      children: [
        Icon(icon, size: 24, color: const Color(0xFFEC8D0D)),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  static Widget _buildParticipantsList(
      BuildContext context,
      MatchResponse match,
      List<UserResponse> participants,
      UserResponse? currentUser) {
    if (participants.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Nenhum participante ainda',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: participants.length,
        itemBuilder: (context, index) {
          final player = participants[index];
          final isCurrentUser = player.id == currentUser!.id;

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFEC8D0D).withOpacity(0.2),
              child: Text(
                player.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Color(0xFFEC8D0D)),
              ),
            ),
            title: Text(
              player.name,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    fontWeight:
                        isCurrentUser ? FontWeight.bold : FontWeight.normal,
                    letterSpacing: 0,
                  ),
            ),
            trailing: isCurrentUser
                ? const Icon(Icons.person, color: Color(0xFFEC8D0D))
                : null,
          );
        },
      ),
    );
  }

  static String formatHour(DateTime? dateTime) {
    if (dateTime == null) return '';
    final hour = dateTime.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    return '${formattedHour}h$period';
  }
}
