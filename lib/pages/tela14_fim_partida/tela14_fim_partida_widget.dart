import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Fim da Partida'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(FontAwesomeIcons.trophy, size: 60, color: Colors.amber),
            const SizedBox(height: 10),
            Text(
              'Parabéns aos campeões!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Duração da partida: ${formatarDuracao(duracaoPartida)}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: resultados.length,
                itemBuilder: (context, index) {
                  final jogador = resultados[index];
                  return Column(
                    children: [
                      MatchCard(jogador, index),
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

  Widget MatchCard(JogadorResultado jogador, int posicao) {
    IconData trofeuIcon = FontAwesomeIcons.trophy;
    Color corFundo;
    Color corTrofeu;

    switch (posicao) {
      case 0:
        corFundo = Colors.green.shade700;
        corTrofeu = Colors.amber;
        break;
      case 1:
        corFundo = Colors.orange;
        corTrofeu = Colors.grey.shade300;
        break;
      case 2:
        corFundo = Colors.brown;
        corTrofeu = Colors.brown.shade200;
        break;
      default:
        corFundo = Colors.deepPurple.shade400;
        corTrofeu = Colors.white;
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeIn,
      width: 350.0,
      height: 120.0,
      decoration: BoxDecoration(color: Color(0xFFF1F4F8)),
      alignment: Alignment.center,
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 350.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: Color(0xFFEC8D0D),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: Color(0x33000000),
                    offset: Offset(0.0, 2.0),
                    spreadRadius: 5.0,
                  )
                ],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200.0,
                            height: 25.0,
                            child: Row(
                              children: [
                                FaIcon(trofeuIcon, color: corTrofeu, size: 24),
                                Flexible(
                                  child: Text(
                                    '${jogador.nome}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          fontFamily: 'Inter Tight',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 5.0)),
                            ),
                          ),
                          Container(
                            width: 110.0,
                            height: 25.0,
                            child: Row(
                              children: [
                                Icon(Icons.point_of_sale, size: 22.0),
                                Flexible(
                                  child: Text(
                                    '${jogador.pontos}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ].divide(SizedBox(width: 2.0)),
                            ),
                          ),
                        ]
                            .addToStart(SizedBox(width: 10.0))
                            .addToEnd(SizedBox(width: 10.0)),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 130.0,
                            height: 25.0,
                            child: Row(
                              children: [
                                Icon(Icons.people_alt_rounded, size: 20.0),
                                Text('${posicao + 1}'),
                                Text('º Posição'),
                              ].divide(SizedBox(width: 5.0)),
                            ),
                          ),
                          Container(
                            width: 90.0,
                            height: 25.0,
                            child: Row(
                              children: [
                                FaIcon(FontAwesomeIcons.donate, size: 20.0),
                                Flexible(
                                  child: Text(
                                    '${jogador.premio.toStringAsFixed(0)}KZ',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ].divide(SizedBox(width: 5.0)),
                            ),
                          ),
                        ]
                            .divide(SizedBox(width: 81.0))
                            .addToStart(SizedBox(width: 15.0))
                            .addToEnd(SizedBox(width: 3.0)),
                      ),
                    ]
                        .divide(SizedBox(height: 10.0))
                        .around(SizedBox(height: 10.0)),
                  ),
                  FFButtonWidget(
                    onPressed: () {
                      setState(() {
                        if (expandedIndices.contains(posicao)) {
                          expandedIndices.remove(posicao);
                        } else {
                          expandedIndices.add(posicao);
                        }
                      });
                    },
                    text: '',
                    options: FFButtonOptions(
                      width: 350.0,
                      height: 80.0,
                      color: Color(0x004B39EF),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
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