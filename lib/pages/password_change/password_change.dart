import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/api/utils/token_util.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/enum/password_mode.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/dialogs/success-dialog-widget.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/pages/tela00_login/tela00_login_widget.dart';

class PasswordChangeScreen extends StatefulWidget {
  final PasswordMode mode;
  final String? resetToken;
  const PasswordChangeScreen({super.key, required this.mode, this.resetToken});
  static String routeName = 'passwordChange';
  static String routePath = '/passwordChange';

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  UserResponse? user;

  // Cores do tema premium com laranja como primária
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);
  final Color _successColor = Color(0xFF10B981);
  final Color _errorColor = Color(0xFFEF4444);
  final Color _warningColor = Color(0xFFF59E0B);

  // Gradientes premium
  final LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Estados
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  int _passwordStrength = 0;
  bool _isLoading = false;
  bool isLoading = true;
  bool isValidToken = false;
  bool _showSuccessWidget = false;
  // Animações
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    if (widget.mode == PasswordMode.change) {
      getUserInfo();
    } else {
      _validateToken();
    }
    _animationController.forward();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _analyzePassword(String value) {
    final hasMinLength = value.length >= 8;
    final hasUpperCase = value.contains(RegExp(r'[A-Z]'));
    final hasNumber = value.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    setState(() {
      _passwordStrength = [
        hasMinLength,
        hasUpperCase,
        hasNumber,
        hasSpecialChar
      ].where((e) => e).length;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      Map<String, dynamic> result;

      if (widget.mode == PasswordMode.change) {
        if (user == null) throw Exception("Usuário não encontrado");

        result = await UserService().changePassword(
          user_id: user!.id,
          oldPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );
      } else {
        if (widget.resetToken == null) {
          throw Exception("Token inválido ou ausente");
        }

        result = await UserService().resetPassword(
          token: widget.resetToken!,
          newPassword: _newPasswordController.text,
        );
      }

      setState(() => _isLoading = false);

      if (result['isSuccess'] == true || result['msg'] != null) {
        if (widget.mode == PasswordMode.change) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => SuccessDialogWidget(
              message: 'Senha alterada com sucesso!',
              onOk: () => Navigator.of(context).pop(),
            ),
          );

          TokenUtil.removeToken();
          context.goNamed(Tela00LoginWidget.routeName);
        } else {
          _showSuccessMessage();
          await Future.delayed(Duration(seconds: 7));
          if (mounted) {
            context.goNamed(Tela00LoginWidget.routeName);
          }
        }
      } else {
        _showSnackBar(
          result['error']?['detail']?['message'] ?? 'Erro ao alterar senha',
          _errorColor,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Erro: ${e.toString()}', _errorColor);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
      ),
    );
  }

  void _showSuccessMessage() {
    setState(() {
      _showSuccessWidget = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
                child: Text(
                    'Senha redefinida com sucesso! Agora você pode fazer login com a nova senha no aplicativo ou na web.')),
          ],
        ),
        backgroundColor: _successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        duration: Duration(seconds: 7),
      ),
    );
  }

  Future<void> getUserInfo() async {
    try {
      var _user = await UserUtil.getUserInfo();
      if (_user != null) {
        setState(() {
          user = _user;
          print(user!.id);
        });
      }
    } catch (e) {
      print("Erro ao carregar usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == PasswordMode.reset) {
      if (isLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (!isValidToken) {
        return Scaffold(
          backgroundColor: _backgroundColor,
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500, // Limita a largura máxima para web
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 600 ? 40 : 24,
                  vertical: 24,
                ),
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      // Minimalist error illustration
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: _outlineColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background pulse effect
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      center: Alignment.center,
                                      radius: 0.8,
                                      colors: [
                                        _errorColor.withOpacity(0.03),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Broken link icon with modern design
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: _errorColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.link_off_outlined,
                                    color: _errorColor,
                                    size: 28,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: _warningColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.access_time_outlined,
                                    color: _warningColor,
                                    size: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32),

                      // Title with clean typography
                      Text(
                        'Link Expirado',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: _onSurfaceColor,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 12),

                      // Subtitle
                      Text(
                        'Este link de recuperação não está mais ativo',
                        style: TextStyle(
                          fontSize: 16,
                          color: _onSurfaceColor.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 32),

                      // Clean info cards
                      Column(
                        children: [
                          // Reason card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _outlineColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _errorColor.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.info_outline_rounded,
                                    size: 20,
                                    color: _errorColor,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Motivo',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              _onSurfaceColor.withOpacity(0.8),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'O link foi utilizado anteriormente ou expirou após 30 minutos.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              _onSurfaceColor.withOpacity(0.6),
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 12),

                          // Solution card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _outlineColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _primaryColor.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.refresh_rounded,
                                    size: 20,
                                    color: _primaryColor,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Solução',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              _onSurfaceColor.withOpacity(0.8),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Solicite um novo link de recuperação na página de login.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              _onSurfaceColor.withOpacity(0.6),
                                          height: 1.4,
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

                      SizedBox(height: 40),

                      // Action buttons - clean and modern
                      if (widget.mode == PasswordMode.change) ...[
                        Column(
                          children: [
                            // Primary action
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.goNamed(Tela00LoginWidget.routeName);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  visualDensity: VisualDensity.comfortable,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.arrow_back_rounded,
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Voltar ao Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 16),

                            // Secondary action
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  // Navega para login com foco no campo de recuperação
                                  context.goNamed(
                                    Tela00LoginWidget.routeName,
                                    extra: {'showReset': true},
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  foregroundColor: _primaryColor,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.email_outlined,
                                      size: 18,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Nova solicitação',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24),

                        // Help link - subtle
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              // Mostrar informações de suporte
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    _buildModernHelpDialog(context),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Precisa de ajuda?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _onSurfaceColor.withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      _onSurfaceColor.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ])),
              ),
            ),
          ),
        );
      }
    }

    // ✅ SE CHEGOU AQUI, TUDO OK → MOSTRA A TELA NORMAL
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: child,
            ),
          );
        },
        child: Column(
          children: [
            // Header Premium
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: _primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Botão Voltar Premium
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () {
                                context.safePop();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              splashRadius: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Alterar Senha',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 2,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: 300.0,
                    maxWidth: 500.0,
                  ),
                  padding: EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: _surfaceColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSecurityInfo(),
                                SizedBox(height: 32),
                                if (widget.mode == PasswordMode.change) ...[
                                  _buildPasswordField(
                                    controller: _currentPasswordController,
                                    label: 'Senha Atual',
                                    icon: Icons.lock_rounded,
                                    obscureText: _obscureCurrentPassword,
                                    onToggle: () => setState(() =>
                                        _obscureCurrentPassword =
                                            !_obscureCurrentPassword),
                                    validator: (value) => value?.isEmpty ?? true
                                        ? 'Digite sua senha atual'
                                        : null,
                                  ),
                                  const SizedBox(height: 24),
                                ],
                                _buildPasswordField(
                                  controller: _newPasswordController,
                                  label: 'Nova Senha',
                                  icon: Icons.lock_reset_rounded,
                                  obscureText: _obscureNewPassword,
                                  onChanged: _analyzePassword,
                                  onToggle: () => setState(() =>
                                      _obscureNewPassword =
                                          !_obscureNewPassword),
                                  validator: (value) {
                                    if (value?.isEmpty ?? true)
                                      return 'Digite uma nova senha';
                                    if (value!.length < 6)
                                      return 'Mínimo 6 caracteres';
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                _buildPasswordStrength(),
                                SizedBox(height: 24),
                                _buildPasswordField(
                                  controller: _confirmPasswordController,
                                  label: 'Confirmar Senha',
                                  icon: Icons.lock_clock_rounded,
                                  obscureText: _obscureConfirmPassword,
                                  onToggle: () => setState(() =>
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword),
                                  validator: (value) {
                                    if (value?.isEmpty ?? true)
                                      return 'Confirme sua senha';
                                    if (value != _newPasswordController.text)
                                      return 'As senhas não coincidem';
                                    return null;
                                  },
                                ),
                                SizedBox(height: 32),
                                _buildSubmitButton(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        _buildSecurityTips(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.security_rounded,
              color: _primaryColor,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Segurança da Conta',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _onSurfaceColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Escolha uma senha forte para proteger sua conta',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: _onSurfaceColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscureText,
    required VoidCallback onToggle,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _onSurfaceColor,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          onChanged: onChanged,
          validator: validator,
          style: TextStyle(
            fontFamily: 'Inter',
            color: _onSurfaceColor,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Digite sua $label',
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              color: _onSurfaceColor.withOpacity(0.4),
            ),
            prefixIcon: Container(
              width: 20,
              height: 20,
              margin: EdgeInsets.all(12),
              child: Icon(
                icon,
                color: _primaryColor,
                size: 20,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: _onSurfaceColor.withOpacity(0.4),
                size: 20,
              ),
              onPressed: onToggle,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _outlineColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _outlineColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _errorColor, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _errorColor, width: 2),
            ),
            filled: true,
            fillColor: _surfaceColor,
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStrength() {
    final strengthText = [
      'Muito Fraca',
      'Fraca',
      'Moderada',
      'Forte',
      'Excelente'
    ][_passwordStrength];

    final strengthColor = [
      _errorColor,
      _warningColor,
      Color(0xFF3B82F6),
      _primaryColor,
      _successColor
    ][_passwordStrength];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Força da senha:',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: _onSurfaceColor.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              strengthText,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: strengthColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: _outlineColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            children: [
              Expanded(
                flex: _passwordStrength,
                child: Container(
                  decoration: BoxDecoration(
                    color: strengthColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Expanded(
                flex: 4 - _passwordStrength,
                child: SizedBox(),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildRequirementChip('6+ caracteres', _passwordStrength > 0),
            _buildRequirementChip('Letra maiúscula', _passwordStrength > 1),
            _buildRequirementChip('Número', _passwordStrength > 1),
            _buildRequirementChip('Símbolo especial', _passwordStrength > 2),
          ],
        ),
      ],
    );
  }

  Widget _buildRequirementChip(String text, bool isMet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isMet
            ? _successColor.withOpacity(0.1)
            : _outlineColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isMet ? _successColor : _outlineColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMet ? Icons.check_rounded : Icons.circle_rounded,
            size: 14,
            color: isMet ? _successColor : _onSurfaceColor.withOpacity(0.4),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: isMet ? _successColor : _onSurfaceColor.withOpacity(0.6),
              fontWeight: isMet ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: _primaryColor.withOpacity(0.5),
          ),
          child: _isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_reset_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'ATUALIZAR SENHA',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSecurityTips() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _outlineColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lightbulb_rounded,
                  color: _primaryColor,
                  size: 18,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Dicas de Segurança',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _onSurfaceColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTipItem('Use uma combinação de letras, números e símbolos'),
          _buildTipItem('Evite informações pessoais como nome ou data'),
          _buildTipItem('Não reutilize senhas de outras contas'),
          _buildTipItem('Considere usar um gerenciador de senhas'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: _successColor,
            size: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: _onSurfaceColor.withOpacity(0.7),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _validateToken() async {
    final token = widget.resetToken ?? Uri.base.queryParameters['token'];

    if (token == null || token.isEmpty) {
      setState(() {
        isValidToken = false;
        isLoading = false;
      });
      return;
    }

    try {
      final isValid = await UserService().validateResetToken(token);

      setState(() {
        isValidToken = isValid;
        isLoading = false;
      });
    } catch (_) {
      setState(() {
        isValidToken = false;
        isLoading = false;
      });
    }
  }

  Widget _buildModernHelpDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.help_outline_rounded,
                      color: _primaryColor,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Suporte Técnico',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _onSurfaceColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Se você está com problemas para acessar sua conta:',
                style: TextStyle(
                  fontSize: 15,
                  color: _onSurfaceColor.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _outlineColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entre em contato',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _onSurfaceColor.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.email_rounded,
                          size: 16,
                          color: _primaryColor,
                        ),
                        SizedBox(width: 8),
                        SelectableText(
                          'suporte@optimusgame.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: _onSurfaceColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: _outlineColor),
                      ),
                      child: Text(
                        'Fechar',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Ação para copiar email
                        // Clipboard.setData(ClipboardData(text: 'suporte@optimusgame.com'));
                        // ScaffoldMessenger.of(context).showSnackBar(...);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Copiar email',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
