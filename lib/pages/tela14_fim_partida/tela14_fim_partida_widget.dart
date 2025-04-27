import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_game_quiz/components/moda_menu_pagian_inicial_widget.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_icon_button.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
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
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(FontAwesomeIcons.trophy,
                              size: 60, color: Colors.amber),
                          const SizedBox(height: 10),
                          if (matchInfo != null)
                            Text(
                              matchInfo!.room!.roomConfiguration!.isSingleWinner
                                  ? 'Parabéns ao campeão!'
                                  : 'Parabéns aos campeões!',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                  ),
                            ),
                          const SizedBox(height: 10),
                          Text(
                            matchInfo == null
                                ? "Carregando..."
                                : 'Duração da partida: ${matchInfo!.room!.roomConfiguration!.timeToRespond * matchInfo!.room!.roomConfiguration!.numberOfQuestions} segundos',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(fontFamily: 'Inter'),
                          ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            itemCount: resultados.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final jogador = resultados[index];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (expandedIndices.contains(index)) {
                                          expandedIndices.remove(index);
                                        } else {
                                          expandedIndices.add(index);
                                        }
                                      });
                                    },
                                    child: MatchCard(
                                      context: context,
                                      jogador: jogador,
                                      posicao: index,
                                    ),
                                  ),
                                  if (expandedIndices.contains(index))
                                    _buildTabelaExpandida(jogador),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => Tela03PrincipalWidget(),
                                ),
                              );
                            },
                            icon: Icon(Icons.home),
                            label: Text("Menu Inicial"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }

  Widget MatchCard({
    required BuildContext context,
    required JogadorResultado jogador,
    required int posicao,
  }) {
    final bool isPrimeiro = posicao == 0;
    final bool isSegundo = posicao == 1;
    final bool isTerceiro = posicao == 2;

    final Color corCard = isPrimeiro
        ? Colors.green
        : isSegundo
            ? Colors.deepPurple
            : isTerceiro
                ? Colors.brown
                : Colors.grey;

    final IconData iconePosicao = isPrimeiro
        ? FontAwesomeIcons.trophy
        : isSegundo
            ? FontAwesomeIcons.medal
            : FontAwesomeIcons.award;

    final Color corIcone = isPrimeiro
        ? Colors.amber
        : isSegundo
            ? Colors.grey
            : Colors.brown;

    return Card(
      color: corCard,
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(iconePosicao, color: corIcone, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    jogador.nome,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          fontFamily: 'Inter Tight',
                          letterSpacing: 0.0,
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.shield, color: Colors.black, size: 24),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, color: Colors.white, size: 20),
                const SizedBox(width: 6),
                Text(
                  '${posicao + 1} º Posição',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(FontAwesomeIcons.coins, color: Colors.white, size: 20),
                const SizedBox(width: 6),
                Text(
                  '${jogador.premio.toStringAsFixed(0)}KZ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.fitness_center, color: Colors.white, size: 20),
                const SizedBox(width: 6),
                Text(
                  '${jogador.pontos} pts',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabelaExpandida(JogadorResultado jogador) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1),
        },
        children: [
          _buildTableRow('Perguntas Certas:', '${jogador.perguntasCertas}'),
          _buildTableRow('Perguntas Erradas:', '${jogador.perguntasErradas}'),
          _buildTableRow('Top 3 vezes:', '${jogador.top3vezes ?? 0}'),
          _buildTableRow('Pontos Totais:', '${jogador.pontos}'),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String titulo, String valor) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            titulo,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            valor,
            style: TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
