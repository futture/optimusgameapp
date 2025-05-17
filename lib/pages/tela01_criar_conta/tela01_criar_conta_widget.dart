import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/models/requests/user_request.dart';
import 'package:projeto_game_quiz/dialogs/error-dialog-widget.dart';
import 'package:projeto_game_quiz/dialogs/success-dialog-widget.dart';
import '/components/modal_valida_conta_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'tela01_criar_conta_model.dart';
export 'tela01_criar_conta_model.dart';

class Tela01CriarContaWidget extends StatefulWidget {
  const Tela01CriarContaWidget({super.key});

  static String routeName = 'Tela01CriarConta';
  static String routePath = '/tela01CriarConta';

  @override
  State<Tela01CriarContaWidget> createState() => _Tela01CriarContaWidgetState();
}

class _Tela01CriarContaWidgetState extends State<Tela01CriarContaWidget> {
  late Tela01CriarContaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela01CriarContaModel());

    _model.inputMomeCompletoTextController ??= TextEditingController();
    _model.inputMomeCompletoFocusNode ??= FocusNode();

    _model.inputTelefoneTextController ??= TextEditingController();
    _model.inputTelefoneFocusNode ??= FocusNode();

    _model.inputEmailTextController ??= TextEditingController();
    _model.inputEmailFocusNode ??= FocusNode();

    _model.inputSenhaTextController1 ??= TextEditingController();
    _model.inputSenhaFocusNode1 ??= FocusNode();

    _model.inputSenhaTextController2 ??= TextEditingController();
    _model.inputSenhaFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: Container( // Adicionado Container com maxWidth
              constraints: BoxConstraints(
                maxWidth: isWeb ? 400 : double.infinity,
              ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'register_logo',
                    child: Center(
                      child: Container(
                        width: 180,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1604594849809-dfedbc827105?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw3fHxtb25leXxlbnwwfHx8fDE3NDM2MjA1MTR8MA&ixlib=rb-4.0.3&q=80&w=1080',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
          
                  const SizedBox(height: 32),
          
                  // Título
                  Text(
                    'Criar Conta',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                  ),
          
                  const SizedBox(height: 8),
          
                  // Subtítulo
                  Text(
                    'Preencha os dados abaixo para se registrar',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
          
                  const SizedBox(height: 32),
          
                  Form(
                    key: _model.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Nome Completo',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _model.inputMomeCompletoTextController,
                          focusNode: _model.inputMomeCompletoFocusNode,
                          decoration: _inputDecoration(
                            context,
                            'Digite seu nome completo',
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: _model
                              .inputMomeCompletoTextControllerValidator
                              .asValidator(context),
                        ),
          
                        const SizedBox(height: 16),
          
                        // Campo Telefone
                        Text(
                          'Telefone',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _model.inputTelefoneTextController,
                          focusNode: _model.inputTelefoneFocusNode,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration(
                            context,
                            '999-999-999',
                            prefixIcon: const Icon(Icons.phone_outlined),
                          ),
                          validator: _model.inputTelefoneTextControllerValidator
                              .asValidator(context),
                        ),
          
                        const SizedBox(height: 16),
          
                        // Campo Email
                        Text(
                          'Email',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _model.inputEmailTextController,
                          focusNode: _model.inputEmailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(
                            context,
                            'seu@email.com',
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          validator: _model.inputEmailTextControllerValidator
                              .asValidator(context),
                        ),
          
                        const SizedBox(height: 16),
          
                        // Campo Senha
                        Text(
                          'Senha',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _model.inputSenhaTextController1,
                          focusNode: _model.inputSenhaFocusNode1,
                          obscureText: !_model.inputSenhaVisibility1,
                          decoration: _inputDecoration(
                            context,
                            'Digite sua senha',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _model.inputSenhaVisibility1
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                              ),
                              onPressed: () => setState(() {
                                _model.inputSenhaVisibility1 =
                                    !_model.inputSenhaVisibility1;
                              }),
                            ),
                          ),
                          validator: _model.inputSenhaTextController1Validator
                              .asValidator(context),
                        ),
          
                        const SizedBox(height: 16),
          
                        // Campo Confirmar Senha
                        Text(
                          'Confirmar Senha',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _model.inputSenhaTextController2,
                          focusNode: _model.inputSenhaFocusNode2,
                          obscureText: !_model.inputSenhaVisibility2,
                          decoration: _inputDecoration(
                            context,
                            'Confirme sua senha',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _model.inputSenhaVisibility2
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                              ),
                              onPressed: () => setState(() {
                                _model.inputSenhaVisibility2 =
                                    !_model.inputSenhaVisibility2;
                              }),
                            ),
                          ),
                          validator: _model.inputSenhaTextController2Validator
                              .asValidator(context),
                        ),
          
                        const SizedBox(height: 16),
          
                        // Checkbox Termos
                        Row(
                          children: [
                            Checkbox(
                                value: _model.checkboxValue ??= true,
                                onChanged: (value) =>
                                    setState(() => _model.checkboxValue = value),
                                activeColor: FlutterFlowTheme.of(context).primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                )),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Eu concordo com os ',
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                  children: [
                                    TextSpan(
                                      text: 'Termos de Serviço',
                                      style: TextStyle(
                                        color:
                                            FlutterFlowTheme.of(context).primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const TextSpan(text: ' e '),
                                    TextSpan(
                                      text: 'Política de Privacidade',
                                      style: TextStyle(
                                        color:
                                            FlutterFlowTheme.of(context).primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
          
                        const SizedBox(height: 24),
          
                        // Botão Cadastrar
                        FilledButton(
                          onPressed: _registerUser,
                          style: FilledButton.styleFrom(
                            backgroundColor: Color(0xFFEC8D0D),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'CADASTRAR',
                            style:
                                FlutterFlowTheme.of(context).titleMedium.override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
          
                        const SizedBox(height: 24),
          
                        // Já tem conta? Login
                        TextButton(
                          onPressed: () =>
                              context.pushNamed(Tela00LoginWidget.routeName),
                          child: RichText(
                            text: TextSpan(
                              text: 'Já tem uma conta? ',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              children: [
                                TextSpan(
                                  text: 'Faça login',
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  InputDecoration _inputDecoration(
    BuildContext context,
    String hintText, {
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
            fontFamily: 'Inter',
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
      filled: true,
      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).error,
          width: 2,
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    String nomeCompleto = _model.inputMomeCompletoTextController?.text ?? '';
    String telefone = _model.inputTelefoneTextController?.text ?? '';
    String email = _model.inputEmailTextController?.text ?? '';
    String senha = _model.inputSenhaTextController1?.text ?? '';

    if (nomeCompleto.isEmpty ||
        telefone.isEmpty ||
        email.isEmpty ||
        senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preencha todos os campos.")),
      );
      return;
    }

    String phoneNumber = '+244' + telefone;
    await UserService().sendOtp(phoneNumber);

    bool? otpResult = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: const ModalValidaContaWidget(),
          ),
        );
      },
    );

    if (otpResult != null && otpResult) {
      final user = CreateUserRequest(
        name: nomeCompleto,
        password: senha,
        email: email,
        phone_number: telefone,
        phone_number_mask: '+244',
        role: RoleEnum.JOGADOR,
      );

      var result = await UserService().createUser(user);

      if (result['isSuccess'] == true) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.transparent,
            child: SuccessDialogWidget(
              message: 'Cadastramento feito com sucesso!',
              onOk: () => context.pushNamed(Tela00LoginWidget.routeName),
            ),
          ),
        );
      } else {
        await showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: "Erro",
          barrierColor: Colors.black54,
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) {
            return Center(
              child: ErrorDialogWidget(
                message: 'Erro ao cadastrar. Tente novamente.',
                onOk: () => Navigator.of(context).pop(),
              ),
            );
          },
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
              child: child,
            );
          },
        );
      }
    }
  }
}
