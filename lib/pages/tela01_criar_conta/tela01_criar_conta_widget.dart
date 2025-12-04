import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/models/requests/user_request.dart';
import 'package:projeto_game_quiz/dialogs/error-dialog-widget.dart';
import 'package:projeto_game_quiz/dialogs/success-dialog-widget.dart';
import 'package:projeto_game_quiz/pages/tela00_login/tela00_login_widget.dart';
import '/components/modal_valida_conta_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
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

class _Tela01CriarContaWidgetState extends State<Tela01CriarContaWidget>
    with SingleTickerProviderStateMixin {
  late Tela01CriarContaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Cores modernas alinhadas com o tema (mesmas da tela de login)
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
  final Color _warningColor = Color(0xFFF59E0B);

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
  late Animation<double> _slideAnimation;

  // URL da imagem ORIGINAL (mesma da tela de login)
  final String _heroImageUrl =
      'https://images.unsplash.com/photo-1604594849809-dfedbc827105?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw3fHxtb25leXxlbnwwfHx8fDE3NDM2MjA1MTR8MA&ixlib=rb-4.0.3&q=80&w=1080';

  // Estado para controle do loading
  bool _isSendingOtp = false;

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

    // Configura animações (iguais à tela de login)
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

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Inicializar validadores
    _initializeValidators();

    _animationController.forward();
  }

  void _initializeValidators() {
    // Validador para Nome Completo
    _model.inputMomeCompletoTextControllerValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, insira seu nome completo';
      }
      if (value.trim().split(' ').length < 2) {
        return 'Por favor, insira seu nome completo (nome e sobrenome)';
      }
      return null;
    };

    // Validador para Telefone
    _model.inputTelefoneTextControllerValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, insira seu número de telefone';
      }
      // Remove espaços e caracteres especiais
      final phoneDigits = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (phoneDigits.length < 9) {
        return 'Por favor, insira um número de telefone válido (mínimo 9 dígitos)';
      }
      return null;
    };

    // Validador para Email
    _model.inputEmailTextControllerValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, insira seu email';
      }
      final emailRegex =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(value.trim())) {
        return 'Por favor, insira um email válido';
      }
      return null;
    };

    // Validador para Senha
    _model.inputSenhaTextController1Validator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, insira uma senha';
      }
      if (value.length < 6) {
        return 'A senha deve ter pelo menos 6 caracteres';
      }
      return null;
    };

    // Validador para Confirmar Senha
    _model.inputSenhaTextController2Validator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, confirme sua senha';
      }
      if (value != _model.inputSenhaTextController1?.text) {
        return 'As senhas não coincidem';
      }
      return null;
    };
  }

  @override
  void dispose() {
    _model.dispose();
    _animationController.dispose();
    super.dispose();
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
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
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
                          SizedBox(height: isMobile ? 24 : 32),

                          // Formulário de cadastro
                          _buildRegisterForm(
                              isMobile, isTablet, isDesktop, screenWidth),
                          SizedBox(height: isMobile ? 40 : 60),
                        ],
                      ),
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
      circleSize = screenWidth * 0.4;
      contentPadding = 24;
    } else if (isTablet) {
      circleSize = 200;
      contentPadding = 40;
    } else {
      circleSize = 220;
      contentPadding = 60;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + (isMobile ? 40 : 60),
        bottom: isMobile ? 24 : 32,
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
          Container(
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
                  // Imagem Hero - MESMA IMAGEM DA TELA DE LOGIN
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
                              Icons.person_add_alt_1_rounded,
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
          SizedBox(height: isMobile ? 24 : 32),

          // Conteúdo textual
          Container(
            constraints: BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              children: [
                Text(
                  'Criar Nova Conta',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 28 : (isTablet ? 36 : 40),
                    fontWeight: FontWeight.w800,
                    color: _textPrimary,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 12),

                Text(
                  'Preencha seus dados para começar sua jornada conosco',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 15,
                    color: _textSecondary,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 24),

                // Indicadores de benefícios
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
                        icon: Icons.stars_rounded,
                        text: 'Benefícios',
                        isMobile: isMobile,
                      ),
                      Container(
                        width: 1,
                        height: isMobile ? 25 : 30,
                        color: _borderColor,
                      ),
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
                        icon: Icons.rocket_launch_rounded,
                        text: 'Rápido',
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

  Widget _buildRegisterForm(
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
              margin: EdgeInsets.only(bottom: 24),
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
                        Icons.person_add_alt_1_rounded,
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
                          'Dados da Conta',
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 20,
                            fontWeight: FontWeight.w700,
                            color: _textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Preencha todos os campos obrigatórios',
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
                  // Campo Nome Completo
                  Text(
                    'Nome Completo *',
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
                        color: _model.inputMomeCompletoFocusNode!.hasFocus
                            ? _primaryColor
                            : _borderColor,
                        width: _model.inputMomeCompletoFocusNode!.hasFocus
                            ? 2
                            : 1.5,
                      ),
                      boxShadow: _model.inputMomeCompletoFocusNode!.hasFocus
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
                              Icons.person_outline_rounded,
                              color: _model.inputMomeCompletoFocusNode!.hasFocus
                                  ? _primaryColor
                                  : _textSecondary,
                              size: isMobile ? 20 : 22,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _model.inputMomeCompletoTextController,
                            focusNode: _model.inputMomeCompletoFocusNode,
                            style: TextStyle(
                              fontSize: isMobile ? 15 : 16,
                              fontWeight: FontWeight.w500,
                              color: _textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Seu nome completo',
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
                            validator: _model
                                .inputMomeCompletoTextControllerValidator
                                .asValidator(context),
                            onTap: () => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Campo Telefone
                  Text(
                    'Telefone *',
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
                        color: _model.inputTelefoneFocusNode!.hasFocus
                            ? _primaryColor
                            : _borderColor,
                        width:
                            _model.inputTelefoneFocusNode!.hasFocus ? 2 : 1.5,
                      ),
                      boxShadow: _model.inputTelefoneFocusNode!.hasFocus
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
                              Icons.phone_outlined,
                              color: _model.inputTelefoneFocusNode!.hasFocus
                                  ? _primaryColor
                                  : _textSecondary,
                              size: isMobile ? 20 : 22,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _model.inputTelefoneTextController,
                            focusNode: _model.inputTelefoneFocusNode,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                              fontSize: isMobile ? 15 : 16,
                              fontWeight: FontWeight.w500,
                              color: _textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: '999-999-999',
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
                            validator: _model
                                .inputTelefoneTextControllerValidator
                                .asValidator(context),
                            onTap: () => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Campo Email
                  Text(
                    'Email *',
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
                  SizedBox(height: 16),

                  // Campo Senha
                  Text(
                    'Senha *',
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
                        color: _model.inputSenhaFocusNode1!.hasFocus
                            ? _primaryColor
                            : _borderColor,
                        width: _model.inputSenhaFocusNode1!.hasFocus ? 2 : 1.5,
                      ),
                      boxShadow: _model.inputSenhaFocusNode1!.hasFocus
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
                              color: _model.inputSenhaFocusNode1!.hasFocus
                                  ? _primaryColor
                                  : _textSecondary,
                              size: isMobile ? 20 : 22,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _model.inputSenhaTextController1,
                            focusNode: _model.inputSenhaFocusNode1,
                            obscureText: !_model.inputSenhaVisibility1,
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
                            validator: _model.inputSenhaTextController1Validator
                                .asValidator(context),
                            onTap: () => setState(() {}),
                          ),
                        ),
                        Container(
                          width: isMobile ? 48 : 56,
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                _model.inputSenhaVisibility1
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                size: isMobile ? 20 : 22,
                                color: _model.inputSenhaFocusNode1!.hasFocus
                                    ? _primaryColor
                                    : _textSecondary,
                              ),
                              onPressed: () => setState(() {
                                _model.inputSenhaVisibility1 =
                                    !_model.inputSenhaVisibility1;
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Campo Confirmar Senha
                  Text(
                    'Confirmar Senha *',
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
                        color: _model.inputSenhaFocusNode2!.hasFocus
                            ? _primaryColor
                            : _borderColor,
                        width: _model.inputSenhaFocusNode2!.hasFocus ? 2 : 1.5,
                      ),
                      boxShadow: _model.inputSenhaFocusNode2!.hasFocus
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
                              Icons.lock_reset_rounded,
                              color: _model.inputSenhaFocusNode2!.hasFocus
                                  ? _primaryColor
                                  : _textSecondary,
                              size: isMobile ? 20 : 22,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _model.inputSenhaTextController2,
                            focusNode: _model.inputSenhaFocusNode2,
                            obscureText: !_model.inputSenhaVisibility2,
                            style: TextStyle(
                              fontSize: isMobile ? 15 : 16,
                              fontWeight: FontWeight.w500,
                              color: _textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Confirme sua senha',
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
                            validator: _model.inputSenhaTextController2Validator
                                .asValidator(context),
                            onTap: () => setState(() {}),
                          ),
                        ),
                        Container(
                          width: isMobile ? 48 : 56,
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                _model.inputSenhaVisibility2
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                size: isMobile ? 20 : 22,
                                color: _model.inputSenhaFocusNode2!.hasFocus
                                    ? _primaryColor
                                    : _textSecondary,
                              ),
                              onPressed: () => setState(() {
                                _model.inputSenhaVisibility2 =
                                    !_model.inputSenhaVisibility2;
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Checkbox Termos e Políticas
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
                            onChanged: (value) =>
                                setState(() => _model.checkboxValue = value),
                            activeColor: Colors.transparent,
                            checkColor: Colors.white,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'Eu concordo com os ',
                            style: TextStyle(
                              fontSize: isMobile ? 12 : 13,
                              color: _textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: 'Termos de Serviço',
                                style: TextStyle(
                                  color: _primaryColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' e '),
                              TextSpan(
                                text: 'Política de Privacidade',
                                style: TextStyle(
                                  color: _primaryColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28),

                  // Botão de Cadastrar
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
                        onTap: _registerUser,
                        child: _isSendingOtp || _model.isRegistering
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
                                      _isSendingOtp
                                          ? 'Enviando OTP...'
                                          : 'Cadastrando...',
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
                                  'CADASTRAR',
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

                  // Botão Voltar para Login
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
                          context.pushNamed(Tela00LoginWidget.routeName);
                        },
                        child: Center(
                          child: Text(
                            'VOLTAR PARA LOGIN',
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
                  SizedBox(height: 8),

                  // Nota sobre campos obrigatórios
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      '* Campos obrigatórios',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 12,
                        color: _textTertiary,
                        fontStyle: FontStyle.italic,
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

  // ... restante do código mantido ...

  Future<void> _registerUser() async {
    // Validação básica
    if (_model.formKey.currentState?.validate() ?? false) {
      if (!(_model.checkboxValue ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Você precisa aceitar os Termos de Serviço e Política de Privacidade',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: _warningColor,
          ),
        );
        return;
      }

      String nomeCompleto = _model.inputMomeCompletoTextController?.text ?? '';
      String telefone = _model.inputTelefoneTextController?.text ?? '';
      String email = _model.inputEmailTextController?.text ?? '';
      String senha = _model.inputSenhaTextController1?.text ?? '';
      String confirmarSenha = _model.inputSenhaTextController2?.text ?? '';

      if (senha != confirmarSenha) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'As senhas não coincidem',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: _errorColor,
          ),
        );
        return;
      }

      // Variável para controlar o resultado do OTP
      bool? otpResult = false;

      try {
        // Configuração do estado de carregamento para envio do OTP
        setState(() {
          _isSendingOtp = true;
        });

        // Envia OTP com loading
        String phoneNumber = '+244' + telefone;
        await UserService().sendOtp(phoneNumber);

        // Finaliza loading do OTP
        setState(() {
          _isSendingOtp = false;
        });

        // Configura estado de carregamento para criação do usuário
        setState(() {
          _model.isRegistering = true;
        });

        // Mostra modal de validação
        otpResult = await showModalBottomSheet<bool>(
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

        // Verifica se o usuário cancelou o modal de OTP
        if (otpResult == null) {
          setState(() {
            _model.isRegistering = false;
          });
          return;
        }

        if (otpResult) {
          // Cria usuário
          final user = CreateUserRequest(
            name: nomeCompleto,
            password: senha,
            email: email,
            phone_number: telefone,
            phone_number_mask: '+244',
            role: RoleEnum.JOGADOR,
          );

          var result = await UserService().createUser(user);

          // Finaliza loading da criação do usuário
          print("result do cadastro: $result");
          setState(() {
            _model.isRegistering = false;
          });

          if (result['isSuccess'] == true) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: Colors.transparent,
                child: SuccessDialogWidget(
                  message: 'Cadastro realizado com sucesso!',
                  onOk: () {
                    Navigator.of(context).pop(); // Fecha o diálogo de sucesso
                    context.pushNamed(
                        Tela00LoginWidget.routeName); // Vai para login
                  },
                ),
              ),
            );
          } else {
            // Mostra diálogo de erro SEM fechar a tela de cadastro
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
                    onOk: () {
                      Navigator.of(context)
                          .pop(); // Apenas fecha o diálogo de erro
                      // NÃO navega para outra tela
                    },
                  ),
                );
              },
              transitionBuilder:
                  (context, animation, secondaryAnimation, child) {
                return ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutBack,
                  ),
                  child: child,
                );
              },
            );

            // Mantém o usuário na tela de cadastro para tentar novamente
            setState(() {
              _model.isRegistering = false;
            });
          }
        } else {
          // Se a validação OTP falhou (usuário inseriu código errado)
          setState(() {
            _model.isRegistering = false;
          });

          // Mostra mensagem informativa
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Validação OTP falhou. Tente novamente.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: _warningColor,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        // Em caso de erro, remove todos os loadings
        setState(() {
          _isSendingOtp = false;
          _model.isRegistering = false;
        });

        // Se houve erro no envio do OTP ou outro erro, mostra mensagem SEM fechar a tela
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao processar cadastro. Tente novamente.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: _errorColor,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
