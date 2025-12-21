import 'dart:math';
import 'package:projeto_game_quiz/pages/tela01_criar_conta/tela01_criar_conta_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
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

class _Tela00LoginWidgetState extends State<Tela00LoginWidget>
    with SingleTickerProviderStateMixin {
  late Tela00LoginModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Cores modernas alinhadas com o tema
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _primaryLight = Color(0xFFFDE68A);
  final Color _primaryDark = Color(0xFFD97706);
  final Color _backgroundColor = Color(0xFFFAFAFA);
  final Color _surfaceColor = Color(0xFFFFFFFF);
  final Color _textPrimary = Color(0xFF1F2937);
  final Color _textSecondary = Color(0xFF6B7280);
  final Color _textTertiary = Color(0xFF9CA3AF);
  final Color _borderColor = Color(0xFFE5E7EB);
  final Color _successColor = Color(0xFF10B981);
  final Color _errorColor = Color(0xFFEF4444);

  // Gradiente
  final LinearGradient _primaryGradient = LinearGradient(
    colors: [
      Color(0xFFEC8D0D),
      Color(0xFFF59E0B),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Animações
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  // URL da imagem ORIGINAL (mesma da tela de cadastro)
  final String _heroImageUrl =
      'https://images.unsplash.com/photo-1604594849809-dfedbc827105?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw3fHxtb25leXxlbnwwfHx8fDE3NDM2MjA1MTR8MA&ixlib=rb-4.0.3&q=80&w=1080';

  // Controladores para o modal de recuperação de senha
  final TextEditingController _emailRecuperacaoController =
      TextEditingController();
  final FocusNode _emailRecuperacaoFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela00LoginModel());

    // Inicializa controladores originais
    _model.inputEmailTextController ??= TextEditingController();
    _model.inputEmailFocusNode ??= FocusNode();

    _model.inputSenhaTextController ??= TextEditingController();
    _model.inputSenhaFocusNode ??= FocusNode();

    // Configura animações
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _rotateAnimation = Tween<double>(begin: -0.05, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _model.dispose();
    _animationController.dispose();
    _emailRecuperacaoController.dispose();
    _emailRecuperacaoFocusNode.dispose();
    super.dispose();
  }

  // Método para exibir modal de recuperação de senha
  void _showPasswordRecoveryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).viewInsets.top > 0 ? 0 : 50,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: _buildPasswordRecoveryModal(context),
            ),
          ),
        );
      },
    );
  }

  // Widget do modal de recuperação de senha
  // Widget do modal de recuperação de senha (ATUALIZADO)
  Widget _buildPasswordRecoveryModal(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isMobile = screenWidth < 768;

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          margin: EdgeInsets.all(isMobile ? 16 : 24),
          decoration: BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabeçalho do modal
              Container(
                padding: EdgeInsets.all(isMobile ? 24 : 32),
                decoration: BoxDecoration(
                  gradient: _primaryGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: isMobile ? 48 : 56,
                      height: isMobile ? 48 : 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.lock_reset_rounded,
                          color: Colors.white,
                          size: isMobile ? 24 : 28,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recuperar Senha',
                            style: TextStyle(
                              fontSize: isMobile ? 20 : 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _model.isRecoveryEmailSelected
                                ? 'Enviaremos um link de recuperação para seu email'
                                : 'Enviaremos um código de verificação para seu telefone',
                            style: TextStyle(
                              fontSize: isMobile ? 13 : 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Conteúdo do modal
              Padding(
                padding: EdgeInsets.all(isMobile ? 24 : 32),
                child: Column(
                  children: [
                    Text(
                      _model.isRecoveryEmailSelected
                          ? 'Digite o email associado à sua conta e enviaremos instruções para redefinir sua senha.'
                          : 'Digite o número de telefone associado à sua conta e enviaremos um código de verificação.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 15,
                        color: _textSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),

                    // Opções de método de recuperação
                    Container(
                      decoration: BoxDecoration(
                        color: _primaryLight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _borderColor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(13),
                                  bottomLeft: Radius.circular(13),
                                ),
                                onTap: () {
                                  setModalState(() {
                                    _model.setRecoveryMethod(
                                        setModalState, true);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isMobile ? 14 : 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _model.isRecoveryEmailSelected
                                        ? _primaryColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(13),
                                      bottomLeft: Radius.circular(13),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.email_outlined,
                                        color: _model.isRecoveryEmailSelected
                                            ? Colors.white
                                            : _textSecondary,
                                        size: isMobile ? 20 : 22,
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Email',
                                        style: TextStyle(
                                          fontSize: isMobile ? 12 : 13,
                                          fontWeight: FontWeight.w600,
                                          color: _model.isRecoveryEmailSelected
                                              ? Colors.white
                                              : _textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1.5,
                            height: 40,
                            color: _borderColor,
                          ),
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(13),
                                  bottomRight: Radius.circular(13),
                                ),
                                onTap: () {
                                  setModalState(() {
                                    _model.setRecoveryMethod(
                                        setModalState, false);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isMobile ? 14 : 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !_model.isRecoveryEmailSelected
                                        ? _primaryColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(13),
                                      bottomRight: Radius.circular(13),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.phone_android_outlined,
                                        color: !_model.isRecoveryEmailSelected
                                            ? Colors.white
                                            : _textSecondary,
                                        size: isMobile ? 20 : 22,
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Telefone',
                                        style: TextStyle(
                                          fontSize: isMobile ? 12 : 13,
                                          fontWeight: FontWeight.w600,
                                          color: !_model.isRecoveryEmailSelected
                                              ? Colors.white
                                              : _textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Campo dinâmico baseado na escolha
                    if (_model.isRecoveryEmailSelected)
                      // Campo de email
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _model.emailRecoveryFocusNode.hasFocus
                                ? _primaryColor
                                : _borderColor,
                            width: _model.emailRecoveryFocusNode.hasFocus
                                ? 2
                                : 1.5,
                          ),
                          boxShadow: _model.emailRecoveryFocusNode.hasFocus
                              ? [
                                  BoxShadow(
                                    color: _primaryColor.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: isMobile ? 48 : 56,
                              child: Center(
                                child: Icon(
                                  Icons.email_outlined,
                                  color: _model.emailRecoveryFocusNode.hasFocus
                                      ? _primaryColor
                                      : _textSecondary,
                                  size: isMobile ? 20 : 22,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _model.emailRecoveryController,
                                focusNode: _model.emailRecoveryFocusNode,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  fontSize: isMobile ? 15 : 16,
                                  fontWeight: FontWeight.w500,
                                  color: _textPrimary,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'seu@email.com',
                                  hintStyle: TextStyle(
                                    color: _textTertiary,
                                    fontSize: isMobile ? 14 : 15,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: isMobile ? 16 : 18,
                                  ),
                                ),
                                onChanged: (value) {
                                  // Atualiza em tempo real se quiser validação
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      // Campo de telefone
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _model.phoneRecoveryFocusNode.hasFocus
                                ? _primaryColor
                                : _borderColor,
                            width: _model.phoneRecoveryFocusNode.hasFocus
                                ? 2
                                : 1.5,
                          ),
                          boxShadow: _model.phoneRecoveryFocusNode.hasFocus
                              ? [
                                  BoxShadow(
                                    color: _primaryColor.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: isMobile ? 48 : 56,
                              child: Center(
                                child: Icon(
                                  Icons.phone_android_outlined,
                                  color: _model.phoneRecoveryFocusNode.hasFocus
                                      ? _primaryColor
                                      : _textSecondary,
                                  size: isMobile ? 20 : 22,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _model.phoneRecoveryController,
                                focusNode: _model.phoneRecoveryFocusNode,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                  fontSize: isMobile ? 15 : 16,
                                  fontWeight: FontWeight.w500,
                                  color: _textPrimary,
                                ),
                                decoration: InputDecoration(
                                  hintText: '(11) 99999-9999',
                                  hintStyle: TextStyle(
                                    color: _textTertiary,
                                    fontSize: isMobile ? 14 : 15,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: isMobile ? 16 : 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 32),

                    // Botões de ação
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: isMobile ? 50 : 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _borderColor,
                                width: 1.5,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  // Limpa os campos
                                  _model.emailRecoveryController?.clear();
                                  _model.phoneRecoveryController?.clear();
                                },
                                child: Center(
                                  child: Text(
                                    'CANCELAR',
                                    style: TextStyle(
                                      color: _textSecondary,
                                      fontSize: isMobile ? 14 : 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: isMobile ? 50 : 56,
                            decoration: BoxDecoration(
                              gradient: _primaryGradient,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: _primaryColor.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: _model.isSendingRecoveryCode
                                    ? null
                                    : () async {
                                        // VALIDAÇÃO DIRETA
                                        if (_model.isRecoveryEmailSelected) {
                                          final email = _model
                                                  .emailRecoveryController?.text
                                                  .trim() ??
                                              '';

                                          if (email.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text('Informe seu email'),
                                                backgroundColor: _errorColor,
                                              ),
                                            );
                                            return;
                                          }

                                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                              .hasMatch(email)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text('Email inválido'),
                                                backgroundColor: _errorColor,
                                              ),
                                            );
                                            return;
                                          }

                                          // INICIA LOADING
                                          _model.setSendingRecoveryCode(
                                              setModalState, true);

                                          try {
                                            // CHAMA O USER SERVICE DIRETO
                                            final result = await _model
                                                .userService
                                                .requestPasswordReset(email);

                                            // FECHA O MODAL
                                            Navigator.of(context).pop();

                                            // VERIFICA RESPOSTA
                                            if (result['isSuccess'] == true ||
                                                result['success'] == true) {
                                              _showSuccessMessage(
                                                context,
                                                '✅ Email enviado!',
                                                'Verifique sua caixa de entrada e siga as instruções para redefinir sua senha.',
                                              );
                                              print(
                                                  '✅ Recuperação enviada para: $email');
                                            } else {
                                              _showErrorMessage(
                                                context,
                                                result['message'] ??
                                                    'Falha ao enviar email',
                                              );
                                              print(
                                                  '❌ Erro: ${result['message']}');
                                            }
                                          } catch (e) {
                                            Navigator.of(context).pop();
                                            _showErrorMessage(
                                              context,
                                              'Erro: ${e.toString()}',
                                            );
                                            print('❌ Exception: $e');
                                          } finally {
                                            _model.setSendingRecoveryCode(
                                                setModalState, false);
                                          }
                                        } else {
                                          // PARA TELEFONE (EM DESENVOLVIMENTO)
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Recuperação por SMS em desenvolvimento'),
                                              backgroundColor: _primaryColor,
                                            ),
                                          );
                                        }
                                      },
                                child: Center(
                                  child: _model.isSendingRecoveryCode
                                      ? SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              _model.isRecoveryEmailSelected
                                                  ? Icons.send_rounded
                                                  : Icons.sms_rounded,
                                              color: Colors.white,
                                              size: isMobile ? 18 : 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              _model.isRecoveryEmailSelected
                                                  ? 'ENVIAR LINK'
                                                  : 'ENVIAR CÓDIGO',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: isMobile ? 14 : 15,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    Container(
                      padding: EdgeInsets.all(isMobile ? 12 : 16),
                      decoration: BoxDecoration(
                        color: _primaryLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _primaryColor.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: _primaryColor,
                            size: isMobile ? 16 : 18,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _model.isRecoveryEmailSelected
                                  ? 'Verifique sua caixa de spam se não receber o email em alguns minutos. O link expira em 1 hora.'
                                  : 'O código SMS pode levar alguns minutos para chegar. Certifique-se de que o número está correto.',
                              style: TextStyle(
                                fontSize: isMobile ? 12 : 13,
                                color: _textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessMessage(BuildContext context, String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _successColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: _surfaceColor,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: _successColor.withOpacity(0.2),
          ),
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _errorColor,
      ),
    );
  }

  Future<void> _simularEnvioEmailRecuperacao(BuildContext context) async {
    // Mostra indicador de carregamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: _primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Enviando...',
                style: TextStyle(
                  fontSize: 10,
                  color: _textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Simula delay de rede
    await Future.delayed(Duration(seconds: 2));

    // Fecha o diálogo de carregamento
    Navigator.of(context).pop();

    // Fecha o modal de recuperação
    Navigator.of(context).pop();

    // Mostra mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _successColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email enviado com sucesso!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Verifique sua caixa de entrada',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: _surfaceColor,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: _successColor.withOpacity(0.2),
          ),
        ),
        duration: Duration(seconds: 4),
      ),
    );

    // Limpa o campo de email
    _emailRecuperacaoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _backgroundColor,
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: mediaQuery.size.height,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Header com imagem circular
                        _buildCircularImageHeader(
                            isMobile, isTablet, isDesktop, screenWidth),
                        SizedBox(height: isMobile ? 32 : 48),

                        // Formulário de login
                        _buildLoginForm(
                            isMobile, isTablet, isDesktop, screenWidth),
                        SizedBox(height: isMobile ? 40 : 60),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCircularImageHeader(
      bool isMobile, bool isTablet, bool isDesktop, double screenWidth) {
    // Tamanho responsivo do círculo
    double circleSize;
    double contentPadding;

    if (isMobile) {
      circleSize = screenWidth * 0.5;
      contentPadding = 24;
    } else if (isTablet) {
      circleSize = 220;
      contentPadding = 40;
    } else {
      circleSize = 240;
      contentPadding = 60;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + (isMobile ? 40 : 60),
        bottom: isMobile ? 32 : 48,
        left: contentPadding,
        right: contentPadding,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _primaryColor.withOpacity(0.08),
            _backgroundColor.withOpacity(0.02),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Container circular da imagem
          Transform.rotate(
            angle: _rotateAnimation.value,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.2),
                    blurRadius: 30,
                    offset: Offset(0, 15),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Stack(
                  children: [
                    // Imagem Hero - MESMA IMAGEM DA TELA DE CADASTRO
                    Hero(
                      tag: 'app_logo',
                      child: Image.network(
                        _heroImageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: _primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: _primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.account_circle_rounded,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Borda sutil para realce
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 32 : 40),

          // Conteúdo textual
          Container(
            constraints: BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              children: [
                Text(
                  'Bem-vindo de Volta!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 28 : (isTablet ? 36 : 40),
                    fontWeight: FontWeight.w800,
                    color: _textPrimary,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: isMobile ? 24 : 32),

                // Indicadores
                Container(
                  padding: EdgeInsets.all(isMobile ? 16 : 20),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: _borderColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFeatureItem(
                        icon: Icons.security_rounded,
                        text: 'Seguro',
                        isMobile: isMobile,
                      ),
                      Container(
                        width: 1,
                        height: isMobile ? 25 : 30,
                        color: _borderColor,
                      ),
                      _buildFeatureItem(
                        icon: Icons.bolt_rounded,
                        text: 'Rápido',
                        isMobile: isMobile,
                      ),
                      Container(
                        width: 1,
                        height: isMobile ? 25 : 30,
                        color: _borderColor,
                      ),
                      _buildFeatureItem(
                        icon: Icons.device_hub_rounded,
                        text: 'Multiplataforma',
                        isMobile: isMobile,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String text,
    required bool isMobile,
  }) {
    return Column(
      children: [
        Container(
          width: isMobile ? 36 : 40,
          height: isMobile ? 36 : 40,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: _primaryColor.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              color: _primaryColor,
              size: isMobile ? 16 : 18,
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: isMobile ? 10 : 11,
            fontWeight: FontWeight.w600,
            color: _textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(
      bool isMobile, bool isTablet, bool isDesktop, double screenWidth) {
    double formWidth;

    if (isMobile) {
      formWidth = screenWidth * 0.9;
    } else if (isTablet) {
      formWidth = 500;
    } else {
      formWidth = 450;
    }

    return Center(
      child: Container(
        width: formWidth,
        padding: EdgeInsets.all(isMobile ? 24 : 32),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 25,
              offset: Offset(0, 12),
              spreadRadius: -5,
            ),
          ],
          border: Border.all(
            color: _borderColor.withOpacity(0.6),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            // Cabeçalho do formulário
            Container(
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              margin: EdgeInsets.only(bottom: 28),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _primaryColor.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: isMobile ? 44 : 48,
                    height: isMobile ? 44 : 48,
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.login_rounded,
                        color: Colors.white,
                        size: isMobile ? 22 : 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Acesso à Conta',
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 20,
                            fontWeight: FontWeight.w700,
                            color: _textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Insira suas credenciais para continuar',
                          style: TextStyle(
                            fontSize: isMobile ? 13 : 14,
                            color: _textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Formulário
            Form(
              key: _model.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo Email
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _model.inputEmailFocusNode!.hasFocus
                            ? _primaryColor
                            : _borderColor,
                        width: _model.inputEmailFocusNode!.hasFocus ? 2 : 1.5,
                      ),
                      boxShadow: _model.inputEmailFocusNode!.hasFocus
                          ? [
                              BoxShadow(
                                color: _primaryColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: isMobile ? 48 : 56,
                          child: Center(
                            child: Icon(
                              Icons.email_outlined,
                              color: _model.inputEmailFocusNode!.hasFocus
                                  ? _primaryColor
                                  : _textSecondary,
                              size: isMobile ? 20 : 22,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _model.inputEmailTextController,
                            focusNode: _model.inputEmailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              fontSize: isMobile ? 15 : 16,
                              fontWeight: FontWeight.w500,
                              color: _textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'seu@email.com',
                              hintStyle: TextStyle(
                                color: _textTertiary,
                                fontSize: isMobile ? 14 : 15,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: isMobile ? 16 : 18,
                              ),
                              errorStyle: TextStyle(
                                color: _errorColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            validator: _model.inputEmailTextControllerValidator
                                .asValidator(context),
                            onTap: () => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Campo Senha
                  Text(
                    'Senha',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _model.inputSenhaFocusNode!.hasFocus
                            ? _primaryColor
                            : _borderColor,
                        width: _model.inputSenhaFocusNode!.hasFocus ? 2 : 1.5,
                      ),
                      boxShadow: _model.inputSenhaFocusNode!.hasFocus
                          ? [
                              BoxShadow(
                                color: _primaryColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: isMobile ? 48 : 56,
                          child: Center(
                            child: Icon(
                              Icons.lock_outline_rounded,
                              color: _model.inputSenhaFocusNode!.hasFocus
                                  ? _primaryColor
                                  : _textSecondary,
                              size: isMobile ? 20 : 22,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _model.inputSenhaTextController,
                            focusNode: _model.inputSenhaFocusNode,
                            obscureText: !_model.inputSenhaVisibility,
                            style: TextStyle(
                              fontSize: isMobile ? 15 : 16,
                              fontWeight: FontWeight.w500,
                              color: _textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Digite sua senha',
                              hintStyle: TextStyle(
                                color: _textTertiary,
                                fontSize: isMobile ? 14 : 15,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: isMobile ? 16 : 18,
                              ),
                              errorStyle: TextStyle(
                                color: _errorColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            validator: _model.inputSenhaTextControllerValidator
                                .asValidator(context),
                            onTap: () => setState(() {}),
                          ),
                        ),
                        Container(
                          width: isMobile ? 48 : 56,
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                _model.inputSenhaVisibility
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                size: isMobile ? 20 : 22,
                                color: _model.inputSenhaFocusNode!.hasFocus
                                    ? _primaryColor
                                    : _textSecondary,
                              ),
                              onPressed: () => setState(() {
                                _model.inputSenhaVisibility =
                                    !_model.inputSenhaVisibility;
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Lembrar senha e Esqueci a senha
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: isMobile ? 20 : 24,
                            height: isMobile ? 20 : 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _model.checkboxValue == true
                                    ? _primaryColor
                                    : _borderColor,
                                width: _model.checkboxValue == true ? 0 : 2,
                              ),
                              color: _model.checkboxValue == true
                                  ? _primaryColor
                                  : Colors.transparent,
                            ),
                            child: Theme(
                              data: ThemeData(
                                unselectedWidgetColor: Colors.transparent,
                              ),
                              child: Checkbox(
                                value: _model.checkboxValue ??= true,
                                onChanged: (value) => setState(
                                    () => _model.checkboxValue = value),
                                activeColor: Colors.transparent,
                                checkColor: Colors.white,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Lembrar senha',
                            style: TextStyle(
                              fontSize: isMobile ? 13 : 14,
                              color: _textSecondary,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          _showPasswordRecoveryModal(context);
                        },
                        child: Text(
                          'Esqueceu a senha?',
                          style: TextStyle(
                            fontSize: isMobile ? 13 : 14,
                            color: _primaryColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28),

                  // Botão de Login
                  Container(
                    height: isMobile ? 52 : 56,
                    decoration: BoxDecoration(
                      gradient: _primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          if (_model.formKey.currentState?.validate() ??
                              false) {
                            await _model.signInAsync(setState);
                          }
                        },
                        child: _model.isLoggingIn
                            ? Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: isMobile ? 20 : 24,
                                      height: isMobile ? 20 : 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Entrando...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isMobile ? 15 : 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: Text(
                                  'ENTRAR',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 15 : 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Divisor
                  Row(
                    children: [
                      Expanded(child: Divider(color: _borderColor)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OU',
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 13,
                            color: _textTertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: _borderColor)),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Botão Criar Nova Conta
                  Container(
                    height: isMobile ? 52 : 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _primaryColor,
                        width: 1.5,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          context.pushNamed(Tela01CriarContaWidget.routeName);
                        },
                        child: Center(
                          child: Text(
                            'CRIAR NOVA CONTA',
                            style: TextStyle(
                              color: _primaryColor,
                              fontSize: isMobile ? 15 : 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
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

  // MÉTODO DE DECORAÇÃO ORIGINAL PRESERVADO (caso ainda seja usado em algum lugar)
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
}
