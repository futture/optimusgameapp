import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_game_quiz/core/models/responses/match-result-response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_widgets.dart';
import 'package:projeto_game_quiz/pages/tela14_fim_partida/tela14_fim_partida_model.dart';

class Tela14FimPartidaViewWidget extends StatefulWidget {
  final dynamic gameResultInfo;

  const Tela14FimPartidaViewWidget({super.key, this.gameResultInfo});

  static String routeName = 'Tela14FimPartidaView';
  static String routePath = '/tela14FimPartidaView';

  @override
  State<Tela14FimPartidaViewWidget> createState() =>
      _Tela14FimPartidaViewWidgetState();
}

class _Tela14FimPartidaViewWidgetState extends State<Tela14FimPartidaViewWidget>
    with TickerProviderStateMixin {
  late Tela14FimPartidaViewModel _model;
  final Duration duracaoPartida = Duration(minutes: 3, seconds: 25);

  final List<JogadorResultado> resultados = [
    JogadorResultado(
      nome: 'Alice',
      pontos: 80,
      premio: 5000,
      perguntasCertas: 8,
      perguntasErradas: 2,
      top3vezes: 3,
    ),
    JogadorResultado(
      nome: 'Bob',
      pontos: 60,
      premio: 3000,
      perguntasCertas: 6,
      perguntasErradas: 4,
      top3vezes: 2,
    ),
    JogadorResultado(
      nome: 'Carlos',
      pontos: 50,
      premio: 2000,
      perguntasCertas: 5,
      perguntasErradas: 5,
      top3vezes: 1,
    ),
    JogadorResultado(
      nome: 'Diana',
      pontos: 30,
      premio: 0,
      perguntasCertas: 3,
      perguntasErradas: 7,
      top3vezes: 0,
    ),
  ];

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
    gameResultInfo = widget.gameResultInfo;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String formatarDuracao(Duration d) {
    String doisDigitos(int n) => n.toString().padLeft(2, "0");
    return "${doisDigitos(d.inMinutes)}:${doisDigitos(d.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: PreferredSize(
  preferredSize: const Size.fromHeight(60),
  child: AppBar(
    centerTitle: true,
    elevation: 0,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFff6f00), Color(0xFFff8f00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
    ),
    title: const Text(
      '🏁 Resultado Final',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 1.2,
      ),
    ),
    backgroundColor: Colors.transparent,
  ),
),

      body: SingleChildScrollView(
        // Envolvendo todo o conteúdo com o SingleChildScrollView
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'trophy',
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.amber, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: const Icon(
                  FontAwesomeIcons.trophy,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Parabéns aos Campeões!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '⏱ Duração da partida: ${formatarDuracao(duracaoPartida)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: ListView.separated(
                key: ValueKey(resultados.length),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: resultados.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                shrinkWrap: true, // Faz a ListView não ocupar o espaço inteiro
                itemBuilder: (context, index) {
                  final jogador = resultados[index];
                  return Column(
                    children: [
                      _buildJogadorCard(jogador, index),
                      if (expandedIndices.contains(index))
                        _buildTabelaExpandida(jogador),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJogadorCard(JogadorResultado jogador, int posicao) {
    Color corBorda;
    Color corTrofeu;

    switch (posicao) {
      case 0:
        corTrofeu = Colors.amber.shade700;
        corBorda = Colors.green.shade600;
        break;
      case 1:
        corTrofeu = Colors.grey.shade400;
        corBorda = Colors.blueGrey.shade400;
        break;
      case 2:
        corTrofeu = Colors.brown.shade300;
        corBorda = Colors.brown.shade600;
        break;
      default:
        corTrofeu = Colors.grey.shade500;
        corBorda = Colors.grey.shade400;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.grey.shade900, // Cor alterada para dar contraste
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: corBorda, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                FaIcon(FontAwesomeIcons.trophy, color: corTrofeu, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    jogador.nome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors
                          .white, // Cor alterada para contraste com fundo escuro
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0), // empurra para a direita
                  child: Column(
                    children: [
                      const Icon(Icons.stars_rounded,
                          color: Colors.amber, size: 22),
                      const SizedBox(height: 4),
                      Text(
                        '${jogador.pontos} pts',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors
                              .white, // Cor alterada para contraste com fundo escuro
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.emoji_events_rounded,
                        size: 20,
                        color: Colors
                            .white70), // Cor alterada para contraste com fundo escuro
                    const SizedBox(width: 6),
                    Text(
                      '${posicao + 1}º Lugar',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors
                              .white70), // Cor alterada para contraste com fundo escuro
                    ),
                  ],
                ),
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.coins,
                        size: 18, color: Colors.orange),
                    const SizedBox(width: 6),
                    Text(
                      '${jogador.premio.toStringAsFixed(0)} KZ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .white70), // Cor alterada para contraste com fundo escuro
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    expandedIndices.contains(posicao)
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors
                        .white70, // Cor alterada para contraste com fundo escuro
                  ),
                  onPressed: () {
                    setState(() {
                      if (expandedIndices.contains(posicao)) {
                        expandedIndices.remove(posicao);
                      } else {
                        expandedIndices.add(posicao);
                      }
                    });
                  },
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
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      padding: const EdgeInsets.fromLTRB(5, 1, 33, 30),
      decoration: BoxDecoration(
        color: Colors.grey.shade800, // Cor alterada para dar contraste
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1.5),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          _buildTableRow('✅ Perguntas Certas', '${jogador.perguntasCertas}'),
          _buildTableRow('❌ Perguntas Erradas', '${jogador.perguntasErradas}'),
          _buildTableRow('🏅 Top 3 vezes', '${jogador.top3vezes ?? 0}'),
          _buildTableRow('⭐ Pontos Totais', '${jogador.pontos}'),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors
                    .white70, // Cor alterada para contraste com fundo escuro
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors
                    .white70, // Cor alterada para contraste com fundo escuro
              ),
            ),
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

  JogadorResultado({
    required this.nome,
    required this.pontos,
    required this.premio,
    required this.perguntasCertas,
    required this.perguntasErradas,
    required this.top3vezes,
  });
}


  // Widget buildResultadoCard(JogadorResultado jogador, int posicao) {
  //   IconData trofeuIcon = FontAwesomeIcons.trophy;
  //   Color corFundo;
  //   Color corTexto = Colors.white;
  //   Color corTrofeu;

  //   switch (posicao) {
  //     case 0:
  //       corFundo = Colors.green.shade700;
  //       corTrofeu = Colors.amber;
  //       break;
  //     case 1:
  //       corFundo = Colors.orange;
  //       corTrofeu = Colors.grey.shade300;
  //       break;
  //     case 2:
  //       corFundo = Colors.brown;
  //       corTrofeu = Colors.brown.shade200;
  //       break;
  //     default:
  //       corFundo = Colors.deepPurple.shade400;
  //       corTrofeu = Colors.white;
  //   }

  //   return Card(
  //     margin: const EdgeInsets.symmetric(vertical: 8),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     elevation: 3,
  //     child: ExpansionTile(
  //       tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       title: Container(
  //         padding: const EdgeInsets.all(12),
  //         decoration: BoxDecoration(
  //           color: corFundo,
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: Row(
  //           children: [
  //             Icon(trofeuIcon, color: corTrofeu, size: 24),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: Text(
  //                 jogador.nome,
  //                 style:
  //                     TextStyle(color: corTexto, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //             Text(
  //               '${jogador.pontos} pts',
  //               style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.yellowAccent),
  //             ),
  //             const SizedBox(width: 10),
  //             Text(
  //               'Kz ${jogador.premio.toStringAsFixed(2)}',
  //               style: TextStyle(color: corTexto, fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         ),
  //       ),
  //       children: [
  //         Container(
  //           width: double.infinity,
  //           color: Colors.white,
  //           padding: const EdgeInsets.all(12),
  //           child: Table(
  //             columnWidths: const {
  //               0: FlexColumnWidth(2),
  //               1: FlexColumnWidth(1),
  //             },
  //             children: [
  //               TableRow(children: [
  //                 Text('Perguntas Certas:',
  //                     style: TextStyle(fontWeight: FontWeight.bold)),
  //                 Text('${jogador.perguntasCertas}'),
  //               ]),
  //               TableRow(children: [
  //                 Text('Perguntas Erradas:',
  //                     style: TextStyle(fontWeight: FontWeight.bold)),
  //                 Text('${jogador.perguntasErradas}'),
  //               ]),
  //               TableRow(children: [
  //                 Text('Top 3 vezes:',
  //                     style: TextStyle(fontWeight: FontWeight.bold)),
  //                 Text('${jogador.top3vezes}'),
  //               ]),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }