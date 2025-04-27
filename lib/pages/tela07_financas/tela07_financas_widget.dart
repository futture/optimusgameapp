import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'tela07_financas_model.dart';
export 'tela07_financas_model.dart';

class Tela07FinancasWidget extends StatefulWidget {
  const Tela07FinancasWidget({super.key});

  static String routeName = 'Tela07Financas';
  static String routePath = '/tela07Financas';

  @override
  State<Tela07FinancasWidget> createState() => _Tela07FinancasWidgetState();
}

class _Tela07FinancasWidgetState extends State<Tela07FinancasWidget> {
  late Tela07FinancasModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela07FinancasModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.isEditingIban = _model.textController1.text.isEmpty;
    _model.isEditingConta = _model.textController2.text.isEmpty;
    _model.getUserIdAndAccountInfo(setState, context);
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
              fillColor: FlutterFlowTheme.of(context).alternate,
              icon: Icon(
                Icons.arrow_back,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
          ),
          title: Text(
            'DADOS FINANCEIROS',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'Inter Tight',
                  color: Color(0xFFEC8D0D),
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 4.0,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minWidth: 300.0,
                maxWidth: 500.0,
              ),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(30.0),
                child: Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.monetization_on,
                                  color: Color(0xFFEC8D0D),
                                  size: 76.0,
                                ),
                                SizedBox(height: 10),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Center(
                                      child: Text(
                                        'DADOS FINANCEIRO.',
                                        textAlign: TextAlign.justify,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              fontSize: 15.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(height: 20),
                            Align(
                              alignment: AlignmentDirectional(-1.0, -1.0),
                              child: Text(
                                'Nº DO IBAN:',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      fontSize: 15.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _model.textController1,
                                    focusNode: _model.textFieldFocusNode1,
                                    autofocus: false,
                                    enabled: _model.isEditingIban ||
                                        _model.textController1.text.isEmpty,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText:
                                          'Ex.: A0O600000000000000000000000000000',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            fontSize: 15.0,
                                            letterSpacing: 0.0,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                    validator: _model.textController1Validator
                                        .asValidator(context),
                                  ),
                                ),
                                SizedBox(width: 8),
                                if (!_model.isCreate)
                                  Material(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    shape: CircleBorder(),
                                    child: InkWell(
                                      customBorder: CircleBorder(),
                                      onTap: () async {
                                        if (_model.isEditingIban) {
                                          await _model.createAccountInfoAsync();
                                        }

                                        setState(() {
                                          _model.isEditingIban =
                                              !_model.isEditingIban;
                                        });

                                        if (_model.isEditingIban) {
                                          Future.delayed(
                                              Duration(milliseconds: 100), () {
                                            FocusScope.of(context).requestFocus(
                                                _model.textFieldFocusNode1);
                                          });
                                        } else {
                                          FocusScope.of(context).unfocus();
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Icon(
                                          _model.isEditingIban
                                              ? Icons.check
                                              : Icons.edit,
                                          size: 12.0,
                                          color: _model.isEditingIban
                                              ? Colors.green
                                              : Colors.deepOrange,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Align(
                              alignment: AlignmentDirectional(-1.0, -1.0),
                              child: Text(
                                'Nº DE CONTA:',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      fontSize: 15.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _model.textController2,
                                    focusNode: _model.textFieldFocusNode2,
                                    autofocus: false,
                                    enabled: _model.isEditingConta ||
                                        _model.textController2.text.isEmpty,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Ex.: 000000000000',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            fontSize: 15.0,
                                            letterSpacing: 0.0,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                    validator: _model.textController2Validator
                                        .asValidator(context),
                                  ),
                                ),
                                SizedBox(width: 8),
                                if (!_model.isCreate)
                                  Material(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    shape: CircleBorder(),
                                    child: InkWell(
                                      customBorder: CircleBorder(),
                                      onTap: () async {
                                        if (_model.isEditingConta) {
                                          await _model.createAccountInfoAsync();
                                        }

                                        setState(() {
                                          _model.isEditingConta =
                                              !_model.isEditingConta;
                                        });

                                        if (_model.isEditingConta) {
                                          Future.delayed(
                                              Duration(milliseconds: 100), () {
                                            FocusScope.of(context).requestFocus(
                                                _model.textFieldFocusNode2);
                                          });
                                        } else {
                                          FocusScope.of(context).unfocus();
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Icon(
                                          _model.isEditingConta
                                              ? Icons.check
                                              : Icons.edit,
                                          size: 12.0,
                                          color: _model.isEditingConta
                                              ? Colors.green
                                              : Colors.deepOrange,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 30),
                            if (_model.isCreate)
                              FFButtonWidget(
                                onPressed: () async {
                                  await _model.createAccountInfoAsync();
                                },
                                text: 'SALVAR',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 45.0,
                                  color: Color(0xFFEC8D0D),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Inter Tight',
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                          ].divide(SizedBox(height: 10.0)),
                        ),
                      ),
                    ].divide(SizedBox(height: 50.0)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
