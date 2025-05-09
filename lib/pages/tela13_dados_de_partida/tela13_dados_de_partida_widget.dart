import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_game_quiz/components/moda_menu_pagian_inicial_widget.dart';
import 'package:projeto_game_quiz/components/warnings/warning04_reducao_de_saldo/warning04_reducao_de_saldo_widget.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/dialogs/common_dialog_widget.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_icon_button.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_widgets.dart';
import 'package:projeto_game_quiz/pages/tela03_principal/tela03_principal_widget.dart';
import 'package:projeto_game_quiz/pages/tela13_dados_de_partida/tela13_dados_de_partida_model.dart';

class Tela13DadosDePartidaWidget extends StatefulWidget {
  final String? matchId;
  final bool? recebeuNotificaca;
  final bool? notDisplayButton;
  final bool? isDesqualification;

  const Tela13DadosDePartidaWidget({
    super.key,
    this.matchId,
    this.recebeuNotificaca,
    this.notDisplayButton,
    this.isDesqualification,
  });

  static String routeName = 'Tela13DadosDePartida';
  static String routePath = '/tela13DadosDePartida';

  @override
  State<Tela13DadosDePartidaWidget> createState() =>
      _Tela13DadosDePartidaWidgetState();
}

class _Tela13DadosDePartidaWidgetState
    extends State<Tela13DadosDePartidaWidget> {
  late Tela13DadosDePartidaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela13DadosDePartidaModel());
    _model.fetchMatchById(setState, widget.matchId);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(18.0, 0.0, 0.0, 0.0),
          child: FlutterFlowIconButton(
            borderRadius: 8.0,
            buttonSize: 45.0,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            icon: const FaIcon(
              FontAwesomeIcons.bars,
              color: Colors.black,
              size: 24.0,
            ),
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: ModaMenuPagianInicialWidget(),
                    ),
                  );
                },
              ).then((value) => safeSetState(() {}));
            },
          ),
        ),
        title: Text(
          'GAME QUIZ',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                color: const Color(0xFFEC8D0D),
                letterSpacing: 0.0,
              ),
        ),
        centerTitle: true,
        elevation: 4.0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_model.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_model.matchInfo == null) {
      return _buildEmptyState();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 20),
            _buildMatchDetailsSection(),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.videogame_asset_outlined,
            size: 48, color: Colors.grey),
        const SizedBox(height: 16),
        const Text(
          'Nenhuma partida encontrada',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        IconButton(
          icon: const Icon(Icons.refresh, size: 30),
          onPressed: () => _model.fetchMatchById(setState, widget.matchId),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/png-transparent-trophy-trophy-image-file-formats-trophy-objects-thumbnail.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            Text(
              widget.notDisplayButton == true
                  ? widget.isDesqualification != null
                      ? 'DESQUALIFICADO'
                      : 'SUPER PARTIDA'
                  : 'Partida de Trivia',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        widget.isDesqualification != null
            ? const Text(
                'Desqualificado por inatividade.',
                style: TextStyle(color: Colors.grey),
              )
            : const Text(
                'Estamos a preparar a partida, aguarde.',
                style: TextStyle(color: Colors.grey),
              ),
        SizedBox(
          width: 290.0,
          child: Divider(
            thickness: 2.0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildMatchDetailsSection() {
    return Column(
      children: [
        _buildDetailItem(
          icon: Icons.people,
          label: 'Jogadores',
          value:
              '${_model.matchInfo!.room!.roomConfiguration!.numberOfPlayers}',
        ),
        _buildDetailItem(
          icon: Icons.emoji_events,
          label: 'Prêmio',
          value:
              '${(_model.matchInfo!.room!.roomConfiguration!.minimumAmountToPlay * _model.matchInfo!.room!.roomConfiguration!.numberOfPlayers * _model.matchInfo!.room!.roomConfiguration!.premiumRate)} Kz',
        ),
        _buildDetailItem(
          icon: Icons.attach_money,
          label: 'Taxa de entrada',
          value:
              '${_model.matchInfo!.room!.roomConfiguration!.minimumAmountToPlay} Kz',
        ),
        _buildDetailItem(
          icon: Icons.timer,
          label: 'Duração',
          value:
              '${_model.matchInfo!.room!.roomConfiguration!.numberOfQuestions * _model.matchInfo!.room!.roomConfiguration!.timeToRespond} segundos',
        ),
      ],
    );
  }

  Widget _buildDetailItem(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.notDisplayButton == null || widget.notDisplayButton == false)
          if (_model.matchInfo!.statusMatch == "PENDING")
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: const EdgeInsets.all(24),
                    child: Warning04ReducaoDeSaldoWidget(
                      matchInfo: _model.matchInfo,
                      recebeuNotificaca: true,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C804),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Aceitar',
                style: TextStyle(color: Colors.black),
              ),
            ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => Tela03PrincipalWidget(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFA080C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}


class DadosDaPartidaUtils{
    static void showMatchParticipantsDialog(BuildContext ctx, UserResponse? currentUser, MatchResponse matchInfo,
      List<UserResponse> participants, Widget? widget) {
    // if (currentUser != null) {
    //   participants.insert(0, currentUser!);
    // }
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
      "Desafio",
      matchInfo,
      participants,
      currentUser,
      _buildDialogActions(ctx, matchInfo, participants, widget),
    );
  }

 static Widget _buildDialogActions(BuildContext ctx, MatchResponse matchInfo,

      List<UserResponse> participants, Widget? widget) {
    return Column(
      children: [
        if (widget != null) widget,
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (matchInfo.statusMatch == "PENDING")
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
              text: 'Negar',
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