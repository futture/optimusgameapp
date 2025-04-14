import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_widgets.dart';
import 'package:projeto_game_quiz/pages/tela14_fim_partida/tela14_fim_partida_model.dart';

enum TrofeuTipo { ouro, prata, bronze, perdedor }

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
  late Tela14FimPartidaViewModel _model;
  MatchResponse? matchInfo;
  List<JogadorResultado> resultados = List.empty();
  Set<int> expandedIndices = {};
  late MatchResultResponse? gameResultInfo;
  final scaffoldKey = GlobalKey<ScaffoldState>();

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

    resultados = gameResultInfo?.generalRanking.map((ranking) {
          return JogadorResultado(
            nome: ranking.playerName,
            pontos: ranking.points,
            premio: ranking.prize,
            perguntasCertas: ranking.hits,
            perguntasErradas: ranking.errors,
            top3vezes: ranking.timesInTop3,
            posicao: ranking.position,
            isWinner: ranking.winner == true,
          );
        }).toList() ??
        [];

    resultados.sort((a, b) => a.posicao.compareTo(b.posicao));

    final vencedores = resultados.where((r) => r.isWinner).toList();

    if (vencedores.length == 1) {
      vencedores[0].trofeu = TrofeuTipo.ouro;
    } else if (vencedores.length > 1) {
      for (int i = 0; i < vencedores.length && i < 3; i++) {
        switch (i) {
          case 0:
            vencedores[i].trofeu = TrofeuTipo.ouro;
            break;
          case 1:
            vencedores[i].trofeu = TrofeuTipo.prata;
            break;
          case 2:
            vencedores[i].trofeu = TrofeuTipo.bronze;
            break;
        }
      }
    }
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Fim da Partida'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/tela03Principal', (route) => false);
          },
        ),
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
                      Text(
                        'Parabéns aos campeões!',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        matchInfo == null
                            ? "Carregando..."
                            : 'Duração da partida: ${matchInfo!.matchConfiguration!.timeToRespond * matchInfo!.matchConfiguration!.numberOfQuestions} segundos',
                        style: TextStyle(fontSize: 16),
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
                              // MatchCard(
                              //     context: context,
                              //     jogador: jogador,
                              //     posicao: index),
                              if (expandedIndices.contains(index))
                                _buildTabelaExpandida(jogador),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/tela03Principal', (route) => false);
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
    );
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
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            valor,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class JogadorResultado {
  final String nome;
  final int pontos;
  final double premio;
  final int perguntasCertas;
  final int perguntasErradas;
  final int? top3vezes;
  final int posicao;
  final bool isWinner;
  TrofeuTipo trofeu;

  JogadorResultado({
    required this.nome,
    required this.pontos,
    required this.premio,
    required this.perguntasCertas,
    required this.perguntasErradas,
    required this.top3vezes,
    required this.posicao,
    required this.isWinner,
    this.trofeu = TrofeuTipo.perdedor,
  });
}
