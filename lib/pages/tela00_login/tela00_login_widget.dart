import 'package:projeto_game_quiz/pages/tela01_criar_conta/tela01_criar_conta_widget.dart'; 

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart'; 
import 'package:flutter/material.dart';
import 'tela00_login_model.dart';
export 'tela00_login_model.dart';

class Tela00LoginWidget extends StatefulWidget {
  const Tela00LoginWidget({super.key});

  static String routeName = 'Tela00Login';
  static String routePath = '/tela00Login';

  @override
  State<Tela00LoginWidget> createState() => _Tela00LoginWidgetState();
}

class _Tela00LoginWidgetState extends State<Tela00LoginWidget> {
  late Tela00LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela00LoginModel());

    _model.inputEmailTextController ??= TextEditingController();
    _model.inputEmailFocusNode ??= FocusNode();

    _model.inputSenhaTextController ??= TextEditingController();
    _model.inputSenhaFocusNode ??= FocusNode();
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
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 24.0),
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200.0),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1604594849809-dfedbc827105?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw3fHxtb25leXxlbnwwfHx8fDE3NDM2MjA1MTR8MA&ixlib=rb-4.0.3&q=80&w=1080',
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Form(
                      key: _model.formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Container(
                        width: 350.0,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Email
                            Align(
                              alignment: AlignmentDirectional(-0.8, -1.0),
                              child: Text(
                                'Email ou Telefone',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      fontSize: 16.0,
                                    ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: 320.0,
                              child: TextFormField(
                                controller: _model.inputEmailTextController,
                                focusNode: _model.inputEmailFocusNode,
                                decoration: _inputDecoration(
                                    context, 'abc012@gmail.com'),
                                style: _inputStyle(context),
                                textAlign: TextAlign.justify,
                                cursorColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                validator: _model
                                    .inputEmailTextControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                            SizedBox(height: 10),
                            // Senha
                            Align(
                              alignment: AlignmentDirectional(-0.8, -1.0),
                              child: Text(
                                'Senha',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      fontSize: 16.0,
                                    ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: 320.0,
                              child: TextFormField(
                                controller: _model.inputSenhaTextController,
                                focusNode: _model.inputSenhaFocusNode,
                                obscureText: !_model.inputSenhaVisibility,
                                decoration: _inputDecoration(
                                  context,
                                  'Januario Pinto',
                                  suffixIcon: InkWell(
                                    onTap: () => safeSetState(() =>
                                        _model.inputSenhaVisibility =
                                            !_model.inputSenhaVisibility),
                                    child: Icon(
                                      _model.inputSenhaVisibility
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                style: _inputStyle(context),
                                textAlign: TextAlign.justify,
                                maxLength: 16,
                                buildCounter: (context,
                                        {required currentLength,
                                        required isFocused,
                                        maxLength}) =>
                                    null,
                                cursorColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                validator: _model
                                    .inputSenhaTextControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                            SizedBox(height: 10),
                            // Lembrar senha
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Theme(
                                  data: ThemeData(
                                    checkboxTheme: CheckboxThemeData(
                                      visualDensity: VisualDensity.compact,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                    unselectedWidgetColor:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                  child: Checkbox(
                                    value: _model.checkboxValue ??= true,
                                    onChanged: (newValue) => safeSetState(
                                        () => _model.checkboxValue = newValue!),
                                    activeColor:
                                        FlutterFlowTheme.of(context).primary,
                                    checkColor:
                                        FlutterFlowTheme.of(context).info,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Lembrar Senha',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        fontSize: 17.0,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            _authButton(context, 'Entrar', () async {
                              await _model.signInAsync();
                            }),
                            SizedBox(height: 4),
                            _authButton(context, 'Criar Conta', () async { 
                              context
                                  .pushNamed(Tela01CriarContaWidget.routeName);
                            }),
                            _authButton(
                              context,
                              'Esqueceu  a senha?',
                              () {},
                              transparent: true,
                              underline: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint,
      {Widget? suffixIcon}) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      filled: true,
      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: FlutterFlowTheme.of(context).error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: FlutterFlowTheme.of(context).error),
      ),
    );
  }

  TextStyle _inputStyle(BuildContext context) {
    return FlutterFlowTheme.of(context).bodyMedium.override(
          fontFamily: 'Inter',
          fontSize: 17.0,
        );
  }

  Widget _authButton(BuildContext context, String text, VoidCallback onPressed,
      {bool transparent = false, bool underline = false}) {
    return FFButtonWidget(
      onPressed: onPressed,
      text: text,
      options: FFButtonOptions(
        width: 320.0,
        height: 45.0,
        color: transparent ? Colors.transparent : Color(0xFFEC8D0D),
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              fontFamily: 'Inter Tight',
              color: transparent
                  ? FlutterFlowTheme.of(context).primary
                  : Colors.black,
              fontSize: 17.0,
              decoration:
                  underline ? TextDecoration.underline : TextDecoration.none,
            ),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
