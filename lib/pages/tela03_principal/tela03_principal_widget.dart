// imports...
import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/components/warnings/warning04_reducao_de_saldo/warning04_reducao_de_saldo_widget.dart';
import 'package:projeto_game_quiz/core/api/services/fcm_token_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/pages/payment_method/payment_selection_screen.dart';
import 'package:projeto_game_quiz/utils.dart';

import '/components/moda_listade_sala_widget.dart';
import '/components/moda_menu_pagian_inicial_widget.dart';
import '/components/modals_deposito_widget.dart';
import '/components/modals_saque_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tela03_principal_model.dart';

export 'tela03_principal_model.dart';

class Tela03PrincipalWidget extends StatefulWidget {
  const Tela03PrincipalWidget({super.key});

  static String routeName = 'Tela03Principal';
  static String routePath = '/tela03Principal';

  @override
  State<Tela03PrincipalWidget> createState() => _Tela03PrincipalWidgetState();
}

class _Tela03PrincipalWidgetState extends State<Tela03PrincipalWidget> {
  late Tela03PrincipalModel _model;
  final matchService = MatchService();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FcmTokenService _fcmTokenService = FcmTokenService();

  @override
  void initState() {
    super.initState();
    _fcmTokenService.initFirebaseMessaging(context);

    _model = createModel(context, () => Tela03PrincipalModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
    _model.getUserInfoAndAccountInfoAsync(setState, context);
    _model.loadMatches(setState);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              appBar: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                automaticallyImplyLeading: false,
                leading: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(18.0, 0.0, 0.0, 0.0),
                  child: FlutterFlowIconButton(
                    borderRadius: 8.0,
                    buttonSize: 45.0,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    icon: FaIcon(
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
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
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
                        color: Color(0xFFEC8D0D),
                        letterSpacing: 0.0,
                      ),
                ),
                centerTitle: true,
                elevation: 4.0,
              ),
              body: SafeArea(
                top: true,
                child: Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0x00FFFFFF),
                      shape: BoxShape.rectangle,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await _model.getUserInfoAndAccountInfoAsync(
                              setState, context);
                          await _model.loadMatches(setState);
                        },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: 320.0,
                                height: 210.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF1F4F8),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4.0,
                                      color: Color(0x33000000),
                                      offset: Offset(
                                        0.0,
                                        2.0,
                                      ),
                                      spreadRadius: 5.0,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.0, -1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 10.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Stack(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            -1.0, -0.9),
                                                    child: Container(
                                                      width: 70.0,
                                                      height: 70.0,
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Image.network(
                                                        'https://images.unsplash.com/photo-1507679799987-c73779587ccf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxwcm98ZW58MHx8fHwxNzQzNTg0NTYxfDA&ixlib=rb-4.0.3&q=80&w=1080',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  FFButtonWidget(
                                                    onPressed: () async {
                                                      context.pushNamed(
                                                        Tela04PerfilWidget
                                                            .routeName,
                                                        extra: <String,
                                                            dynamic>{
                                                          kTransitionInfoKey:
                                                              TransitionInfo(
                                                            hasTransition: true,
                                                            transitionType:
                                                                PageTransitionType
                                                                    .rightToLeft,
                                                          ),
                                                        },
                                                      );
                                                    },
                                                    text: '',
                                                    options: FFButtonOptions(
                                                      width: 70.0,
                                                      height: 70.0,
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                      iconPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      color: Color(0x004B39EF),
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                fontFamily:
                                                                    'Inter Tight',
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      elevation: 0.0,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80.0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 230.0,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF1F4F8),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            -1.0, 0.0),
                                                    child: Text(
                                                      _model.user == null
                                                          ? "Carregando..."
                                                          : _model.user!.name,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            color: Colors.black,
                                                            fontFamily: 'Inter',
                                                            fontSize: 14.0,
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            -1.0, 0.0),
                                                    child: Text(
                                                      _model.userAccountInfo ==
                                                              null
                                                          ? "Carregando..."
                                                          : 'ID: ${_model.userAccountInfo!.accountNumber}',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            color: Colors.black,
                                                            fontFamily: 'Inter',
                                                            fontSize: 13.0,
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(height: 5.0)),
                                              ),
                                            ),
                                          ]
                                              .divide(SizedBox(width: 10.0))
                                              .addToStart(SizedBox(width: 20.0))
                                              .addToEnd(SizedBox(width: 20.0)),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 360.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF1F4F8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'SALDO: ',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  color: Colors.black,
                                                  fontFamily: 'Inter',
                                                  fontSize: 18.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            _model.userAccountInfo == null
                                                ? "Carregando..."
                                                : CurrencyUtil.formatKwanza(
                                                    _model.userAccountInfo!
                                                        .availableBalance),
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  color: Colors.black,
                                                  fontFamily: 'Inter Tight',
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            ' AOA',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  color: Colors.black,
                                                  fontFamily: 'Inter',
                                                  fontSize: 18.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 370.0,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF1F4F8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          FFButtonWidget(
                                            onPressed: () async {
                                              await showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                enableDrag: false,
                                                context: context,
                                                builder: (context) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                    },
                                                    child: Padding(
                                                      padding: MediaQuery
                                                          .viewInsetsOf(
                                                              context),
                                                      child:
                                                          ModalsDepositoWidget(),
                                                    ),
                                                  );
                                                },
                                              ).then((value) =>
                                                  safeSetState(() {}));
                                            },
                                            text: 'DEPOSITAR',
                                            icon: Icon(
                                              Icons.file_download_outlined,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 20.0,
                                            ),
                                            options: FFButtonOptions(
                                              width: 170.0,
                                              height: 45.0,
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color: Color(0xFFEC8D0D),
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Inter Tight',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                  ),
                                              elevation: 0.0,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          FFButtonWidget(
                                            onPressed: () async {
                                              await showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                enableDrag: false,
                                                useSafeArea: true,
                                                context: context,
                                                builder: (context) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                    },
                                                    child: Padding(
                                                      padding: MediaQuery
                                                          .viewInsetsOf(
                                                              context),
                                                      child:
                                                          ModalsSaqueWidget(),
                                                    ),
                                                  );
                                                },
                                              ).then((value) =>
                                                  safeSetState(() {}));
                                            },
                                            text: 'SACAR',
                                            icon: Icon(
                                              Icons.file_upload_outlined,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 20.0,
                                            ),
                                            options: FFButtonOptions(
                                              width: 170.0,
                                              height: 45.0,
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color: Color(0xFFEC8D0D),
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Inter Tight',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                  ),
                                              elevation: 0.0,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]
                                      .divide(SizedBox(height: 10.0))
                                      .addToStart(SizedBox(height: 0.0))
                                      .addToEnd(SizedBox(height: 10.0)),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Container(
                                  width: 350.0,
                                  height: 105.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF1F4F8),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x33000000),
                                        offset: Offset(
                                          0.0,
                                          2.0,
                                        ),
                                        spreadRadius: 5.0,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(-0.8, -1.0),
                                        child: Text(
                                          'Click para escolher sala de jogo',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                      Container(
                                        width: 330.0,
                                        height: 45.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF00B80E),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.gamepad,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 20.0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  50.0,
                                                                  0.0,
                                                                  50.0,
                                                                  0.0),
                                                      child: Text(
                                                        'PARTIDAS',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 19.0,
                                                    ),
                                                  ]
                                                      .divide(
                                                          SizedBox(width: 11.0))
                                                      .addToStart(
                                                          SizedBox(width: 5.0))
                                                      .addToEnd(
                                                          SizedBox(width: 5.0)),
                                                ),
                                              ),
                                              Opacity(
                                                opacity: 0.0,
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery
                                                                .viewInsetsOf(
                                                                    context),
                                                            child:
                                                                ModaListadeSalaWidget(),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'jogar',
                                                  options: FFButtonOptions(
                                                    width: 340.0,
                                                    height: 45.0,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(16.0, 0.0,
                                                                16.0, 0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: Color(0x004B39EF),
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              'Inter Tight',
                                                          color:
                                                              Color(0x00FFFFFF),
                                                          letterSpacing: 0.0,
                                                        ),
                                                    elevation: 0.0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]
                                        .divide(SizedBox(height: 10.0))
                                        .around(SizedBox(height: 10.0)),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Container(
                                  width: 350.0,
                                  height: 110.0,
                                  decoration: BoxDecoration(
                                    color: Color(0x00FFFFFF),
                                  ),
                                  child: Wrap(
                                    spacing: 10.0,
                                    runSpacing: 6.0,
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    direction: Axis.horizontal,
                                    runAlignment: WrapAlignment.start,
                                    verticalDirection: VerticalDirection.down,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Text(
                                                'SUPER LIGA',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily:
                                                              'Inter Tight',
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.bolt,
                                              color: Color(0xFFD2A739),
                                              size: 25.0,
                                            ),
                                          ].divide(SizedBox(width: 2.0)),
                                        ),
                                      ),
                                      Text(
                                        'Habilita-se a ganhar grandes prêmios, participando nas partidas abaixo.\nBasta clicar na partida para se inscrever.',
                                        textAlign: TextAlign.justify,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'PRÓXIMA PARTIDA EM',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleLarge
                                                  .override(
                                                    fontFamily: 'Inter Tight',
                                                    color: Color(0xFF1219DB),
                                                    fontSize: 18.0,
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                            SizedBox(width: 10),
                                            if (_model.nextMatch != null)
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.timer,
                                                        size: 18,
                                                        color: Colors.orange),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      _formatCountdown(_model
                                                          .timerMilliseconds),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .orange.shade800,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            else
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.timer,
                                                        size: 18,
                                                        color: Colors.orange),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "N/A",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blueGrey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_model.isLoadingMatches)
                                Center(child: CircularProgressIndicator())
                              else if (_model.matchList.isEmpty)
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.videogame_asset_outlined,
                                          size: 48, color: Colors.grey),
                                      SizedBox(height: 12),
                                      Text(
                                        'Nenhuma partida encontrada.',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                      SizedBox(height: 12),
                                      IconButton(
                                        icon: Icon(Icons.refresh, size: 30),
                                        tooltip: 'Recarregar',
                                        onPressed: () async {
                                          await _model.loadMatches(setState);
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              else
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _model.matchList.length,
                                  itemBuilder: (context, index) {
                                    final match = _model.matchList[index];
                                    return MatchCard(match);
                                  },
                                )
                            ]
                                .divide(SizedBox(height: 20.0))
                                .addToStart(SizedBox(height: 0.0))
                                .addToEnd(SizedBox(height: 10.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }

  Widget MatchCard(MatchResponse match) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeIn,
      width: 350.0,
      height: 120.0,
      decoration: BoxDecoration(color: Color(0xFFF1F4F8)),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Align(
        alignment: AlignmentDirectional(0.0, -1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 350.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: match.isUserRegistered!
                    ? Color.fromARGB(255, 80, 104, 70)
                    : Color(0xFFEC8D0D),
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
                                FaIcon(FontAwesomeIcons.sketch, size: 22.0),
                                Text(
                                  'Super Partida das',
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: 'Inter Tight',
                                        letterSpacing: 0.0,
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
                                Icon(Icons.watch_later, size: 22.0),
                                Text(
                                  formatHour(match.matchStartDate),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
                                Text('${match.matchPlayers?.length}'),
                                Text('Insc...'),
                              ].divide(SizedBox(width: 5.0)),
                            ),
                          ),
                          Container(
                            width: 90.0,
                            height: 25.0,
                            child: Row(
                              children: [
                                FaIcon(FontAwesomeIcons.donate, size: 20.0),
                                Text(
                                    '${match.room?.roomConfiguration?.minimumAmountToPlay}KZ'),
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
                    onPressed: () async {
                      await _model.checkPlayerAlreadyRegisteredMatchAsync(
                          setState, match.id);

                      if (!_model.isNotRegisteredMatch) {
                        Warning00ErrorUtil.showDialogMessageError(
                            context,
                            "Falha ao se increver na partida",
                            "Jogador ja inscrito na partida.");
                      } else {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: EdgeInsets.all(24),
                              child: Warning04ReducaoDeSaldoWidget(
                                subscribe: true,
                                matchInfo: match,
                                onConfirmed: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            );
                          },
                        );
                        if (result == true) {
                          setState(() {
                            _model.getUserInfoAndAccountInfoAsync(
                                setState, context);
                            _model.loadMatches(setState);
                          });
                        }
                      }
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

  String formatHour(DateTime? dateTime) {
    if (dateTime == null) return '';
    final hour = dateTime.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    return '${formattedHour}h$period';
  }

  String _formatCountdown(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);

    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
