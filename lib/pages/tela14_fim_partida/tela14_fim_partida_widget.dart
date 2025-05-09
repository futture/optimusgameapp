import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_game_quiz/components/moda_listade_sala_widget.dart';
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
    // Definindo cores e ícones baseados no isWinner
    final bool isWinner = jogador.isWinner ?? false;

    final Color corCard = isWinner
        ? _getWinnerColor(posicao) // Verde gradiente para vencedores
        : Colors.red[800]!; // Vermelho para perdedores

    final IconData iconePosicao = isWinner
        ? _getWinnerIcon(posicao) // Ícone de troféu/medalha para vencedores
        : FontAwesomeIcons.sadTear; // Ícone de cara triste para perdedores

    final Color corIcone = isWinner
        ? _getWinnerIconColor(posicao) // Cor do ícone para vencedores
        : Colors.white; // Branco para perdedores

    return Card(
      color: corCard,
      elevation: isExpanded ? 8.0 : 4.0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: isWinner
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getWinnerGradientStart(posicao),
                    _getWinnerGradientEnd(posicao),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.0),
              )
            : BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red[900]!,
                    Colors.red[700]!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
      ),
    );
  }

// Funções auxiliares para definir cores e ícones baseados na posição
  Color _getWinnerColor(int posicao) {
    return posicao == 0
        ? Color(0xFF2E7D32) // 1º lugar - Verde mais escuro
        : posicao == 1
            ? Color(0xFF4527A0) // 2º lugar - Roxo
            : posicao == 2
                ? Color(0xFF5D4037) // 3º lugar - Marrom
                : Color(0xFF424242); // Outros - Cinza escuro
  }

  IconData _getWinnerIcon(int posicao) {
    return posicao == 0
        ? FontAwesomeIcons.trophy // 1º lugar - Troféu
        : posicao == 1
            ? FontAwesomeIcons.medal // 2º lugar - Medalha
            : posicao == 2
                ? FontAwesomeIcons.award // 3º lugar - Prêmio
                : FontAwesomeIcons.smile; // Outros - Smile
  }

  Color _getWinnerIconColor(int posicao) {
    return posicao == 0
        ? Colors.amber // 1º lugar - Dourado
        : posicao == 1
            ? Colors.grey[300]! // 2º lugar - Prata
            : posicao == 2
                ? Color(0xFFD7CCC8) // 3º lugar - Bronze
                : Colors.grey[400]!; // Outros - Cinza
  }

  Color _getWinnerGradientStart(int posicao) {
    return posicao == 0
        ? Color(0xFF1B5E20) // Verde escuro
        : posicao == 1
            ? Color(0xFF311B92) // Roxo escuro
            : posicao == 2
                ? Color(0xFF3E2723) // Marrom escuro
                : Color(0xFF212121); // Cinza escuro
  }

  Color _getWinnerGradientEnd(int posicao) {
    return posicao == 0
        ? Color(0xFF4CAF50) // Verde claro
        : posicao == 1
            ? Color(0xFF7C4DFF) 
            : posicao == 2
                ? Color(0xFF8D6E63) // Marrom claro
                : Color(0xFF616161); // Cinza médio
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.2),
            Colors.amber.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.videogame_asset_rounded,
                  color: Colors.amber[300],
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  'Pronto para outra?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  shadowColor: Colors.amber.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.gamepad,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'NOVA PARTIDA',
                      style: TextStyle(
                        fontFamily: 'Inter Tight',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
