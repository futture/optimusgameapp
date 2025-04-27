import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_game_quiz/components/moda_menu_pagian_inicial_widget.dart';
import 'package:projeto_game_quiz/core/models/common/error_response.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_icon_button.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/pages/tela03_principal/tela03_principal_widget.dart';

class Tela16ErroInformacaoPartidaViewWidget extends StatefulWidget {
  final DetailErrorResponse error;
  final MatchResponse? matchResponse;

  const Tela16ErroInformacaoPartidaViewWidget({
    Key? key,
    required this.error,
    required this.matchResponse,
  }) : super(key: key);

  @override
  _Tela16ErroInformacaoPartidaViewWidgetState createState() =>
      _Tela16ErroInformacaoPartidaViewWidgetState();
}

class _Tela16ErroInformacaoPartidaViewWidgetState
    extends State<Tela16ErroInformacaoPartidaViewWidget>
    with TickerProviderStateMixin {
  bool _expandirInformacoes = false;
  //late Tela16ErroInformacaoPartidaViewModel _model;

  @override
  void initState() {
    super.initState();
    //_model = createModel(context, () => Tela16ErroInformacaoPartidaViewModel());
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
        backgroundColor: Colors.white,
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
        
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Card(
                    color: const Color(0xFF2D2D2D),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 50),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              widget.error.detail?.message ?? 'Ocorreu um erro',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                              height: 30, thickness: 1, color: Colors.white30),
                          const SizedBox(height: 10),
                          _buildInfoLine(
                              widget.error.detail?.details ?? 'Sem detalhes'),
                          const Divider(
                              height: 30, thickness: 1, color: Colors.white30),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _expandirInformacoes = !_expandirInformacoes;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Informações da Partida',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue.shade400,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  _expandirInformacoes
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.blue.shade400,
                                ),
                              ],
                            ),
                          ),
                          AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: _buildInformacoesPartida(),
                            ),
                            crossFadeState: _expandirInformacoes
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 300),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Tela03PrincipalWidget(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'INICIO',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoLine(String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Center(
          child: Text(
            '$content',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildInformacoesPartida() {
    if (widget.matchResponse == null) {
      return const Text('Sem informações da partida.',
          style: TextStyle(color: Colors.white70));
    }

    final match = widget.matchResponse!;
    final config = match.room?.roomConfiguration;

    if (config == null) {
      return const Text('Configurações da sala indisponíveis.',
          style: TextStyle(color: Colors.white70));
    }

    final premio = config.premiumRate *
        (config.minimumAmountToPlay * config.numberOfPlayers);
    final duracao = (config.timeToRespond * config.numberOfQuestions);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem(
            Icons.group, 'Jogadores', '${match.matchPlayers?.length ?? 0}'),
        _buildInfoItem(
            Icons.emoji_events, 'Prêmio', '${premio.toStringAsFixed(2)} Kz'),
        _buildInfoItem(Icons.attach_money, 'Taxa de entrada',
            '${config.minimumAmountToPlay} Kz'),
        _buildInfoItem(
            Icons.timer, 'Duração', '${duracao.toStringAsFixed(0)} segundos'),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue.shade400),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
