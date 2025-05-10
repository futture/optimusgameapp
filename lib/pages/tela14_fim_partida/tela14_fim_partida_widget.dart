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
                Color(0xFF1A1A2E), // Azul escuro mais elegante
                Color(0xFF16213E), // Degradê mais suave
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Header Section - Melhorado
                          _buildHeaderSection(),
                          const SizedBox(height: 24),

                          // Players List - Com animação de entrada
                          if (resultados.isNotEmpty) _buildPlayersList(),
                          if (resultados.isEmpty) _buildEmptyResults(),

                          // Bottom Button - Com efeito de destaque
                          const SizedBox(height: 24),
                          _buildGameRoomButton(),
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

  Widget _buildHeaderSection() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFEC8D0D).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEC8D0D).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          Icon(
            semVencedor
                ? FontAwesomeIcons.exclamationTriangle
                : FontAwesomeIcons.trophy,
            size: 60,
            color: semVencedor ? Colors.amber : Color(0xFFEC8D0D),
          ),
          const SizedBox(height: 16),
          Text(
            textAlign: TextAlign.center,
            semVencedor
                ? 'Partida encerrada!'
                : (matchInfo?.room?.roomConfiguration?.isSingleWinner ?? false)
                    ? 'Parabéns ao campeão!'
                    : 'Parabéns aos campeões!',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          if (matchInfo != null)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Duração: ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextSpan(
                    text:
                        '${matchInfo!.room!.roomConfiguration!.timeToRespond * matchInfo!.room!.roomConfiguration!.numberOfQuestions} segundos',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          if (matchInfo != null)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Modo: ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextSpan(
                    text: matchInfo!.room!.roomConfiguration!.isSingleWinner
                        ? 'Competição Individual'
                        : 'Time de Campeões',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayersList() {
    return Column(
      children: [
        Text(
          'Classificação Final',
          style: FlutterFlowTheme.of(context).titleLarge.override(
                fontFamily: 'Inter',
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 16),
        ...List.generate(resultados.length, (index) {
          final jogador = resultados[index];
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Padding(
              key: ValueKey(jogador.id),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                child: _buildPlayerCard(jogador, index),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPlayerCard(JogadorResultado jogador, int index) {
    final bool isExpanded = expandedIndices.contains(index);
    final bool isWinner = jogador.isWinner;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: isExpanded ? 16 : 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: isExpanded ? 12 : 6,
            offset: Offset(0, isExpanded ? 6 : 3),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                if (expandedIndices.contains(index)) {
                  expandedIndices.remove(index);
                } else {
                  expandedIndices.add(index);
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isWinner
                      ? [
                          _getWinnerGradientStart(index),
                          _getWinnerGradientEnd(index),
                        ]
                      : [
                          Color(0xFFC62828), // Vermelho escuro
                          Color(0xFFE53935), // Vermelho mais claro
                        ],
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Ícone de posição
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.3),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),

                      // Avatar e nome
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              jogador.nome,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${jogador.pontos} pontos',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Ícone de status
                      FaIcon(
                        isWinner
                            ? _getWinnerIcon(index)
                            : FontAwesomeIcons
                                .sadTear, // Ícone triste para perdedores
                        color: isWinner
                            ? _getWinnerIconColor(index)
                            : Colors.white70,
                        size: 24,
                      ),
                    ],
                  ),

                  // Seção expandida
                  if (isExpanded) ...[
                    SizedBox(height: 16),
                    Divider(color: Colors.white24),
                    SizedBox(height: 12),
                    _buildPlayerStats(jogador),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildPlayerCard(JogadorResultado jogador, int index) {
  //   final bool isExpanded = expandedIndices.contains(index);
  //   final bool isWinner = jogador.isWinner;

  //   return AnimatedContainer(
  //     duration: Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //     margin: EdgeInsets.only(bottom: isExpanded ? 16 : 8),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.3),
  //           blurRadius: isExpanded ? 12 : 6,
  //           offset: Offset(0, isExpanded ? 6 : 3),
  //         )
  //       ],
  //     ),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(16),
  //       child: Material(
  //         color: Colors.transparent,
  //         child: InkWell(
  //           onTap: () {
  //             setState(() {
  //               if (expandedIndices.contains(index)) {
  //                 expandedIndices.remove(index);
  //               } else {
  //                 expandedIndices.add(index);
  //               }
  //             });
  //           },
  //           child: Container(
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //                 colors: isWinner
  //                     ? [
  //                         _getWinnerGradientStart(index),
  //                         _getWinnerGradientEnd(index),
  //                       ]
  //                     : [
  //                         Color(0xFF424242),
  //                         Color(0xFF212121),
  //                       ],
  //               ),
  //             ),
  //             padding: EdgeInsets.all(16),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   children: [
  //                     // Ícone de posição
  //                     Container(
  //                       width: 40,
  //                       height: 40,
  //                       decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: Colors.black.withOpacity(0.3),
  //                       ),
  //                       alignment: Alignment.center,
  //                       child: Text(
  //                         '${index + 1}',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 18,
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(width: 12),

  //                     // Avatar e nome
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             jogador.nome,
  //                             style: TextStyle(
  //                               fontFamily: 'Inter',
  //                               fontSize: 18,
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.white,
  //                             ),
  //                           ),
  //                           SizedBox(height: 4),
  //                           Text(
  //                             '${jogador.pontos} pontos',
  //                             style: TextStyle(
  //                               color: Colors.white70,
  //                               fontSize: 14,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),

  //                     // Ícone de status
  //                     FaIcon(
  //                       isWinner
  //                           ? _getWinnerIcon(index)
  //                           : FontAwesomeIcons.user,
  //                       color: isWinner
  //                           ? _getWinnerIconColor(index)
  //                           : Colors.white70,
  //                       size: 24,
  //                     ),
  //                   ],
  //                 ),

  //                 // Seção expandida
  //                 if (isExpanded) ...[
  //                   SizedBox(height: 16),
  //                   Divider(color: Colors.white24),
  //                   SizedBox(height: 12),
  //                   _buildPlayerStats(jogador),
  //                 ],
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPlayerStats(JogadorResultado jogador) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatTile(
              icon: FontAwesomeIcons.coins,
              value: '${jogador.premio.toStringAsFixed(0)}KZ',
              label: 'Prêmio',
              color: Colors.amber,
            ),
            _buildStatTile(
              icon: Icons.star,
              value: '${jogador.pontos}',
              label: 'Pontos',
              color: Colors.blue[200]!,
            ),
            _buildStatTile(
              icon: Icons.check_circle,
              value: '${jogador.perguntasCertas}',
              label: 'Acertos',
              color: Colors.green[300]!,
            ),
          ],
        ),
        SizedBox(height: 16),
        _buildDetailedStats(jogador),
      ],
    );
  }

  Widget _buildStatTile({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedStats(JogadorResultado jogador) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1),
        },
        children: [
          _buildTableRow('Perguntas Certas', '${jogador.perguntasCertas}'),
          _buildTableRow('Perguntas Erradas', '${jogador.perguntasErradas}'),
          _buildTableRow('Taxa de Acerto',
              '${(jogador.perguntasCertas / (jogador.perguntasCertas + jogador.perguntasErradas) * 100).toStringAsFixed(1)}%'),
          _buildTableRow('Top 3 vezes', '${jogador.top3vezes ?? 0}'),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyResults() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.exclamationCircle,
            size: 48,
            color: Colors.amber,
          ),
          SizedBox(height: 16),
          Text(
            'Nenhum resultado disponível',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Esta partida não teve vencedores ou os resultados não estão disponíveis',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameRoomButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEC8D0D).withOpacity(0.8),
              Color(0xFFEC8D0D).withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFEC8D0D).withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
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
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.gamepad,
                    color: Colors.white,
                    size: 28,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pronto para outra partida?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Clique para encontrar novas salas',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Funções auxiliares para definir cores e ícones baseados na posição
  // Color _getWinnerColor(int posicao) {
  //   return posicao == 0
  //       ? Color(0xFF2E7D32) // 1º lugar - Verde mais escuro
  //       : posicao == 1
  //           ? Color(0xFF4527A0) // 2º lugar - Roxo
  //           : posicao == 2
  //               ? Color(0xFF5D4037) // 3º lugar - Marrom
  //               : Color(0xFF424242); // Outros - Cinza escuro
  // }

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

  // Widget _buildStatItem({
  //   required IconData icon,
  //   required String value,
  //   required Color color,
  // }) {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Icon(icon, color: color, size: 18),
  //       SizedBox(width: 4),
  //       Text(
  //         value,
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildTabelaExpandida(JogadorResultado jogador) {
  //   return Container(
  //     padding: EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.black.withOpacity(0.2),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Column(
  //       children: [
  //         _buildDetailRow('Perguntas Certas', '${jogador.perguntasCertas}'),
  //         Divider(color: Colors.white24, height: 16),
  //         _buildDetailRow('Perguntas Erradas', '${jogador.perguntasErradas}'),
  //         Divider(color: Colors.white24, height: 16),
  //         _buildDetailRow('Top 3 vezes', '${jogador.top3vezes ?? 0}'),
  //         Divider(color: Colors.white24, height: 16),
  //         _buildDetailRow('Pontos Totais', '${jogador.pontos}'),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildDetailRow(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           label,
  //           style: TextStyle(
  //             color: Colors.white70,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //         Text(
  //           value,
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
