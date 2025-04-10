import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_web_socket_service.dart';
import 'package:projeto_game_quiz/core/api/services/room_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'moda_listade_sala_model.dart';
export 'moda_listade_sala_model.dart';

class ModaListadeSalaWidget extends StatefulWidget {
  const ModaListadeSalaWidget({super.key});

  @override
  State<ModaListadeSalaWidget> createState() => _ModaListadeSalaWidgetState();
}

class _ModaListadeSalaWidgetState extends State<ModaListadeSalaWidget> {
  String userId = "";
  int _minPlayers = 1;
  String matchId = "";
  MatchResponse? matchInfo;
  int _playersConnected = 0;
  bool _isWaitingPlayers = false;
  late ModaListadeSalaModel _model;
  final roomService = RoomService();
  final matchService = MatchService();
  late final MatchWebSocketService _matchWebSocketService;

  void onWaitingPlayers() {
    setState(() {
      _isWaitingPlayers = false;
    });
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModaListadeSalaModel());
    getUserIdAsync();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _matchWebSocketService.disconnect();
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: 350.0,
        height: 370.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(
                0.0,
                1.0,
              ),
              spreadRadius: 5.0,
            )
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.layerGroup,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 20.0,
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        'SALAS DISPONÍVEIS',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Inter Tight',
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                    ),
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      icon: Icon(
                        Icons.close,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        context.safePop();
                      },
                    ),
                  ]
                      .divide(SizedBox(width: 10.0))
                      .addToStart(SizedBox(width: 9.0))
                      .addToEnd(SizedBox(width: 9.0)),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Container(
                  width: double.infinity,
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  await createMatch(4, 5,
                                      "SALA-4-${DateTime.now().minute}${DateTime.now().second}${DateTime.now().hour}");
                                },
                                text: 'INICIAR SALA DE 4',
                                options: FFButtonOptions(
                                  width: 300.0,
                                  height: 45.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFFEC8D0D),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Inter Tight',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                await createMatch(8, 5,
                                    "SALA-8-${DateTime.now().minute}${DateTime.now().second}${DateTime.now().hour}");
                              },
                              text: 'INICIAR SALA DE 8',
                              options: FFButtonOptions(
                                width: 300.0,
                                height: 45.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Color(0xFFEC8D0D),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Inter Tight',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                await createMatch(16, 5,
                                    "SALA-16-${DateTime.now().minute}${DateTime.now().second}${DateTime.now().hour}");
                              },
                              text: 'INICIAR SALA DE 16',
                              options: FFButtonOptions(
                                width: 300.0,
                                height: 45.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Color(0xFFEC8D0D),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Inter Tight',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.diamond_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 22.0,
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'SUPER PARTIDA',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Inter Tight',
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                          FlutterFlowTimer(
                            initialTime: _model.timerInitialTimeMs,
                            getDisplayTime: (value) =>
                                StopWatchTimer.getDisplayTime(value,
                                    milliSecond: false),
                            controller: _model.timerController,
                            updateStateInterval: Duration(milliseconds: 1000),
                            onChanged: (value, displayTime, shouldUpdate) {
                              _model.timerMilliseconds = value;
                              _model.timerValue = displayTime;
                              if (shouldUpdate) safeSetState(() {});
                            },
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  fontFamily: 'Inter Tight',
                                  fontSize: 20.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ]
                            .divide(SizedBox(width: 10.0))
                            .addToStart(SizedBox(width: 9.0))
                            .addToEnd(SizedBox(width: 9.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                context.pushNamed(
                                    Tela06SaladeJogoWidget.routeName);
                              },
                              text: 'INICIAR SUPER PARTIDA',
                              options: FFButtonOptions(
                                width: 300.0,
                                height: 45.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Color(0xFF00B80E),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Inter Tight',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ].divide(SizedBox(height: 5.0)).addToStart(SizedBox(height: 20.0)),
          ),
        ),
      ),
    );
  }

  void showWaitingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                'Procurando participantes disponíveis...\n'
                'Participantes conectados: $_playersConnected / $_minPlayers',
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUserIdAsync() async {
    var _userId = await UserUtil.getUserId();

    setState(() => userId = _userId!);
  }

  Future<void> createMatch(
      int numberOfPlayers, int numberOfQuestions, String nameRoom) async {
    const int timeToRespond = 10;
    try {
      final roomResult = await roomService.createRoomAsync(
        CreateRoomRequest(nameRoom: nameRoom),
      );

      if (roomResult["isSuccess"] != true) {
          await Warning00ErrorUtil.showDialogMessageError(
            context,
            roomResult["error"].detail.message,
            roomResult["error"].detail.details);
        print("Erro ao criar sala");
        return;
      }

      final String roomId = roomResult["data"]["id"];
      final matchRequest = CreateMatchRequest(
        isSingleWinner: true,
        timeToRespond: timeToRespond,
        numberOfPlayers: numberOfPlayers,
        matchStartDate: DateTime.now(),
        endDateOfMatch: DateTime.now().add(
          Duration(seconds: timeToRespond * numberOfQuestions),
        ),
        numberOfQuestions: numberOfQuestions,
        numberOfAnswerOptions: 5,
        minimumNumberOfPlayers: numberOfPlayers,
        minimumAmountToPlay: 500,
        premiumRate: 0.75,
      );

      final matchResult =
          await matchService.createMatchAsync(roomId, matchRequest);

      if (matchResult["isSuccess"] != true) {
          await Warning00ErrorUtil.showDialogMessageError(
            context,
            matchResult["error"].detail.message,
            matchResult["error"].detail.details);
        print("Erro ao criar partida");
        return;
      }

      final String matchId = matchResult["data"]["id"];
      final playerResult = await matchService.addPlayerMatchAsync(
        matchId,
        AddPlayerMatchRequest(playerId: userId),
      );

      if (playerResult["isSuccess"] != true) {
        await Warning00ErrorUtil.showDialogMessageError(
            context,
            playerResult["error"].detail.message,
            playerResult["error"].detail.details);
        print("Erro ao adicionar jogador à partida");
        return;
      }
      if (_isWaitingPlayers) {
        showWaitingDialog();
      }

      await getMatchByMatchIdAsync();
      await getWebSocketWaitForPlayerAsync();
      Navigator.of(context).pop();
    } catch (e) {
      print("Erro inesperado ao criar partida: $e");
    }
  }

  Future<void> getMatchByMatchIdAsync() async {
    var resultMatch = await matchService.getMatchByMatchIdAsync(matchId);

    if (resultMatch["isSuccess"]) {
      setState(() {
        matchInfo = resultMatch["data"];
      });
    }
  }

  Future<void> getWebSocketWaitForPlayerAsync() async {
    _matchWebSocketService = MatchWebSocketService(
      matchId: matchId,
      context: context,
      matchInfo: matchInfo!,
      onOther: onWaitingPlayers,
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
}
