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

class _Tela11EditarPerfilWidgetState extends State<Tela11EditarPerfilWidget> {
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela11EditarPerfilModel());

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
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(color: Color(0xFFEC8D0D)),
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
            'birthDate': 'N/A', //userData['birthDate'],
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar perfil: ${result['error']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocorreu um erro ao salvar as alterações'),
          backgroundColor: Colors.red,
        ),
      );
      print("Erro ao salvar alterações: $e");
    }
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
      builder: (context) => CustomDialog(
        title: 'Verificar Número',
        content: Text('Enviaremos um código OTP para $newPhone'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          const SizedBox(width: 8),
          FFButtonWidget(
            onPressed: () => Navigator.pop(context, true),
            text: 'Enviar Código',
            options: FFButtonOptions(
              height: 40,
              padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final phoneNumber = '+244${newPhone.replaceAll(RegExp(r'[^\d+]'), '')}';

      // Mostra loading durante o envio
      bool sendSuccess = false;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return FutureBuilder(
            future: UserService().sendOtp(phoneNumber),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pop(context); // Fecha o loading
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Falha ao enviar OTP: ${snapshot.error}')),
                    );
                  });
                  return const SizedBox(); // Retorna widget vazio
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  sendSuccess = true;
                  Navigator.pop(context); // Fecha o loading
                });
              }

              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Enviando código para $phoneNumber...'),
                  ],
                ),
              );
            },
          );
        },
      );

      // Só mostra o OTP dialog se o envio foi bem-sucedido
      if (sendSuccess) {
        final otpVerified = await _showOtpDialog(phoneNumber);

        if (otpVerified == true) {
          setState(() {
            userData['phone'] = newPhone;
            _model.textController4.text = newPhone;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Número atualizado com sucesso!')),
          );
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
        insetPadding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 300,
            maxWidth: 500,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Editar $field',
                  style: TextStyle(
                    color: Color(0xFFEC8D0D), // Cor laranja para o título
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: field,
                    labelStyle: TextStyle(
                      color: Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFEC8D0D)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFEC8D0D), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFEC8D0D)),
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

                // Ações do dialog com botões estilizados
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Color(0xFFEC8D0D), // Texto laranja
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Botão Salvar com fundo laranja e texto branco
                    FFButtonWidget(
                      onPressed: () {
                        if (controller.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Por favor, insira um valor válido')),
                          );
                          return;
                        }
                        Navigator.pop(context, {
                          'field': field,
                          'value': controller.text.trim(),
                        });
                      },
                      text: 'Salvar',
                      options: FFButtonOptions(
                        height: 40,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        color: Color(0xFFEC8D0D), // Fundo laranja
                        textStyle: TextStyle(
                          color: Colors.white, // Texto branco no botão
                          fontWeight: FontWeight.bold,
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
          /*ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$field atualizado, sal!')),
          );*/
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userData.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
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
              fillColor: FlutterFlowTheme.of(context).primaryBackground,
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
            'EDITAR PERFIL',
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
          child: SingleChildScrollView(
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
                child: Padding(
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
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return SizedBox(
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
                constraints: BoxConstraints(
                  minWidth: 120.0,
                  maxWidth: 120.0,
                  minHeight: 120.0,
                  maxHeight: 120.0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    width: 2.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60.0),
                  child: Image.network(
                    _model.textController1.text,
                    width: 120.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.person,
                      size: 60.0,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -5,
                bottom: -5,
                child: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 20.0,
                  borderWidth: 1.0,
                  buttonSize: 40.0,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  icon: Icon(
                    Icons.camera_alt,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 20.0,
                  ),
                  onPressed: () async {
                    await _showEditDialog('Foto', _model.textController1.text);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Text(
            userData['name'] ?? 'Carregando...',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: 'Inter Tight',
                  letterSpacing: 0.0,
                ),
          ),
          Text(
            'Premium Member',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: Color(0xFFEC8D0D),
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INFORMAÇÕES PESSOAIS',
          style: FlutterFlowTheme.of(context).labelMedium.override(
                fontFamily: 'Inter',
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),
        SizedBox(height: 12.0),

        // Nome
        _buildEditableField(
          context,
          label: 'Nome Completo',
          value: _model.textController2.text,
          icon: Icons.person,
          onTap: () => _showEditDialog('Nome', _model.textController2.text),
        ),

        // Email
        _buildEditableField(
          context,
          label: 'Email',
          value: _model.textController3.text,
          icon: Icons.email,
          onTap: () => _showEditDialog('Email', _model.textController3.text),
        ),

        // Telefone
        _buildEditableField(
          context,
          label: 'Telefone',
          value: _model.textController4.text,
          icon: Icons.phone,
          onTap: () => _showEditDialog('Telefone', _model.textController4.text),
        ),

        // Data de Nascimento
        _buildEditableField(
          context,
          label: 'Data de Nascimento',
          value: userData['birthDate'],
          icon: Icons.calendar_today,
          onTap: () =>
              _showEditDialog('Data de Nascimento', userData['birthDate']),
        ),

        SizedBox(height: 16.0),
        FFButtonWidget(
          onPressed: _saveChanges,
          text: 'SALVAR ALTERAÇÕES',
          options: FFButtonOptions(
            width: double.infinity,
            height: 45.0,
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: Color(0xFFEC8D0D),
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: 'Inter Tight',
                  color: Colors.black,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                ),
            elevation: 0.0,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SEGURANÇA',
          style: FlutterFlowTheme.of(context).labelMedium.override(
                fontFamily: 'Inter',
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),
        SizedBox(height: 12.0),

        // Alterar Senha
        InkWell(
          onTap: () {
            context.pushNamed(PasswordChangeScreen.routeName);
          },
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(
                  Icons.lock,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alterar Senha',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                      ),
                      Text(
                        'Última alteração: ${userData['lastPasswordChange']}',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 8.0),
        InkWell(
          onTap: () {
            setState(() {
              userData['twoFactorEnabled'] = !userData['twoFactorEnabled'];
            });
          },
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(
                  Icons.security,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    'Autenticação de Dois Fatores',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                Switch(
                  value: userData['twoFactorEnabled'],
                  onChanged: (value) {
                    setState(() {
                      userData['twoFactorEnabled'] = value;
                    });
                  },
                  activeColor: Color(0xFFEC8D0D),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
      child: FFButtonWidget(
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Confirmar Saída'),
              content: Text('Tem certeza que deseja sair da sua conta?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Sair'),
                ),
              ],
            ),
          );

          if (confirmed == true) {
            context.pushNamed('LoginScreen');
          }
        },
        text: 'SAIR DA CONTA',
        options: FFButtonOptions(
          width: double.infinity,
          height: 45.0,
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: FlutterFlowTheme.of(context).error,
          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                fontFamily: 'Inter Tight',
                color: Colors.white,
                fontSize: 14.0,
                letterSpacing: 0.0,
              ),
          elevation: 0.0,
          borderRadius: BorderRadius.circular(8.0),
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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 60.0,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                      ),
                ),
                SizedBox(height: 4.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 20.0,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        value,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                    Icon(
                      Icons.edit,
                      size: 18.0,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ],
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

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 300,
        maxWidth: 500,
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Verificação de Telefone',
              style: FlutterFlowTheme.of(context).headlineSmall,
            ),
            SizedBox(height: 16),
            Text(
                'Insira o código de 6 dígitos enviado para ${widget.phoneNumber}'),
            SizedBox(height: 20),

            // Campos OTP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 40,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
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
            SizedBox(height: 20),

            // Botões
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancelar'),
                ),
                SizedBox(width: 8),
                FFButtonWidget(
                  onPressed: _verifyCode,
                  text: 'Verificar',
                  options: FFButtonOptions(
                    height: 40,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  ),
                ),
              ],
            ),
          ],
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
        SnackBar(content: Text('Código incorreto. Tente novamente.')),
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

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título com cor laranja
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFFEC8D0D), // Cor laranja no título
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              content,
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions.map((action) {
                  // Se for um TextButton, aplicamos a cor laranja no texto
                  if (action is TextButton) {
                    return TextButton(
                      onPressed: action.onPressed,
                      child: action.child != null
                          ? Text(
                              (action.child as Text).data ??
                                  '', // Acessa o texto do TextButton
                              style: TextStyle(
                                color: Color(0xFFEC8D0D), // Texto laranja
                              ),
                            )
                          : Container(), // Caso não haja texto no botão
                    );
                  }

                  // Se for o FFButtonWidget, aplicamos a cor laranja no fundo e no texto
                  if (action is FFButtonWidget) {
                    return FFButtonWidget(
                      onPressed: action.onPressed,
                      text: action.text,
                      options: FFButtonOptions(
                        height: 40,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        color: Color(0xFFEC8D0D), // Cor de fundo laranja
                        textStyle: TextStyle(
                          color: Colors.white, // Texto branco no botão
                          fontWeight: FontWeight.bold,
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

class _OtpVerificationDialogState extends State<OtpVerificationDialog> {
  final List<TextEditingController> _controllers =
      List.generate(6, (i) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (i) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Verificação de Telefone',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'Insira o código de 6 dígitos enviado para ${widget.phoneNumber}'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 40,
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  decoration: const InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(),
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
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 8),
        FFButtonWidget(
          onPressed: _verifyCode,
          text: 'Verificar',
          options: FFButtonOptions(
            height: 40,
            padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
          ),
        ),
      ],
    );
  }

  Future<void> _verifyCode() async {
    final enteredCode = _controllers.map((c) => c.text).join();
    final verificationResult = await UserService().validateOtp(enteredCode);
    print(verificationResult["isSuccess"]);
    if ((verificationResult["isSuccess"])) {
      OtpCodeResponse data = verificationResult["data"] as OtpCodeResponse;
      if (enteredCode == data.code) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código invalido!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código incorreto. Tente novamente.')),
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
