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
  const Tela14FimPartidaViewWidget({
    super.key,
    this.gameResultInfo,
    this.matchInfo,
  });

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

  // Cores premium com header laranja
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _primaryDark = Color(0xFFD17A0A);
  final Color _primaryLight = Color(0xFFFFF3E0);
  final Color _backgroundColor = Colors.white;
  final Color _surfaceColor = Colors.white;
  final Color _cardColor = Color(0xFFF8FAFC);
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _onSurfaceLight = Color(0xFF64748B);
  final Color _borderColor = Color(0xFFE2E8F0);
  final Color _winnerGreen = Color(0xFF10B981);
  final Color _winnerGreenLight = Color(0xFFD1FAE5);
  final Color _loserRed = Color(0xFFEF4444);
  final Color _loserRedLight = Color(0xFFFEE2E2);
  final Color _warningColor = Color(0xFFF59E0B);
  final Color _infoColor = Color(0xFF3B82F6);
  final Color _successColor = Color(0xFF10B981);
  final Color _goldColor = Color(0xFFFFD700);
  final Color _silverColor = Color(0xFFC0C0C0);
  final Color _bronzeColor = Color(0xFFCD7F32);

  // Gradientes premium
  final LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _headerGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  final LinearGradient _winnerGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _loserGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFF87171)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFED4E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _silverGradient = LinearGradient(
    colors: [Color(0xFFC0C0C0), Color(0xFFE5E4E2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _bronzeGradient = LinearGradient(
    colors: [Color(0xFFCD7F32), Color(0xFFE0A55F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

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
        backgroundColor: _backgroundColor,
        body: Column(
          children: [
            // Header Laranja Premium (padrão das suas telas)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: _headerGradient,
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Botão de menu premium
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        child: Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child: ModaMenuPagianInicialWidget(),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));
                                },
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.bars,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),

                          // Título e subtítulo
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RESULTADOS DA PARTIDA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Análise detalhada do desempenho',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Ícone de troféu
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.emoji_events_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Barra de progresso decorativa
                      Container(
                        height: 3,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF8FAFC),
                      Colors.white,
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 600),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Card de Resumo Premium com destaque
                        _buildSummaryCard(),
                        SizedBox(height: 24),

                        // Lista de Jogadores
                        if (resultados.isNotEmpty) _buildPlayersList(),
                        if (resultados.isEmpty) _buildEmptyResults(),

                        // Botão Nova Partida com destaque
                        SizedBox(height: 32),
                        _buildGameRoomButton(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: Offset(0, 10),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: _borderColor,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Badge de status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: semVencedor
                  ? LinearGradient(
                      colors: [
                        _onSurfaceLight.withOpacity(0.8),
                        _onSurfaceLight.withOpacity(0.4)
                      ],
                    )
                  : _primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (semVencedor ? _onSurfaceLight : _primaryColor)
                      .withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  semVencedor
                      ? Icons.groups_rounded
                      : Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  semVencedor ? 'PARTIDA CONCLUÍDA' : 'PARABÉNS!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Ícone principal
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: semVencedor
                  ? LinearGradient(
                      colors: [
                        _onSurfaceLight.withOpacity(0.3),
                        _onSurfaceLight.withOpacity(0.1)
                      ],
                    )
                  : _primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (semVencedor ? _onSurfaceLight : _primaryColor)
                      .withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Icon(
              semVencedor ? Icons.groups_rounded : Icons.emoji_events_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          SizedBox(height: 16),

          // Título principal
          Text(
            semVencedor
                ? 'Partida Concluída'
                : (matchInfo?.room?.roomConfiguration?.isSingleWinner ?? false)
                    ? 'Parabéns ao Vencedor!'
                    : 'Parabéns aos Vencedores!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _onSurfaceColor,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8),

          Text(
            semVencedor
                ? 'Todos os participantes foram eliminados nesta rodada'
                : 'Excelente desempenho dos competidores',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _onSurfaceLight,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 24),

          // Informações da partida
          if (matchInfo != null)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _borderColor,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  _buildInfoItem(
                    icon: Icons.timer_rounded,
                    title: 'Duração Total',
                    value:
                        '${matchInfo!.room!.roomConfiguration!.timeToRespond * matchInfo!.room!.roomConfiguration!.numberOfQuestions} seg',
                    iconColor: _primaryColor,
                  ),
                  SizedBox(height: 12),
                  _buildInfoItem(
                    icon: Icons.group_rounded,
                    title: 'Modo de Jogo',
                    value: matchInfo!.room!.roomConfiguration!.isSingleWinner
                        ? 'Competição Individual'
                        : 'Time de Campeões',
                    iconColor: _infoColor,
                  ),
                  SizedBox(height: 12),
                  _buildInfoItem(
                    icon: Icons.question_answer_rounded,
                    title: 'Total de Perguntas',
                    value:
                        '${matchInfo!.room!.roomConfiguration!.numberOfQuestions}',
                    iconColor: _successColor,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: iconColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _onSurfaceLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: _onSurfaceColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabeçalho da classificação
        Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _primaryColor.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.leaderboard_rounded,
                color: _primaryColor,
                size: 20,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CLASSIFICAÇÃO FINAL',
                      style: TextStyle(
                        color: _onSurfaceColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Toque em um jogador para ver estatísticas detalhadas',
                      style: TextStyle(
                        color: _onSurfaceLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${resultados.length} jogadores',
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // Lista de jogadores
        ...List.generate(resultados.length, (index) {
          final jogador = resultados[index];
          return Padding(
            key: ValueKey(jogador.id),
            padding: const EdgeInsets.only(bottom: 12.0),
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
          );
        }),
      ],
    );
  }

  Widget _buildPlayerCard(JogadorResultado jogador, int index) {
    final bool isExpanded = expandedIndices.contains(index);
    final bool isWinner = jogador.isWinner;
    final bool isTop3 = index < 3;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: isExpanded ? 20 : 10,
            offset: Offset(0, isExpanded ? 8 : 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
              color: isWinner ? _winnerGreenLight : _loserRedLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isWinner
                    ? _winnerGreen.withOpacity(0.3)
                    : _loserRed.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Posição com medalha
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: _getPositionGradient(index),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      _getPositionColor(index).withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),

                      // Informações do jogador
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    jogador.nome,
                                    style: TextStyle(
                                      color: _onSurfaceColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                if (isTop3) ...[
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: _getPositionGradient(index),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _getPositionText(index),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                _buildStatBadge(
                                  icon: Icons.star_rounded,
                                  value: '${jogador.pontos}%',
                                  label: 'Sucesso (%)',
                                  color: _goldColor,
                                ),
                                SizedBox(width: 8),
                                _buildStatBadge(
                                  icon: Icons.currency_bitcoin_rounded,
                                  value: '${jogador.premio.toStringAsFixed(0)}',
                                  label: 'AOA',
                                  color: _primaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Ícone e status
                      Column(
                        children: [
                          Icon(
                            isWinner
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            color: isWinner ? _winnerGreen : _loserRed,
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            isWinner ? 'Vencedor' : 'Eliminado',
                            style: TextStyle(
                              color: isWinner ? _winnerGreen : _loserRed,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 8),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: _onSurfaceLight,
                        size: 24,
                      ),
                    ],
                  ),
                ),

                // Seção expandida
                if (isExpanded) ...[
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: _borderColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: _buildPlayerStats(jogador),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 14,
          ),
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: _onSurfaceColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: _onSurfaceLight,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerStats(JogadorResultado jogador) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatCircle(
              icon: Icons.check_circle_rounded,
              value: '${jogador.perguntasCertas}',
              label: 'Acertos',
              color: _successColor,
              isPrimary: true,
            ),
            _buildStatCircle(
              icon: Icons.cancel_rounded,
              value: '${jogador.perguntasErradas}',
              label: 'Erros',
              color: _loserRed,
              isPrimary: false,
            ),
            _buildStatCircle(
              icon: Icons.percent_rounded,
              value: '${(jogador.accuracyRate * 100).toStringAsFixed(1)}%',
              label: 'Eficácia',
              color: _infoColor,
              isPrimary: false,
            ),
          ],
        ),
        SizedBox(height: 20),

        // Tabela detalhada
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _borderColor,
              width: 1.5,
            ),
          ),
          child: Table(
            columnWidths: {
              0: FlexColumnWidth(2.5),
              1: FlexColumnWidth(1),
            },
            children: [
              _buildTableRow('Respostas Certas', '${jogador.perguntasCertas}'),
              _buildTableRow(
                  'Respostas Erradas', '${jogador.perguntasErradas}'),
              _buildTableRow('Taxa de Eficácia',
                  '${(jogador.accuracyRate * 100).toStringAsFixed(1)}%'),
              _buildTableRow('Taxa de Eficiência',
                  '${(jogador.timeRate * 100).toStringAsFixed(1)}%'),
              _buildTableRow('Presenças Top 3', '${jogador.top3vezes ?? 0}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCircle({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isPrimary,
  }) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: isPrimary
                ? LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                  )
                : null,
            color: isPrimary ? null : color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(isPrimary ? 0.3 : 0.2),
              width: isPrimary ? 2 : 1.5,
            ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Icon(
              icon,
              color: isPrimary ? Colors.white : color,
              size: 24,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: _onSurfaceColor,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: _onSurfaceLight,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              color: _onSurfaceColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: _onSurfaceColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyResults() {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _warningColor.withOpacity(0.3),
                  _warningColor.withOpacity(0.1)
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: _warningColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: _warningColor,
              size: 40,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Resultados Indisponíveis',
            style: TextStyle(
              color: _onSurfaceColor,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Esta partida não teve vencedores ou os resultados não estão disponíveis no momento.',
            style: TextStyle(
              color: _onSurfaceLight,
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGameRoomButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _primaryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
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
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: _primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      FontAwesomeIcons.gamepad,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'JOGAR NOVAMENTE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Encontre novas salas disponíveis',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Funções auxiliares para posições
  Gradient _getPositionGradient(int posicao) {
    switch (posicao) {
      case 0:
        return _goldGradient;
      case 1:
        return _silverGradient;
      case 2:
        return _bronzeGradient;
      default:
        return LinearGradient(
          colors: [
            _onSurfaceLight.withOpacity(0.8),
            _onSurfaceLight.withOpacity(0.4)
          ],
        );
    }
  }

  Color _getPositionColor(int posicao) {
    switch (posicao) {
      case 0:
        return _goldColor;
      case 1:
        return _silverColor;
      case 2:
        return _bronzeColor;
      default:
        return _onSurfaceLight;
    }
  }

  String _getPositionText(int posicao) {
    switch (posicao) {
      case 0:
        return '🥇 1º';
      case 1:
        return '🥈 2º';
      case 2:
        return '🥉 3º';
      default:
        return '${posicao + 1}º';
    }
  }

  // Funções auxiliares originais mantidas
  IconData _getWinnerIcon(int posicao) {
    return posicao == 0
        ? FontAwesomeIcons.trophy
        : posicao == 1
            ? FontAwesomeIcons.medal
            : posicao == 2
                ? FontAwesomeIcons.award
                : FontAwesomeIcons.smile;
  }

  Color _getWinnerIconColor(int posicao) {
    return posicao == 0
        ? _goldColor
        : posicao == 1
            ? _silverColor
            : posicao == 2
                ? _bronzeColor
                : _onSurfaceLight;
  }

  Color _getWinnerGradientStart(int posicao) {
    return posicao == 0
        ? Color(0xFF1B5E20)
        : posicao == 1
            ? Color(0xFF311B92)
            : posicao == 2
                ? Color(0xFF3E2723)
                : Color(0xFF212121);
  }

  Color _getWinnerGradientEnd(int posicao) {
    return posicao == 0
        ? Color(0xFF4CAF50)
        : posicao == 1
            ? Color(0xFF7C4DFF)
            : posicao == 2
                ? Color(0xFF8D6E63)
                : Color(0xFF616161);
  }
}
