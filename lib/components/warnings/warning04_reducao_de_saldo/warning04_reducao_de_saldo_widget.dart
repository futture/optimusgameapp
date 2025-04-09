import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_web_socket_service.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/pages/tela06_salade_jogo/tela06_salade_jogo_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'warning04_reducao_de_saldo_model.dart';
export 'warning04_reducao_de_saldo_model.dart';

class Warning04ReducaoDeSaldoWidget extends StatefulWidget {
  final dynamic matchInfo;

  const Warning04ReducaoDeSaldoWidget({
    super.key,
    this.matchInfo,
  });

  @override
  State<Warning04ReducaoDeSaldoWidget> createState() =>
      _Warning04ReducaoDeSaldoWidgetState();
}

class _Warning04ReducaoDeSaldoWidgetState
    extends State<Warning04ReducaoDeSaldoWidget> {
  final _matchService = MatchService();
  late Warning04ReducaoDeSaldoModel _model;
  late final MatchWebSocketService _matchWebSocketService;

  late MatchResponse matchInfo;
  // Novas variáveis
  bool _isWaitingPlayers = false;
  int _playersConnected = 0;
  int _minPlayers = 1;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Warning04ReducaoDeSaldoModel());
    matchInfo = widget.matchInfo;
  }

  @override
  void dispose() {
    _matchWebSocketService.disconnect();
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isWaitingPlayers) {
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: Text("Aguardando jogadores..."),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Jogadores conectados: $_playersConnected / $_minPlayers',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      });
    }

    return Container(
      width: 280.0,
      height: 210.0,
      constraints: BoxConstraints(
        minWidth: 280.0,
        minHeight: 200.0,
        maxWidth: 400.0,
        maxHeight: 250.0,
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 7.0, 0.0, 0.0),
            child: Icon(
              Icons.warning_amber,
              color: Color(0xFFFF0000),
              size: 60.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Atenção: ao se inscrever nesta sala será reduzido do seu saldo a taxa de ${matchInfo.matchConfiguration!.minimumAmountToPlay}Kz para poder jogar',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
            child: FFButtonWidget(
              onPressed: () async {
                setState(() {
                  _isWaitingPlayers = true;
                });

                await joinTheMatchAsync();
              },
              text: 'Confirmar Inscrição',
              options: FFButtonOptions(
                height: 45.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                color: Color(0xFF00C804),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter Tight',
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                elevation: 0.0,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> joinTheMatchAsync() async {
    var result = await _matchService.addPlayerMatchAsync(
      matchInfo.id,
      AddPlayerMatchRequest(
        playerId: "792159b0-05ae-4fa2-b05e-8cf0e3c68a24",
      ),
    );

    if (result != null) {
      getWebSocketWaitForPlayerAsync();
    }
  }

  Future<void> getWebSocketWaitForPlayerAsync() async {
    _matchWebSocketService = MatchWebSocketService(
      matchId: matchInfo.id,
      context: context,
      matchInfo: matchInfo,
      onMatchUpdate: (match) {
        setState(() {
          _playersConnected = match.playersConnected;
          _minPlayers = match.minPlayers;
          _isWaitingPlayers = true;
        });
      },
      onError: (error) => print("Erro no WebSocket: $error"),
      onDone: () => print("Conexão WebSocket encerrada."),
    );

    _matchWebSocketService.connect();
  }

  Future<void> startMatchAsync() async {
    var resultStartMatch = await _matchService.startMatchAsync(matchInfo.id);

    if (resultStartMatch["isSuccess"]) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => Tela06SaladeJogoWidget(matchInfo: matchInfo),
        ),
      );
    }
  }
}
