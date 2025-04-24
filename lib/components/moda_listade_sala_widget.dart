import 'package:projeto_game_quiz/flutter_flow/flutter_flow_timer.dart';
import 'package:projeto_game_quiz/pages/tela15_sala_customizada/tela15_sala_customizada_widget.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
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
  late ModaListadeSalaModel _model;

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => ModaListadeSalaModel());
    _model.onWaitingPlayersCallback = () => setState(() {});
    _model.getUserIdAsync(() => setState(() {}));
    _model.getRoomAsync(setState);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350.0,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 1.0),
              spreadRadius: 5.0,
            )
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.layerGroup,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 20.0,
                    ),
                    Text(
                      'SALAS DISPONÍVEIS',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter Tight',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
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
                      onPressed: () => context.safePop(),
                    ),
                  ],
                ),
              ),
              if (_model.rooms.isNotEmpty)
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 12.0),
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: _model.rooms.map((e) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              await _model.createMatch(
                                e.roomConfiguration!.numberOfPlayers,
                                e.roomConfiguration!.numberOfQuestions,
                                e.roomConfiguration!.timeToRespond,
                                e.id,
                              );
                            },
                            text:
                                'INICIAR SALA DE ${e.roomConfiguration!.numberOfPlayers}',
                            options: FFButtonOptions(
                              width: 300.0,
                              height: 45.0,
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
                        );
                      }).toList(),
                    ),
                  ),
                ),
              if (_model.isLoadingRooms)
                Center(child: CircularProgressIndicator())
              else if (_model.rooms.isEmpty)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.videogame_asset_outlined,
                          size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'Nenhuma partida encontrada.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 12),
                      IconButton(
                        icon: Icon(Icons.refresh, size: 30),
                        tooltip: 'Recarregar',
                        onPressed: () async {
                          await _model.getRoomAsync(setState);
                        },
                      ),
                    ],
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
                              'PARTIDAS ENTRE AMIGOS',
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
                          Icon(
                            Icons.forest_outlined,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 22.0,
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
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          Tela15SalaCustomizadaViewWidget()),
                                );
                              },
                              text: 'INICIAR PARTIDAS ENTRE AMIGOS',
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
                                      color: Colors.black,
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

              // Flexible(
              //   child: SingleChildScrollView(
              //     padding: EdgeInsets.only(bottom: 12.0),
              //     physics: BouncingScrollPhysics(),
              //     child: Column(children: [
              //       Padding(
              //         padding: EdgeInsets.symmetric(vertical: 4.0),
              //         child: FFButtonWidget(
              //           onPressed: () async {
              //             Navigator.of(context).pushReplacement(
              //               MaterialPageRoute(
              //                   builder: (_) =>
              //                       Tela15SalaCustomizadaViewWidget()),
              //             );
              //           },
              //           text: 'INICIAR SALA ENTRE AMIGOS',
              //           options: FFButtonOptions(
              //             width: 300.0,
              //             height: 45.0,
              //             color: Color.fromARGB(255, 139, 235, 30),
              //             textStyle: FlutterFlowTheme.of(context)
              //                 .titleSmall
              //                 .override(
              //                   fontFamily: 'Inter Tight',
              //                   color: FlutterFlowTheme.of(context).primaryText,
              //                   letterSpacing: 0.0,
              //                 ),
              //             elevation: 0.0,
              //             borderRadius: BorderRadius.circular(8.0),
              //           ),
              //         ),
              //       )
              //     ]),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
