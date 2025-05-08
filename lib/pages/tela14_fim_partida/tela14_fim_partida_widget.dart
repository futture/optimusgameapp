import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_game_quiz/components/moda_listade_sala_widget.dart';
import 'package:projeto_game_quiz/components/moda_menu_pagian_inicial_widget.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_icon_button.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_widgets.dart';
import 'package:projeto_game_quiz/pages/tela03_principal/tela03_principal_widget.dart';
import 'package:projeto_game_quiz/pages/tela14_fim_partida/tela14_fim_partida_model.dart';

class Tela14FimPartidaViewWidget extends StatefulWidget {
  final dynamic gameResultInfo;
  final dynamic matchInfo;
  const Tela14FimPartidaViewWidget(
      {super.key, this.gameResultInfo, this.matchInfo});

  static String routeName = 'Tela14FimPartidaView';
  static String routePath = '/tela14FimPartidaView';

  @override
  State<Tela14FimPartidaViewWidget> createState() =>
      _Tela14FimPartidaViewWidgetState();
}

class _Tela14FimPartidaViewWidgetState extends State<Tela14FimPartidaViewWidget>
    with TickerProviderStateMixin {
  MatchResponse? matchInfo;
  Set<int> expandedIndices = {};
  late Tela14FimPartidaViewModel _model;
  late MatchResultResponse? gameResultInfo;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<JogadorResultado> resultados = List.empty();
  late bool semVencedor;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela14FimPartidaViewModel());
    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    matchInfo = widget.matchInfo;
    gameResultInfo = widget.gameResultInfo;
    if (gameResultInfo != null) {
      resultados = _model.processarResultados(gameResultInfo);
    }
    semVencedor = resultados.isEmpty || resultados.every((j) => j.pontos == 0);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Tela03PrincipalWidget()),
        );
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(18.0, 0.0, 0.0, 0.0),
            child: FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 45.0,
              fillColor: FlutterFlowTheme.of(context).primaryBackground,
              icon: FaIcon(
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
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
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
                  color: Color(0xFFEC8D0D),
                  letterSpacing: 0.0,
                ),
          ),
          centerTitle: true,
          elevation: 4.0,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1E1E1E),
                Color(0xFF121212),
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Header Section
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  FontAwesomeIcons.trophy,
                                  size: 60,
                                  color: Colors.amber,
                                ),
                                const SizedBox(height: 10),
                                if (matchInfo != null)
                                  Text(
                                    matchInfo!.room!.roomConfiguration!
                                            .isSingleWinner
                                        ? 'Parabéns ao campeão!'
                                        : 'Parabéns aos campeões!',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                const SizedBox(height: 10),
                                Text(
                                  matchInfo == null
                                      ? "Carregando..."
                                      : 'Duração: ${matchInfo!.room!.roomConfiguration!.timeToRespond * matchInfo!.room!.roomConfiguration!.numberOfQuestions} segundos',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        color: Colors.white70,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Players List
                          ListView.builder(
                            itemCount: resultados.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final jogador = resultados[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (expandedIndices.contains(index)) {
                                        expandedIndices.remove(index);
                                      } else {
                                        expandedIndices.add(index);
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: MatchCard(
                                      context: context,
                                      jogador: jogador,
                                      posicao: index,
                                      isExpanded:
                                          expandedIndices.contains(index),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Bottom Button
                          const SizedBox(height: 20),
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: _buildGameRoomButton()),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget MatchCard({
    required BuildContext context,
    required JogadorResultado jogador,
    required int posicao,
    bool isExpanded = false,
  }) {
    final bool isPrimeiro = posicao == 0;
    final bool isSegundo = posicao == 1;
    final bool isTerceiro = posicao == 2;

    final Color corCard = semVencedor
        ? Colors.red[800]!
        : isPrimeiro
            ? Color(0xFF2E7D32)
            : isSegundo
                ? Color(0xFF4527A0)
                : isTerceiro
                    ? Color(0xFF5D4037)
                    : Color(0xFF424242);

    final IconData? iconePosicao = semVencedor
        ? FontAwesomeIcons.skull
        : isPrimeiro
            ? FontAwesomeIcons.trophy
            : isSegundo
                ? FontAwesomeIcons.medal
                : isTerceiro
                    ? FontAwesomeIcons.award
                    : FontAwesomeIcons.user;

    final Color corIcone = semVencedor
        ? Colors.black
        : isPrimeiro
            ? Colors.amber
            : isSegundo
                ? Colors.grey[300]!
                : isTerceiro
                    ? Color(0xFFD7CCC8)
                    : Colors.grey[400]!;

    return Card(
      color: corCard,
      elevation: isExpanded ? 8.0 : 4.0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.2),
                  ),
                  padding: EdgeInsets.all(8),
                  child: FaIcon(
                    iconePosicao,
                    color: corIcone,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    jogador.nome,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Inter Tight',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.3)),
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '${posicao + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  icon: FontAwesomeIcons.coins,
                  value: '${jogador.premio.toStringAsFixed(0)}KZ',
                  color: Colors.amber,
                ),
                _buildStatItem(
                  icon: Icons.star,
                  value: '${jogador.pontos} pts',
                  color: Colors.blue[200]!,
                ),
                _buildStatItem(
                  icon: Icons.check_circle,
                  value: '${jogador.perguntasCertas} certas',
                  color: Colors.green[300]!,
                ),
              ],
            ),
            if (isExpanded) ...[
              SizedBox(height: 12),
              _buildTabelaExpandida(jogador),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTabelaExpandida(JogadorResultado jogador) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildDetailRow('Perguntas Certas', '${jogador.perguntasCertas}'),
          Divider(color: Colors.white24, height: 16),
          _buildDetailRow('Perguntas Erradas', '${jogador.perguntasErradas}'),
          Divider(color: Colors.white24, height: 16),
          _buildDetailRow('Top 3 vezes', '${jogador.top3vezes ?? 0}'),
          Divider(color: Colors.white24, height: 16),
          _buildDetailRow('Pontos Totais', '${jogador.pontos}'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameRoomButton() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clique para escolher sala de jogo',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 12),
            FFButtonWidget(
              onPressed: () async {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  enableDrag: false,
                  context: context,
                  builder: (context) => GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: const ModaListadeSalaWidget(),
                    ),
                  ),
                );
                safeSetState(() {});
              },
              text: 'PARTIDAS',
              icon: const FaIcon(FontAwesomeIcons.gamepad, size: 20.0),
              options: FFButtonOptions(
                width: double.infinity,
                height: 50.0,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                color: const Color(0xFF00B80E),
                textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter Tight',
                      color: Colors.white,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
                elevation: 2.0,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
