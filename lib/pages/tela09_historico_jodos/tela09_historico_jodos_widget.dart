import 'package:projeto_game_quiz/pages/tela03_principal/tela03_principal_widget.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'tela09_historico_jodos_model.dart';
export 'tela09_historico_jodos_model.dart';

class Tela09HistoricoJodosWidget extends StatefulWidget {
  const Tela09HistoricoJodosWidget({super.key});

  static String routeName = 'Tela09HistoricoJodos';
  static String routePath = '/tela09HistoricoJodos';

  @override
  State<Tela09HistoricoJodosWidget> createState() =>
      _Tela09HistoricoJodosWidgetState();
}

class _Tela09HistoricoJodosWidgetState
    extends State<Tela09HistoricoJodosWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Tela09HistoricoJodosModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela09HistoricoJodosModel());
    _model.load(setState);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsetsDirectional.only(start: 18.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => Tela03PrincipalWidget()),
                );
              },
            ),
          ),
          title: const Text(
            'HISTÓRICO DE JOGOS',
            style: TextStyle(
              color: Color(0xFFEC8D0D),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 4.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: _model.rankings == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        // Cabeçalho
                        Container(
                          height: 50.0,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(
                                flex: 2,
                                child: Text('DATA',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        color: Colors.black)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('RESULTADO',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        color: Colors.black)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('TEMPO(s)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        color: Colors.black)),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text('PONTOS',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        color: Colors.black)),
                              ),
                            ],
                          ),
                        ),

                        ..._model.rankings!.asMap().entries.map((entry) {
                          final jogo = entry.value;

                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    jogo.isExpanded = !jogo.isExpanded!;
                                  });
                                  if (jogo.isExpanded!) {
                                    _model.historys = null;
                                    _model.getHistoryUserdAsync(
                                        setState, jogo.matchId);
                                  }
                                },
                                child: Container(
                                  height: 50.0,
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: jogo.isWinner == true
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(jogo.createdAt != null
                                            ? DateFormat('dd/MM H:mm')
                                                .format(jogo.createdAt!)
                                            : ''),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(jogo.isWinner == true
                                            ? 'Vencedor'
                                            : 'Perdedor'),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text('${jogo.totalResponseTime}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      // Expanded(
                                      //   flex: 2,
                                      //   child: Text('${jogo.totalWrongAnswer}',
                                      //       overflow: TextOverflow.ellipsis,
                                      //       maxLines: 1,
                                      //       style: TextStyle(
                                      //           fontWeight: FontWeight.w600)),
                                      // ),
                                      // Expanded(
                                      //   flex: 2,
                                      //   child: Text(
                                      //       '${jogo.totalCorrectAnswer}',
                                      //       overflow: TextOverflow.ellipsis,
                                      //       maxLines: 1,
                                      //       style: TextStyle(
                                      //           fontWeight: FontWeight.w600)),
                                      // ),
                                      Expanded(
                                        flex: 1,
                                        child: Text('${jogo.totalScore}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (jogo.isExpanded!) ...[
                                if (_model.historys == null)
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  )
                                else
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 6, bottom: 10),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: (_model.historys ?? [])
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final p = entry.value;

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              p.isExpanded = !p.isExpanded!;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            decoration: BoxDecoration(
                                              color:
                                                  (p.optionAnswer?.isCorrect ??
                                                          false)
                                                      ? Colors.green[100]
                                                      : Colors.red[100],
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: (p.optionAnswer
                                                              ?.isCorrect ??
                                                          false)
                                                      ? Colors.green
                                                      : Colors.red),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8,
                                                      horizontal: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          p.question
                                                                  ?.utterance ??
                                                              '',
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      Icon(p.isExpanded!
                                                          ? Icons.expand_less
                                                          : Icons.expand_more),
                                                    ],
                                                  ),
                                                ),
                                                if (p.isExpanded!)
                                                  Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 14,
                                                        vertical: 8),
                                                    color: Colors.grey,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            'SUA RESPOSTA: ${p.optionAnswer?.textOption ?? '---'}'),
                                                        Text(
                                                            'TEMPO DE RESPOSTA: ${p.responseTimeInSecond}s'),
                                                        Text(
                                                            'PONTO: ${_model.matchInfo == null ? 0 : _model.matchInfo!.room!.roomConfiguration!.timeToRespond - p.responseTimeInSecond!}'),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
