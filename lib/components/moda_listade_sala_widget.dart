import 'package:projeto_game_quiz/pages/tela15_sala_customizada/tela15_sala_customizada_widget.dart';
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
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 12.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 4.0),
            )
          ],
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.layerGroup,
                        color: Color(0xFFEC8D0D),
                        size: 20.0,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'SALAS DISPONÍVEIS',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Inter Tight',
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 20.0,
                    buttonSize: 36.0,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    icon: Icon(
                      Icons.close,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 20.0,
                    ),
                    onPressed: () => context.safePop(),
                  ),
                ],
              ),
            ),

            // Conteúdo principal
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    // Lista de salas
                    if (_model.isLoadingRooms)
                      Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      )
                    else if (_model.rooms.isEmpty)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.videogame_asset_outlined,
                              size: 48,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Nenhuma sala disponível no momento',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter Tight',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            SizedBox(height: 16),
                            FFButtonWidget(
                              onPressed: () async {
                                await _model.getRoomAsync(setState);
                              },
                              text: 'Recarregar',
                              icon: Icon(
                                Icons.refresh,
                                size: 16,
                              ),
                              options: FFButtonOptions(
                                width: 150,
                                height: 40,
                                padding: EdgeInsets.all(0),
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter Tight',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                    ),
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: _model.rooms.map((e) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEC8D0D),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1,
                                    ),
                                  ),
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
                                        'Entrar na sala (${e.roomConfiguration!.numberOfPlayers} jogadores)'
                                            .toUpperCase(),
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 50.0,
                                      padding: EdgeInsets.all(0),
                                      color: Colors.transparent,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Inter Tight',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                      elevation: 0,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.diamond_rounded,
                                color: const Color(0xFF00B80E),
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'PARTIDAS ENTRE AMIGOS',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: 'Inter Tight',
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.forest_outlined,
                                color: const Color(0xFF00B80E),
                                size: 18,
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          FFButtonWidget(
                            onPressed: () async {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        Tela15SalaCustomizadaViewWidget()),
                              );
                            },
                            text: 'CRIAR SALA PERSONALIZADA',
                            icon: Icon(
                              Icons.group_add,
                              size: 18,
                            ),
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50,
                              padding: EdgeInsets.all(0),
                              color: const Color(0xFF00B80E),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Inter Tight',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                              elevation: 2,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
