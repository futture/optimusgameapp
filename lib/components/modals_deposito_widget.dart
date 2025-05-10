import 'package:projeto_game_quiz/Atualiza%C3%A7%C3%A3o/tela10_deposito/tela10_deposito_lista_widget.dart';

import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'modals_deposito_model.dart';
export 'modals_deposito_model.dart';

class ModalsDepositoWidget extends StatefulWidget {
  const ModalsDepositoWidget({super.key});

  @override
  State<ModalsDepositoWidget> createState() => _ModalsDepositoWidgetState();
}

class _ModalsDepositoWidgetState extends State<ModalsDepositoWidget> {
  // final List<Map<String, dynamic>> _options = [
  //   {
  //     'label': 'Multicaixa Express',
  //     'icon': Icons.credit_card,
  //   },
  //   {
  //     'label': 'Unitel Money',
  //     'icon': Icons.account_balance_wallet,
  //   },
  //   {
  //     'label': 'Outro',
  //     'icon': Icons.money,
  //   },
  // ];
  late ModalsDepositoModel _model;
  // String? _selectedOption;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalsDepositoModel());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _model.getUserInfoAndAccountInfoAsync(setState, context);

      if (_model.userAccountInfo != null) {
        print(_model.userAccountInfo?.accountNumber);
        setState(() {
          _model.textController1.text = _model.userAccountInfo!.accountNumber;
        });
      }
    });
    _model.textController2 ??= TextEditingController();
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
        height: 350.0,
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
                      FontAwesomeIcons.checkCircle,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 20.0,
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        'VERIFICAR ID',
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
                  height: 285.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Form(
                        key: _model.formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            height: 280.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Container(
                                    width: 300.0,
                                    height: 75.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1.0, 0.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Text(
                                              'Conta do Titular',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 300.0,
                                          child: Autocomplete<String>(
                                            initialValue: TextEditingValue(),
                                            optionsBuilder: (textEditingValue) {
                                              if (textEditingValue.text == '') {
                                                return const Iterable<
                                                    String>.empty();
                                              }
                                              return ['Option 1', 'Opcao 2']
                                                  .where((option) {
                                                final lowercaseOption =
                                                    option.toLowerCase();
                                                return lowercaseOption.contains(
                                                    textEditingValue.text
                                                        .toLowerCase());
                                              });
                                            },
                                            optionsViewBuilder:
                                                (context, onSelected, options) {
                                              return AutocompleteOptionsList(
                                                textFieldKey:
                                                    _model.textFieldKey1,
                                                textController:
                                                    _model.textController1!,
                                                options: options.toList(),
                                                onSelected: onSelected,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                        ),
                                                textHighlightStyle: TextStyle(),
                                                elevation: 4.0,
                                                optionBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                optionHighlightColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                maxHeight: 200.0,
                                              );
                                            },
                                            onSelected: (String selection) {
                                              safeSetState(() => _model
                                                      .textFieldSelectedOption1 =
                                                  selection);
                                              FocusScope.of(context).unfocus();
                                            },
                                            fieldViewBuilder: (
                                              context,
                                              textEditingController,
                                              focusNode,
                                              onEditingComplete,
                                            ) {
                                              _model.textFieldFocusNode1 =
                                                  focusNode;

                                              _model.textController1 =
                                                  textEditingController;
                                              return TextFormField(
                                                key: _model.textFieldKey1,
                                                controller:
                                                    textEditingController,
                                                focusNode: focusNode,
                                                onEditingComplete:
                                                    onEditingComplete,
                                                autofocus: true,
                                                obscureText: false,
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  isDense: false,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            letterSpacing: 0.0,
                                                          ),
                                                  hintText: '1234567890',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            letterSpacing: 0.0,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                  contentPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(10.0, 0.0,
                                                              0.0, 0.0),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                        ),
                                                textAlign: TextAlign.start,
                                                keyboardType:
                                                    TextInputType.number,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .textController1Validator
                                                    .asValidator(context),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Container(
                                    width: 314.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Método de Carregamento',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                        ),
                                        value: _model.textFieldSelectedOption1,
                                        items: _model.buildPaymentOptions(),
                                        onChanged: (value) {
                                          setState(() {
                                            _model.textFieldSelectedOption1 =
                                                value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Container(
                                    width: 300.0,
                                    height: 75.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1.0, 0.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Text(
                                              'Montante',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 300.0,
                                          child: Autocomplete<String>(
                                            initialValue: TextEditingValue(),
                                            optionsBuilder: (textEditingValue) {
                                              if (textEditingValue.text == '') {
                                                return const Iterable<
                                                    String>.empty();
                                              }
                                              return ['Option 1', 'Opcao 2']
                                                  .where((option) {
                                                final lowercaseOption =
                                                    option.toLowerCase();
                                                return lowercaseOption.contains(
                                                    textEditingValue.text
                                                        .toLowerCase());
                                              });
                                            },
                                            optionsViewBuilder:
                                                (context, onSelected, options) {
                                              return AutocompleteOptionsList(
                                                textFieldKey:
                                                    _model.textFieldKey2,
                                                textController:
                                                    _model.textController2!,
                                                options: options.toList(),
                                                onSelected: onSelected,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                        ),
                                                textHighlightStyle: TextStyle(),
                                                elevation: 4.0,
                                                optionBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                optionHighlightColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                maxHeight: 200.0,
                                              );
                                            },
                                            onSelected: (String selection) {
                                              safeSetState(() => _model
                                                      .textFieldSelectedOption2 =
                                                  selection);
                                              FocusScope.of(context).unfocus();
                                            },
                                            fieldViewBuilder: (
                                              context,
                                              textEditingController,
                                              focusNode,
                                              onEditingComplete,
                                            ) {
                                              _model.textFieldFocusNode2 =
                                                  focusNode;

                                              _model.textController2 =
                                                  textEditingController;
                                              return TextFormField(
                                                key: _model.textFieldKey2,
                                                controller:
                                                    textEditingController,
                                                focusNode: focusNode,
                                                onEditingComplete:
                                                    onEditingComplete,
                                                autofocus: true,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: false,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            letterSpacing: 0.0,
                                                          ),
                                                  hintText:
                                                      '100 - 10.000,00 Kz',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            letterSpacing: 0.0,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                  contentPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(10.0, 0.0,
                                                              0.0, 0.0),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                        ),
                                                textAlign: TextAlign.start,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .textController2Validator
                                                    .asValidator(context),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Container(
                                    width: 300.0,
                                    height: 75.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1.0, 0.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Text(
                                              'Montante',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 300.0,
                                          child: Autocomplete<String>(
                                            initialValue: TextEditingValue(),
                                            optionsBuilder: (textEditingValue) {
                                              if (textEditingValue.text == '') {
                                                return const Iterable<
                                                    String>.empty();
                                              }
                                              return ['Option 1', 'Opcao 2']
                                                  .where((option) {
                                                final lowercaseOption =
                                                    option.toLowerCase();
                                                return lowercaseOption.contains(
                                                    textEditingValue.text
                                                        .toLowerCase());
                                              });
                                            },
                                            optionsViewBuilder:
                                                (context, onSelected, options) {
                                              return AutocompleteOptionsList(
                                                textFieldKey:
                                                    _model.textFieldKey2,
                                                textController:
                                                    _model.textController2!,
                                                options: options.toList(),
                                                onSelected: onSelected,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                        ),
                                                textHighlightStyle: TextStyle(),
                                                elevation: 4.0,
                                                optionBackgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                optionHighlightColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                maxHeight: 200.0,
                                              );
                                            },
                                            onSelected: (String selection) {
                                              safeSetState(() => _model
                                                      .textFieldSelectedOption2 =
                                                  selection);
                                              FocusScope.of(context).unfocus();
                                            },
                                            fieldViewBuilder: (
                                              context,
                                              textEditingController,
                                              focusNode,
                                              onEditingComplete,
                                            ) {
                                              _model.textFieldFocusNode2 =
                                                  focusNode;

                                              _model.textController2 =
                                                  textEditingController;
                                              return TextFormField(
                                                key: _model.textFieldKey2,
                                                controller:
                                                    textEditingController,
                                                focusNode: focusNode,
                                                onEditingComplete:
                                                    onEditingComplete,
                                                autofocus: true,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: false,
                                                  labelStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            letterSpacing: 0.0,
                                                          ),
                                                  hintText: '999 999 999',
                                                  hintStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            letterSpacing: 0.0,
                                                          ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                  contentPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(10.0, 0.0,
                                                              0.0, 0.0),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                        ),
                                                textAlign: TextAlign.start,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                validator: _model
                                                    .textController2Validator
                                                    .asValidator(context),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      print(_model.textController2.text);
                                      context.pushNamed(
                                          Tela10DepositoListaWidget.routeName);
                                    },
                                    text: 'Gerar Referência',
                                    options: FFButtonOptions(
                                      width: 300.0,
                                      height: 45.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
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
                        ),
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
}
