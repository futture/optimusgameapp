import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/user_request.dart';
import 'package:projeto_game_quiz/core/models/responses/otp_code_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/dialogs/success-dialog-widget.dart';
import 'package:projeto_game_quiz/pages/password_change/password_change.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'tela11_editar_perfil_model.dart';
export 'tela11_editar_perfil_model.dart';

class Tela11EditarPerfilWidget extends StatefulWidget {
  const Tela11EditarPerfilWidget({super.key});

  static String routeName = 'Tela11EditarPerfil';
  static String routePath = '/tela11EditarPerfil';

  @override
  State<Tela11EditarPerfilWidget> createState() =>
      _Tela11EditarPerfilWidgetState();
}

class _Tela11EditarPerfilWidgetState extends State<Tela11EditarPerfilWidget>
    with SingleTickerProviderStateMixin {
  late Tela11EditarPerfilModel _model;
  UserResponse? user;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> userData = {
    'name': 'Carregando...',
    'email': '',
    'phone': '',
    'birthDate': 'N/A',
    'twoFactorEnabled': false,
    'lastPasswordChange': 'N/A'
  };

  // Cores do tema premium com laranja como primária
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _primaryDark = Color(0xFFD17A0A);
  final Color _primaryLight = Color(0xFFFFA726);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);
  final Color _errorColor = Color(0xFFEF4444);
  final Color _successColor = Color(0xFF10B981);

  // Gradientes premium
  final LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela11EditarPerfilModel());

    // Configuração das animações
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

    _model.textController1 ??=
        TextEditingController(text: 'https://picsum.photos/seed/55/600');
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    getUserInfo();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _surfaceColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
          ),
        ),
      ),
    );

    try {
      final updatedData = UpdateUserRequest(
        name: _model.textController2.text,
        email: _model.textController3.text,
        phone_number: _model.textController4.text,
      );
      print(updatedData);
      final result =
          await UserService().updateUser(userData['id'], updatedData);
      Navigator.pop(context);

      if (result['isSuccess']) {
        final updatedUser = await UserUtil.getUserInfo();
        setState(() {
          userData = {
            'id': updatedUser!.id,
            'name': updatedUser.name,
            'email': updatedUser.email,
            'phone': updatedUser.phone_number,
            'birthDate': 'N/A',
            'twoFactorEnabled': userData['twoFactorEnabled'] ?? false,
          };
        });
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => SuccessDialogWidget(
            message: 'Perfil atualizado com sucesso!',
            onOk: () {
              Navigator.pop(context);
              Future.delayed(Duration(seconds: 3), () {
                if (mounted) {
                  context.pop();
                }
              });
            },
          ),
        );
      } else {
        _showSnackBar(
            'Erro ao atualizar perfil: ${result['error']}', _errorColor);
      }
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar('Ocorreu um erro ao salvar as alterações', _errorColor);
      print("Erro ao salvar alterações: $e");
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

  Future<void> getUserInfo() async {
    try {
      final UserResponse? user = await UserUtil.getUserInfo();
      if (user != null) {
        setState(() {
          userData = {
            'id': user.id,
            'name': user.name,
            'email': user.email,
            'phone': user.phone_number,
            'birthDate': 'N/A',
            'twoFactorEnabled': false,
            'lastPasswordChange': 'N/A',
          };
        });
        _model.textController2 = TextEditingController(text: userData['name']);
        _model.textController3 = TextEditingController(text: userData['email']);
        _model.textController4 = TextEditingController(text: userData['phone']);
      }
    } catch (e) {
      print("Erro ao carregar usuário: $e");
    }
  }

  Future<void> _verifyPhoneNumber(String newPhone) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _surfaceColor,
        surfaceTintColor: _surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verificar Número',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: _primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Enviaremos um código OTP para $newPhone',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: _onSurfaceColor.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      foregroundColor: _onSurfaceColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FFButtonWidget(
                      onPressed: () => Navigator.pop(context, true),
                      text: 'Enviar Código',
                      options: FFButtonOptions(
                        height: 44,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                        color: _primaryColor,
                        textStyle: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        borderRadius: BorderRadius.circular(12),
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

    if (confirmed == true) {
      final phoneNumber = '+244${newPhone.replaceAll(RegExp(r'[^\d+]'), '')}';

      bool sendSuccess = false;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: _surfaceColor,
            surfaceTintColor: _surfaceColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: FutureBuilder(
              future: UserService().sendOtp(phoneNumber),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      _primaryColor),
                                )
                              : snapshot.hasError
                                  ? Icon(
                                      Icons.error_outline_rounded,
                                      color: _errorColor,
                                      size: 24,
                                    )
                                  : Icon(
                                      Icons.check_circle_rounded,
                                      color: _successColor,
                                      size: 24,
                                    ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        snapshot.connectionState == ConnectionState.waiting
                            ? 'Enviando código para $phoneNumber...'
                            : snapshot.hasError
                                ? 'Falha ao enviar código'
                                : 'Código enviado com sucesso!',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: _onSurfaceColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (snapshot.hasError) ...[
                        SizedBox(height: 8),
                        Text(
                          'Tente novamente mais tarde',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: _onSurfaceColor.withOpacity(0.6),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      SizedBox(height: 24),
                      if (snapshot.connectionState == ConnectionState.done)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: (snapshot.hasError
                                        ? _errorColor
                                        : _successColor)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: FFButtonWidget(
                            onPressed: () {
                              if (snapshot.hasError) {
                                Navigator.pop(context);
                                _showSnackBar(
                                    'Falha ao enviar OTP: ${snapshot.error}',
                                    _errorColor);
                              } else {
                                sendSuccess = true;
                                Navigator.pop(context);
                              }
                            },
                            text: snapshot.hasError
                                ? 'Tentar Novamente'
                                : 'Continuar',
                            options: FFButtonOptions(
                              height: 44,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24, 0, 24, 0),
                              color: snapshot.hasError
                                  ? _errorColor
                                  : _successColor,
                              textStyle: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );

      if (sendSuccess) {
        final otpVerified = await _showOtpDialog(phoneNumber);

        if (otpVerified == true) {
          setState(() {
            userData['phone'] = newPhone;
            _model.textController4.text = newPhone;
          });
          _showSnackBar('Número atualizado com sucesso!', _successColor);
        }
      }
    }
  }

  Future<bool> _showOtpDialog(String phone) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => OtpVerificationDialog(phoneNumber: phone),
        ) ??
        false;
  }

  Future<void> _showEditDialog(String field, String currentValue) async {
    final controller = TextEditingController(text: currentValue);

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _surfaceColor,
        surfaceTintColor: _surfaceColor,
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 300,
            maxWidth: 500,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Editar $field',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: _primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: _onSurfaceColor, // CORRIGIDO: Definir cor do texto
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: field,
                    labelStyle: TextStyle(
                      fontFamily: 'Inter',
                      color: _onSurfaceColor.withOpacity(0.6),
                    ),
                    hintText: 'Digite o novo $field',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      color: _onSurfaceColor.withOpacity(0.4),
                    ),
                    filled: true,
                    fillColor: _surfaceColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _outlineColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _primaryColor, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _outlineColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  autofocus: true,
                  keyboardType: field == 'Email'
                      ? TextInputType.emailAddress
                      : field == 'Telefone'
                          ? TextInputType.phone
                          : TextInputType.text,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: _onSurfaceColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: FFButtonWidget(
                        onPressed: () {
                          if (controller.text.trim().isEmpty) {
                            _showSnackBar('Por favor, insira um valor válido',
                                _errorColor);
                            return;
                          }
                          Navigator.pop(context, {
                            'field': field,
                            'value': controller.text.trim(),
                          });
                        },
                        text: 'Salvar',
                        options: FFButtonOptions(
                          height: 44,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24, 0, 24, 0),
                          color: _primaryColor,
                          textStyle: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((result) async {
      if (result != null && result['value'] != currentValue) {
        if (field == 'Telefone') {
          await _verifyPhoneNumber(result['value']!);
        } else {
          setState(() {
            userData[field.toLowerCase()] = result['value'];
            switch (field) {
              case 'Nome':
                _model.textController2.text = result['value']!;
                break;
              case 'Email':
                _model.textController3.text = result['value']!;
                break;
            }
          });
        }
      }
    });
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
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
                                'Editar Perfil',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            // Ícone de perfil
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        // Barra de progresso sutil
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
                    child: Column(
                      children: [
                        // Seção de Foto de Perfil
                        _buildProfileSection(context),

                        SizedBox(height: 32.0),

                        // Seção de Informações Pessoais
                        _buildPersonalInfoSection(context),

                        SizedBox(height: 24.0),

                        // Seção de Segurança
                        _buildSecuritySection(context),

                        SizedBox(height: 24.0),

                        // Botão de Logout
                        _buildLogoutButton(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _primaryColor,
                      width: 3.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.2),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.network(
                      _model.textController1.text,
                      width: 120.0,
                      height: 120.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 48.0,
                          color: _primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -5,
                  bottom: -5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () async {
                        await _showEditDialog(
                            'Foto', _model.textController1.text);
                      },
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 18.0,
                      ),
                      splashRadius: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              userData['name'] ?? 'Carregando...',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _onSurfaceColor,
              ),
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Membro Premium',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: _primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            'INFORMAÇÕES PESSOAIS',
            style: TextStyle(
              fontFamily: 'Inter',
              color: _onSurfaceColor.withOpacity(0.5),
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: 16.0),

        // Nome
        _buildEditableField(
          context,
          label: 'Nome Completo',
          value: _model.textController2.text,
          icon: Icons.person_rounded,
          onTap: () => _showEditDialog('Nome', _model.textController2.text),
        ),

        // Email
        _buildEditableField(
          context,
          label: 'Email',
          value: _model.textController3.text,
          icon: Icons.email_rounded,
          onTap: () => _showEditDialog('Email', _model.textController3.text),
        ),

        // Telefone
        _buildEditableField(
          context,
          label: 'Telefone',
          value: _model.textController4.text,
          icon: Icons.phone_rounded,
          onTap: () => _showEditDialog('Telefone', _model.textController4.text),
        ),

        // Data de Nascimento
        _buildEditableField(
          context,
          label: 'Data de Nascimento',
          value: userData['birthDate'],
          icon: Icons.calendar_today_rounded,
          onTap: () =>
              _showEditDialog('Data de Nascimento', userData['birthDate']),
        ),

        SizedBox(height: 24.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.2),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: FFButtonWidget(
            onPressed: _saveChanges,
            text: 'SALVAR ALTERAÇÕES',
            options: FFButtonOptions(
              width: double.infinity,
              height: 52.0,
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              color: _primaryColor,
              textStyle: TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
              elevation: 0,
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            'SEGURANÇA',
            style: TextStyle(
              fontFamily: 'Inter',
              color: _onSurfaceColor.withOpacity(0.5),
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: 16.0),

        // Alterar Senha
        _buildSecurityItem(
          icon: Icons.lock_rounded,
          title: 'Alterar Senha',
          subtitle: 'Última alteração: ${userData['lastPasswordChange']}',
          onTap: () {
            context.pushNamed(PasswordChangeScreen.routeName);
          },
        ),

        SizedBox(height: 12.0),

        // Autenticação de Dois Fatores
        _buildSecurityItem(
          icon: Icons.security_rounded,
          title: 'Autenticação de Dois Fatores',
          subtitle: 'Proteção adicional para sua conta',
          showSwitch: true,
          switchValue: userData['twoFactorEnabled'],
          onSwitchChanged: (value) {
            setState(() {
              userData['twoFactorEnabled'] = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSecurityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool showSwitch = false,
    bool switchValue = false,
    Function(bool)? onSwitchChanged,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.circular(16.0),
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
                  icon,
                  color: _primaryColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _onSurfaceColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: _onSurfaceColor.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (showSwitch)
                Switch(
                  value: switchValue,
                  onChanged: onSwitchChanged,
                  activeColor: _primaryColor,
                )
              else
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: _onSurfaceColor.withOpacity(0.4),
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: _surfaceColor,
                surfaceTintColor: _surfaceColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _errorColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          color: _errorColor,
                          size: 30,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Sair da Conta?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _onSurfaceColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tem certeza que deseja sair da sua conta?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _onSurfaceColor.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context, false),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _onSurfaceColor,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: _outlineColor),
                              ),
                              child: Text(
                                'Cancelar',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _errorColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Sair',
                                style: TextStyle(fontWeight: FontWeight.w700),
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

            if (confirmed == true) {
              context.pushNamed('LoginScreen');
            }
          },
          child: Container(
            width: double.infinity,
            height: 56.0,
            decoration: BoxDecoration(
              color: _errorColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: _errorColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    color: _errorColor,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'SAIR DA CONTA',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: _errorColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(16.0),
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
                    icon,
                    color: _primaryColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: _onSurfaceColor.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        value,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _onSurfaceColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.edit_rounded,
                  size: 20.0,
                  color: _onSurfaceColor.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OtpVerificationDialog extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationDialog({required this.phoneNumber});

  @override
  State<OtpVerificationDialog> createState() => _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends State<OtpVerificationDialog> {
  final List<TextEditingController> _controllers =
      List.generate(6, (i) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (i) => FocusNode());

  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);
  final Color _errorColor = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _surfaceColor,
      surfaceTintColor: _surfaceColor,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  color: _primaryColor,
                  size: 30,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Verificação de Telefone',
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Insira o código de 6 dígitos enviado para ${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _onSurfaceColor.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 24),

              // Campos OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 44,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _outlineColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: _primaryColor, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _outlineColor),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              SizedBox(height: 32),

              // Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      foregroundColor: _onSurfaceColor,
                    ),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FFButtonWidget(
                      onPressed: _verifyCode,
                      text: 'Verificar',
                      options: FFButtonOptions(
                        height: 44,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        color: _primaryColor,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
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

  Future<void> _verifyCode() async {
    final enteredCode = _controllers.map((c) => c.text).join();
    final verificationResult =
        await UserService().validateOtp(enteredCode, widget.phoneNumber);
    print(verificationResult["isSuccess"]);
    if ((verificationResult["isSuccess"])) {
      OtpCodeResponse data = verificationResult["data"] as OtpCodeResponse;
      if (enteredCode == data.code) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline_rounded,
                    color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Código inválido!'),
              ],
            ),
            backgroundColor: _errorColor,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Código incorreto. Tente novamente.'),
            ],
          ),
          backgroundColor: _errorColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}

class PhoneVerificationDialog extends StatefulWidget {
  final String phoneNumber;

  const PhoneVerificationDialog({required this.phoneNumber});

  @override
  _PhoneVerificationDialogState createState() =>
      _PhoneVerificationDialogState();
}

class _PhoneVerificationDialogState extends State<PhoneVerificationDialog> {
  final List<TextEditingController> _controllers =
      List.generate(6, (i) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (i) => FocusNode());
  final String _correctCode = '123456';

  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);
  final Color _errorColor = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _surfaceColor,
      surfaceTintColor: _surfaceColor,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.phone_iphone_rounded,
                  color: _primaryColor,
                  size: 30,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Verificação de Telefone',
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Insira o código de 6 dígitos enviado para ${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _onSurfaceColor.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 24),

              // Campos OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 44,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _outlineColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: _primaryColor, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _outlineColor),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              SizedBox(height: 32),

              // Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      foregroundColor: _onSurfaceColor,
                    ),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FFButtonWidget(
                      onPressed: _verifyCode,
                      text: 'Verificar',
                      options: FFButtonOptions(
                        height: 44,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        color: _primaryColor,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
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

  void _verifyCode() {
    final enteredCode = _controllers.map((c) => c.text).join();
    if (enteredCode == _correctCode) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Código incorreto. Tente novamente.'),
            ],
          ),
          backgroundColor: _errorColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);

  CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _surfaceColor,
      surfaceTintColor: _surfaceColor,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_rounded,
                  color: _primaryColor,
                  size: 30,
                ),
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              content,
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions.map((action) {
                  if (action is TextButton) {
                    return TextButton(
                      onPressed: action.onPressed,
                      style: TextButton.styleFrom(
                        foregroundColor: _onSurfaceColor,
                      ),
                      child: action.child != null
                          ? Text(
                              (action.child as Text).data ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Container(),
                    );
                  }

                  if (action is FFButtonWidget) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: FFButtonWidget(
                        onPressed: action.onPressed,
                        text: action.text,
                        options: FFButtonOptions(
                          height: 44,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24, 0, 24, 0),
                          color: _primaryColor,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  }

                  return action;
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
