import 'package:projeto_game_quiz/core/api/utils/token_util.dart';
import 'package:projeto_game_quiz/pages/deposit_history/deposit_history_widget.dart';
import 'package:projeto_game_quiz/pages/tela17_notificacao/tela17_notificacao_widget.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'moda_menu_pagian_inicial_model.dart';
export 'moda_menu_pagian_inicial_model.dart';

// import 'package:projeto_game_quiz/core/api/utils/token_util.dart';
// import 'package:projeto_game_quiz/pages/deposit_history/deposit_history_widget.dart';
// import 'package:projeto_game_quiz/pages/tela17_notificacao/tela17_notificacao_widget.dart';

class ModaMenuPagianInicialWidget extends StatefulWidget {
  final bool? isMainScreen;
  const ModaMenuPagianInicialWidget({super.key, this.isMainScreen});

  @override
  State<ModaMenuPagianInicialWidget> createState() =>
      _ModaMenuPagianInicialWidgetState();
}

class _ModaMenuPagianInicialWidgetState
    extends State<ModaMenuPagianInicialWidget> {
  late ModaMenuPagianInicialModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModaMenuPagianInicialModel());
    _model.getUserIdAsync();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: 350.0,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu',
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
              Divider(
                thickness: 2.0,
                color: Colors.black,
                indent: 20.0,
                endIndent: 20.0,
              ),
              _buildMenuItem(
                icon: Icons.person,
                text: 'Meu Perfil',
                onTap: () => context.pushNamed(Tela04PerfilWidget.routeName),
              ),
              _buildMenuItem(
                icon: Icons.account_balance,
                text: 'Dados Financeiros',
                onTap: () => context.pushNamed(Tela07FinancasWidget.routeName),
              ),
              _buildMenuItem(
                icon: FontAwesomeIcons.wallet,
                text: 'Carteira',
                onTap: () => context.pushNamed(Tela08CarteiraWidget.routeName),
              ),
              _buildMenuItem(
                icon: Icons.history_sharp,
                text: 'Histórico de Jogos',
                onTap: () =>
                    context.pushNamed(Tela09HistoricoJodosWidget.routeName),
              ),
              _buildMenuItem(
                icon: Icons.history_sharp,
                text: 'Histórico Depósito',
                onTap: () =>
                    context.pushNamed(DepositHistoryScreenWidget.routeName),
              ),
              _buildMenuItem(
                icon: Icons.notification_important,
                text: 'Notificações',
                onTap: () =>
                    context.pushNamed(Tela17NotificacaoViewWidget.routeName),
              ),
              if (widget.isMainScreen == null)
                _buildMenuItem(
                  icon: Icons.home_outlined,
                  text: 'Inicio',
                  onTap: () =>
                      context.pushNamed(Tela03PrincipalWidget.routeName),
                ),
              Divider(
                thickness: 2.0,
                color: Colors.black,
                indent: 20.0,
                endIndent: 20.0,
              ),
              _buildMenuItem(
                icon: Icons.logout_sharp,
                text: 'Terminar Sessão',
                onTap: () async {
                  try {
                    TokenUtil.removeToken();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sessão terminada com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    await _model.logoutAsync();
                    context.pushNamed(Tela00LoginWidget.routeName);
                  } catch (e) {
                    print('Erro ao terminar sessão: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Erro ao terminar sessão. Tente novamente.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: 45.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(icon, size: 20.0),
              SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  text,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

// class ModaMenuPagianInicialWidget extends StatefulWidget {
//   const ModaMenuPagianInicialWidget({super.key});

//   @override
//   State<ModaMenuPagianInicialWidget> createState() =>
//       _ModaMenuPagianInicialWidgetState();
// }

// class _ModaMenuPagianInicialWidgetState
//     extends State<ModaMenuPagianInicialWidget> {
//   late ModaMenuPagianInicialModel _model;

//   @override
//   void setState(VoidCallback callback) {
//     super.setState(callback);
//     _model.onUpdate();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => ModaMenuPagianInicialModel());
//     _model.getUserIdAsync();
//   }

//   @override
//   void dispose() {
//     _model.maybeDispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: AlignmentDirectional(0.0, 0.0),
//       child: Container(
//         width: 350.0,
//         height: 450.0,
//         decoration: BoxDecoration(
//           color: FlutterFlowTheme.of(context).primaryBackground,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 4.0,
//               color: Color(0x33000000),
//               offset: Offset(
//                 0.0,
//                 1.0,
//               ),
//               spreadRadius: 5.0,
//             )
//           ],
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Align(
//                 alignment: AlignmentDirectional(0.0, 0.0),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Align(
//                       alignment: AlignmentDirectional(0.0, 0.0),
//                       child: Text(
//                         'Menu',
//                         style:
//                             FlutterFlowTheme.of(context).titleMedium.override(
//                                   fontFamily: 'Inter Tight',
//                                   fontSize: 18.0,
//                                   letterSpacing: 0.0,
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                       ),
//                     ),
//                     FlutterFlowIconButton(
//                       borderRadius: 8.0,
//                       buttonSize: 40.0,
//                       fillColor:
//                           FlutterFlowTheme.of(context).secondaryBackground,
//                       icon: Icon(
//                         Icons.close,
//                         color: FlutterFlowTheme.of(context).primaryText,
//                         size: 24.0,
//                       ),
//                       onPressed: () async {
//                         context.safePop();
//                       },
//                     ),
//                   ]
//                       .divide(SizedBox(width: 140.0))
//                       .addToStart(SizedBox(width: 0.0))
//                       .addToEnd(SizedBox(width: 0.0)),
//                 ),
//               ),
//               SizedBox(
//                 width: 290.0,
//                 child: Divider(
//                   thickness: 2.0,
//                   color: Colors.black,
//                 ),
//               ),
//               Align(
//                 alignment: AlignmentDirectional(0.0, 0.0),
//                 child: Container(
//                   width: double.infinity,
//                   height: 280.0,
//                   decoration: BoxDecoration(
//                     color: FlutterFlowTheme.of(context).primaryBackground,
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Container(
//                         width: 290.0,
//                         height: 45.0,
//                         decoration: BoxDecoration(
//                           color:
//                               FlutterFlowTheme.of(context).secondaryBackground,
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         child: Container(
//                           width: double.infinity,
//                           height: double.infinity,
//                           child: Stack(
//                             alignment: AlignmentDirectional(0.0, 0.0),
//                             children: [
//                               Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Icon(
//                                     Icons.person,
//                                     color: FlutterFlowTheme.of(context)
//                                         .primaryText,
//                                     size: 20.0,
//                                   ),
//                                   Text(
//                                     'Meu Perfil',
//                                     style: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .override(
//                                           fontFamily: 'Inter',
//                                           letterSpacing: 0.0,
//                                         ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         140.0, 0.0, 0.0, 0.0),
//                                     child: Icon(
//                                       Icons.arrow_forward_ios,
//                                       color: FlutterFlowTheme.of(context)
//                                           .primaryText,
//                                       size: 19.0,
//                                     ),
//                                   ),
//                                 ]
//                                     .divide(SizedBox(width: 11.0))
//                                     .addToStart(SizedBox(width: 10.0))
//                                     .addToEnd(SizedBox(width: 5.0)),
//                               ),
//                               Opacity(
//                                 opacity: 0.0,
//                                 child: FFButtonWidget(
//                                   onPressed: () async {
//                                     context.pushNamed(
//                                         Tela04PerfilWidget.routeName);
//                                   },
//                                   text: 'Button',
//                                   options: FFButtonOptions(
//                                     width: 340.0,
//                                     height: 45.0,
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         16.0, 0.0, 16.0, 0.0),
//                                     iconPadding: EdgeInsetsDirectional.fromSTEB(
//                                         0.0, 0.0, 0.0, 0.0),
//                                     color: Color(0x004B39EF),
//                                     textStyle: FlutterFlowTheme.of(context)
//                                         .titleSmall
//                                         .override(
//                                           fontFamily: 'Inter Tight',
//                                           color: Color(0x00FFFFFF),
//                                           letterSpacing: 0.0,
//                                         ),
//                                     elevation: 0.0,
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 290.0,
//                         height: 45.0,
//                         decoration: BoxDecoration(
//                           color:
//                               FlutterFlowTheme.of(context).secondaryBackground,
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         child: Container(
//                           width: double.infinity,
//                           height: double.infinity,
//                           child: Stack(
//                             alignment: AlignmentDirectional(0.0, 0.0),
//                             children: [
//                               Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Icon(
//                                     Icons.account_balance,
//                                     color: FlutterFlowTheme.of(context)
//                                         .primaryText,
//                                     size: 20.0,
//                                   ),
//                                   Text(
//                                     'Dados FInanceiros',
//                                     style: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .override(
//                                           fontFamily: 'Inter',
//                                           letterSpacing: 0.0,
//                                         ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         85.0, 0.0, 0.0, 0.0),
//                                     child: Icon(
//                                       Icons.arrow_forward_ios,
//                                       color: FlutterFlowTheme.of(context)
//                                           .primaryText,
//                                       size: 19.0,
//                                     ),
//                                   ),
//                                 ]
//                                     .divide(SizedBox(width: 11.0))
//                                     .addToStart(SizedBox(width: 10.0))
//                                     .addToEnd(SizedBox(width: 5.0)),
//                               ),
//                               Opacity(
//                                 opacity: 0.0,
//                                 child: FFButtonWidget(
//                                   onPressed: () async {
//                                     context.pushNamed(
//                                         Tela07FinancasWidget.routeName);
//                                   },
//                                   text: 'Button',
//                                   options: FFButtonOptions(
//                                     width: 340.0,
//                                     height: 45.0,
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         16.0, 0.0, 16.0, 0.0),
//                                     iconPadding: EdgeInsetsDirectional.fromSTEB(
//                                         0.0, 0.0, 0.0, 0.0),
//                                     color: Color(0x004B39EF),
//                                     textStyle: FlutterFlowTheme.of(context)
//                                         .titleSmall
//                                         .override(
//                                           fontFamily: 'Inter Tight',
//                                           color: Color(0x00FFFFFF),
//                                           letterSpacing: 0.0,
//                                         ),
//                                     elevation: 0.0,
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 290.0,
//                         height: 45.0,
//                         decoration: BoxDecoration(
//                           color:
//                               FlutterFlowTheme.of(context).secondaryBackground,
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         child: Container(
//                           width: double.infinity,
//                           height: double.infinity,
//                           child: Stack(
//                             alignment: AlignmentDirectional(0.0, 0.0),
//                             children: [
//                               Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   FaIcon(
//                                     FontAwesomeIcons.wallet,
//                                     color: FlutterFlowTheme.of(context)
//                                         .primaryText,
//                                     size: 20.0,
//                                   ),
//                                   Text(
//                                     'Carteira',
//                                     style: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .override(
//                                           fontFamily: 'Inter',
//                                           letterSpacing: 0.0,
//                                         ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         155.0, 0.0, 0.0, 0.0),
//                                     child: Icon(
//                                       Icons.arrow_forward_ios,
//                                       color: FlutterFlowTheme.of(context)
//                                           .primaryText,
//                                       size: 19.0,
//                                     ),
//                                   ),
//                                 ]
//                                     .divide(SizedBox(width: 11.0))
//                                     .addToStart(SizedBox(width: 10.0))
//                                     .addToEnd(SizedBox(width: 5.0)),
//                               ),
//                               Opacity(
//                                 opacity: 0.0,
//                                 child: FFButtonWidget(
//                                   onPressed: () async {
//                                     context.pushNamed(
//                                         Tela08CarteiraWidget.routeName);
//                                   },
//                                   text: 'Button',
//                                   options: FFButtonOptions(
//                                     width: 340.0,
//                                     height: 45.0,
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         16.0, 0.0, 16.0, 0.0),
//                                     iconPadding: EdgeInsetsDirectional.fromSTEB(
//                                         0.0, 0.0, 0.0, 0.0),
//                                     color: Color(0x004B39EF),
//                                     textStyle: FlutterFlowTheme.of(context)
//                                         .titleSmall
//                                         .override(
//                                           fontFamily: 'Inter Tight',
//                                           color: Color(0x00FFFFFF),
//                                           letterSpacing: 0.0,
//                                         ),
//                                     elevation: 0.0,
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 290.0,
//                         height: 45.0,
//                         decoration: BoxDecoration(
//                           color:
//                               FlutterFlowTheme.of(context).secondaryBackground,
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         child: Container(
//                           width: double.infinity,
//                           height: double.infinity,
//                           child: Stack(
//                             alignment: AlignmentDirectional(0.0, 0.0),
//                             children: [
//                               Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Icon(
//                                     Icons.history_sharp,
//                                     color: FlutterFlowTheme.of(context)
//                                         .primaryText,
//                                     size: 20.0,
//                                   ),
//                                   Text(
//                                     'Histórico de Jogos',
//                                     style: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .override(
//                                           fontFamily: 'Inter',
//                                           letterSpacing: 0.0,
//                                         ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         85.0, 0.0, 0.0, 0.0),
//                                     child: Icon(
//                                       Icons.arrow_forward_ios,
//                                       color: FlutterFlowTheme.of(context)
//                                           .primaryText,
//                                       size: 19.0,
//                                     ),
//                                   ),
//                                 ]
//                                     .divide(SizedBox(width: 11.0))
//                                     .addToStart(SizedBox(width: 10.0))
//                                     .addToEnd(SizedBox(width: 5.0)),
//                               ),
//                               Opacity(
//                                 opacity: 0.0,
//                                 child: FFButtonWidget(
//                                   onPressed: () async {
//                                     context.pushNamed(
//                                         Tela09HistoricoJodosWidget.routeName);
//                                   },
//                                   text: 'Button',
//                                   options: FFButtonOptions(
//                                     width: 340.0,
//                                     height: 45.0,
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         16.0, 0.0, 16.0, 0.0),
//                                     iconPadding: EdgeInsetsDirectional.fromSTEB(
//                                         0.0, 0.0, 0.0, 0.0),
//                                     color: Color(0x004B39EF),
//                                     textStyle: FlutterFlowTheme.of(context)
//                                         .titleSmall
//                                         .override(
//                                           fontFamily: 'Inter Tight',
//                                           color: Color(0x00FFFFFF),
//                                           letterSpacing: 0.0,
//                                         ),
//                                     elevation: 0.0,
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 290.0,
//                         height: 45.0,
//                         decoration: BoxDecoration(
//                           color:
//                               FlutterFlowTheme.of(context).secondaryBackground,
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         child: Container(
//                           width: double.infinity,
//                           height: double.infinity,
//                           child: Stack(
//                             alignment: AlignmentDirectional(0.0, 0.0),
//                             children: [
//                               Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Icon(
//                                     Icons.history_sharp,
//                                     color: FlutterFlowTheme.of(context)
//                                         .primaryText,
//                                     size: 20.0,
//                                   ),
//                                   Text(
//                                     'Histórico Depósito',
//                                     style: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .override(
//                                           fontFamily: 'Inter',
//                                           letterSpacing: 0.0,
//                                         ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         85.0, 0.0, 0.0, 0.0),
//                                     child: Icon(
//                                       Icons.arrow_forward_ios,
//                                       color: FlutterFlowTheme.of(context)
//                                           .primaryText,
//                                       size: 19.0,
//                                     ),
//                                   ),
//                                 ]
//                                     .divide(SizedBox(width: 11.0))
//                                     .addToStart(SizedBox(width: 10.0))
//                                     .addToEnd(SizedBox(width: 5.0)),
//                               ),
//                               Opacity(
//                                 opacity: 0.0,
//                                 child: FFButtonWidget(
//                                   onPressed: () async {
//                                     context.pushNamed(
//                                         DepositHistoryScreenWidget.routeName);
//                                   },
//                                   text: 'Button',
//                                   options: FFButtonOptions(
//                                     width: 340.0,
//                                     height: 45.0,
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         16.0, 0.0, 16.0, 0.0),
//                                     iconPadding: EdgeInsetsDirectional.fromSTEB(
//                                         0.0, 0.0, 0.0, 0.0),
//                                     color: Color(0x004B39EF),
//                                     textStyle: FlutterFlowTheme.of(context)
//                                         .titleSmall
//                                         .override(
//                                           fontFamily: 'Inter Tight',
//                                           color: Color(0x00FFFFFF),
//                                           letterSpacing: 0.0,
//                                         ),
//                                     elevation: 0.0,
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 290.0,
//                         height: 45.0,
//                         decoration: BoxDecoration(
//                           color:
//                               FlutterFlowTheme.of(context).secondaryBackground,
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         child: Container(
//                           width: double.infinity,
//                           height: double.infinity,
//                           child: Stack(
//                             alignment: AlignmentDirectional(0.0, 0.0),
//                             children: [
//                               Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Icon(
//                                     Icons.info_outline,
//                                     color: FlutterFlowTheme.of(context)
//                                         .primaryText,
//                                     size: 20.0,
//                                   ),
//                                   Text(
//                                     'Notificações',
//                                     style: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .override(
//                                           fontFamily: 'Inter',
//                                           letterSpacing: 0.0,
//                                         ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         100.0, 0.0, 0.0, 0.0),
//                                     child: Icon(
//                                       Icons.arrow_forward_ios,
//                                       color: FlutterFlowTheme.of(context)
//                                           .primaryText,
//                                       size: 19.0,
//                                     ),
//                                   ),
//                                 ]
//                                     .divide(SizedBox(width: 11.0))
//                                     .addToStart(SizedBox(width: 10.0))
//                                     .addToEnd(SizedBox(width: 5.0)),
//                               ),
//                               Opacity(
//                                 opacity: 0.0,
//                                 child: FFButtonWidget(
//                                   onPressed: () {
//                                     Navigator.of(context).push(
//                                       MaterialPageRoute(
//                                         builder: (_) =>
//                                             Tela17NotificacaoViewWidget(),
//                                       ),
//                                     );
//                                     print('centroDeAjuda pressed ...');
//                                   },
//                                   text: 'Button',
//                                   options: FFButtonOptions(
//                                     width: 340.0,
//                                     height: 45.0,
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         16.0, 0.0, 16.0, 0.0),
//                                     iconPadding: EdgeInsetsDirectional.fromSTEB(
//                                         0.0, 0.0, 0.0, 0.0),
//                                     color: Color(0x004B39EF),
//                                     textStyle: FlutterFlowTheme.of(context)
//                                         .titleSmall
//                                         .override(
//                                           fontFamily: 'Inter Tight',
//                                           color: Color(0x00FFFFFF),
//                                           letterSpacing: 0.0,
//                                         ),
//                                     elevation: 0.0,
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // Container(
//                       //   width: 290.0,
//                       //   height: 45.0,
//                       //   decoration: BoxDecoration(
//                       //     color:
//                       //         FlutterFlowTheme.of(context).secondaryBackground,
//                       //     borderRadius: BorderRadius.circular(8.0),
//                       //   ),
//                       //   child: Container(
//                       //     width: double.infinity,
//                       //     height: double.infinity,
//                       //     child: Stack(
//                       //       alignment: AlignmentDirectional(0.0, 0.0),
//                       //       children: [
//                       //         Row(
//                       //           mainAxisSize: MainAxisSize.max,
//                       //           mainAxisAlignment: MainAxisAlignment.start,
//                       //           children: [
//                       //             Icon(
//                       //               Icons.info_outline,
//                       //               color: FlutterFlowTheme.of(context)
//                       //                   .primaryText,
//                       //               size: 20.0,
//                       //             ),
//                       //             Text(
//                       //               'Centro de Ajuda',
//                       //               style: FlutterFlowTheme.of(context)
//                       //                   .bodyMedium
//                       //                   .override(
//                       //                     fontFamily: 'Inter',
//                       //                     letterSpacing: 0.0,
//                       //                   ),
//                       //             ),
//                       //             Padding(
//                       //               padding: EdgeInsetsDirectional.fromSTEB(
//                       //                   100.0, 0.0, 0.0, 0.0),
//                       //               child: Icon(
//                       //                 Icons.arrow_forward_ios,
//                       //                 color: FlutterFlowTheme.of(context)
//                       //                     .primaryText,
//                       //                 size: 19.0,
//                       //               ),
//                       //             ),
//                       //           ]
//                       //               .divide(SizedBox(width: 11.0))
//                       //               .addToStart(SizedBox(width: 10.0))
//                       //               .addToEnd(SizedBox(width: 5.0)),
//                       //         ),
//                       //         Opacity(
//                       //           opacity: 0.0,
//                       //           child: FFButtonWidget(
//                       //             onPressed: () {
//                       //               Navigator.of(context).push(
//                       //                 MaterialPageRoute(
//                       //                   builder: (_) =>
//                       //                       Tela17NotificacaoViewWidget(),
//                       //                 ),
//                       //               );
//                       //               print('centroDeAjuda pressed ...');
//                       //             },
//                       //             text: 'Button',
//                       //             options: FFButtonOptions(
//                       //               width: 340.0,
//                       //               height: 45.0,
//                       //               padding: EdgeInsetsDirectional.fromSTEB(
//                       //                   16.0, 0.0, 16.0, 0.0),
//                       //               iconPadding: EdgeInsetsDirectional.fromSTEB(
//                       //                   0.0, 0.0, 0.0, 0.0),
//                       //               color: Color(0x004B39EF),
//                       //               textStyle: FlutterFlowTheme.of(context)
//                       //                   .titleSmall
//                       //                   .override(
//                       //                     fontFamily: 'Inter Tight',
//                       //                     color: Color(0x00FFFFFF),
//                       //                     letterSpacing: 0.0,
//                       //                   ),
//                       //               elevation: 0.0,
//                       //               borderRadius: BorderRadius.circular(8.0),
//                       //             ),
//                       //           ),
//                       //         ),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 290.0,
//                 child: Divider(
//                   thickness: 2.0,
//                   color: Colors.black,
//                 ),
//               ),
//               Container(
//                 width: 290.0,
//                 height: 45.0,
//                 decoration: BoxDecoration(
//                   color: FlutterFlowTheme.of(context).secondaryBackground,
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Container(
//                   width: double.infinity,
//                   height: double.infinity,
//                   child: Stack(
//                     alignment: AlignmentDirectional(0.0, 0.0),
//                     children: [
//                       Row(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Icon(
//                             Icons.logout_sharp,
//                             color: FlutterFlowTheme.of(context).primaryText,
//                             size: 20.0,
//                           ),
//                           Text(
//                             'Terminar Sessão',
//                             style: FlutterFlowTheme.of(context)
//                                 .bodyMedium
//                                 .override(
//                                   fontFamily: 'Inter',
//                                   letterSpacing: 0.0,
//                                 ),
//                           ),
//                           Padding(
//                             padding: EdgeInsetsDirectional.fromSTEB(
//                                 100.0, 0.0, 0.0, 0.0),
//                             child: Icon(
//                               Icons.arrow_forward_ios,
//                               color: FlutterFlowTheme.of(context).primaryText,
//                               size: 19.0,
//                             ),
//                           ),
//                         ]
//                             .divide(SizedBox(width: 11.0))
//                             .addToStart(SizedBox(width: 10.0))
//                             .addToEnd(SizedBox(width: 5.0)),
//                       ),
//                       Opacity(
//                         opacity: 1.0,
//                         child: FFButtonWidget(
//                           onPressed: () async {
//                             try {
//                               TokenUtil.removeToken();
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content:
//                                       Text('Sessão terminada com sucesso!'),
//                                   backgroundColor: Colors.green,
//                                 ),
//                               );
//                               await _model.logoutAsync();
//                               context.pushNamed(Tela00LoginWidget.routeName);
//                             } catch (e) {
//                               print('Erro ao terminar sessão: $e');
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                       'Erro ao terminar sessão. Tente novamente.'),
//                                   backgroundColor:
//                                       Colors.red, // Cor vermelha para erro
//                                 ),
//                               );
//                             }
//                           },
//                           text: 'Terminar Sessão',
//                           options: FFButtonOptions(
//                             width: 340.0,
//                             height: 45.0,
//                             padding: EdgeInsetsDirectional.fromSTEB(
//                                 16.0, 0.0, 16.0, 0.0),
//                             iconPadding: EdgeInsetsDirectional.fromSTEB(
//                                 0.0, 0.0, 0.0, 0.0),
//                             color: Color(0x004B39EF),
//                             textStyle: FlutterFlowTheme.of(context)
//                                 .titleSmall
//                                 .override(
//                                   fontFamily: 'Inter Tight',
//                                   color: Color(0x00FFFFFF),
//                                   letterSpacing: 0.0,
//                                 ),
//                             elevation: 0.0,
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ].divide(SizedBox(height: 5.0)).addToStart(SizedBox(height: 20.0)),
//           ),
//         ),
//       ),
//     );
//   }
// }
