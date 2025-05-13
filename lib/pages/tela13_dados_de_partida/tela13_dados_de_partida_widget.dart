import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/components/warnings/warning04_reducao_de_saldo/warning04_reducao_de_saldo_widget.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/dialogs/common_dialog_widget.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_widgets.dart';

class DadosDaPartidaUtils {
  static void showMatchParticipantsDialog(
      {required BuildContext ctx,
      UserResponse? currentUser,
      required MatchResponse matchInfo,
      required List<UserResponse> participants,
      Widget? widget,
      bool doNotDisplayButton = false,
      String title = "Desafio",
      bool isError = false}) {
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
        ctx,
        infos,
        title,
        matchInfo,
        participants,
        currentUser,
        _buildDialogActions(
            ctx, matchInfo, participants, widget, doNotDisplayButton),
        isError: isError);
  }

  static Widget _buildDialogActions(
      BuildContext ctx,
      MatchResponse matchInfo,
      List<UserResponse> participants,
      Widget? widget,
      bool? doNotDisplayButton) {
    return Column(
      children: [
        if (widget != null) widget,
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (matchInfo.statusMatch == "PENDING")
              if (doNotDisplayButton == false)
                FFButtonWidget(
                  onPressed: () async {
                    showDialog(
                      context: ctx,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.all(24),
                        child: Warning04ReducaoDeSaldoWidget(
                          matchInfo: matchInfo,
                          recebeuNotificaca: true,
                        ),
                      ),
                    );
                  },
                  text: 'Aceitar',
                  options: FFButtonOptions(
                    height: 40,
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    color: const Color(0xFF00B80E),
                    textStyle: FlutterFlowTheme.of(ctx).titleSmall.override(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          letterSpacing: 0,
                        ),
                    elevation: 3,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
            FFButtonWidget(
              onPressed: () async {
                Navigator.of(ctx).pop();
              },
              text: 'Fechar',
              options: FFButtonOptions(
                height: 40,
                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                color: FlutterFlowTheme.of(ctx).error,
                textStyle: FlutterFlowTheme.of(ctx).titleSmall.override(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                elevation: 3,
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
