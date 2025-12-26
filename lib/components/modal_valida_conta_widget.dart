import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/models/responses/otp_code_response.dart';
import 'package:projeto_game_quiz/dialogs/error-dialog-widget.dart';
import 'package:projeto_game_quiz/dialogs/success-dialog-widget.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'modal_valida_conta_model.dart';
export 'modal_valida_conta_model.dart';

class ModalValidaContaWidget extends StatefulWidget {
  const ModalValidaContaWidget({
    super.key,
    this.phoneNumber,
    this.onOtpValidated,
  });

  final String? phoneNumber;
  final VoidCallback? onOtpValidated;

  @override
  State<ModalValidaContaWidget> createState() => _ModalValidaContaWidgetState();
}

class _ModalValidaContaWidgetState extends State<ModalValidaContaWidget> {
  late ModalValidaContaModel _model;

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

  // Controladores para os 6 campos OTP
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );

  bool _isValidating = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalValidaContaModel());

    // Configura listeners para navegação automática
    for (int i = 0; i < _otpControllers.length; i++) {
      _otpControllers[i].addListener(() {
        final text = _otpControllers[i].text;
        if (text.isNotEmpty && i < _otpControllers.length - 1) {
          FocusScope.of(context).requestFocus(_otpFocusNodes[i + 1]);
        }
        if (text.isEmpty && i > 0) {
          FocusScope.of(context).requestFocus(_otpFocusNodes[i - 1]);
        }
      });
    }
  }

  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _clearOtpFields() {
    for (final controller in _otpControllers) {
      controller.clear();
    }
    FocusScope.of(context).requestFocus(_otpFocusNodes[0]);
  }

  Future<void> _validateOtp() async {
    final otp = _getOtpCode();

    // Verifica se todos os 6 dígitos foram preenchidos
    if (otp.length != 6) {
      // CORREÇÃO: Usar um simples SnackBar em vez de showGeneralDialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, insira todos os 6 dígitos do código',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: _errorColor,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // Foca no primeiro campo vazio
      for (int i = 0; i < _otpControllers.length; i++) {
        if (_otpControllers[i].text.isEmpty) {
          FocusScope.of(context).requestFocus(_otpFocusNodes[i]);
          break;
        }
      }
      return;
    }

    setState(() {
      _isValidating = true;
    });

    try {
      final response =
          await UserService().validateOtp(otp, widget.phoneNumber!);

      if (response["isSuccess"]) {
        OtpCodeResponse data = response["data"] as OtpCodeResponse;
        if (data.isValid) {
          // Sucesso - mostra mensagem e fecha automaticamente
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pop(dialogContext); // Fecha o diálogo de sucesso
                Navigator.pop(context, true); // Fecha o modal OTP
                // Chama callback se fornecido
                if (widget.onOtpValidated != null) {
                  widget.onOtpValidated!();
                }
              });

              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: SuccessDialogWidget(
                  message: 'Código validado com sucesso!',
                  onOk: () {},
                ),
              );
            },
          );
          return;
        }
      }

      // Se chegou aqui, é porque falhou na validação da API
      // CORREÇÃO: Usar showDialog em vez de showGeneralDialog para não fechar o modal
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: ErrorDialogWidget(
              message: 'Código OTP inválido. Tente novamente.',
              onOk: () {
                Navigator.pop(dialogContext); // Fecha apenas o diálogo de erro
                _clearOtpFields(); // Limpa os campos para nova tentativa
              },
            ),
          );
        },
      );
    } catch (e) {
      // CORREÇÃO: Usar showDialog para erros também
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: ErrorDialogWidget(
              message: 'Erro ao validar código. Verifique sua conexão.',
              onOk: () => Navigator.pop(
                  dialogContext), // Fecha apenas o diálogo de erro
            ),
          );
        },
      );
    } finally {
      setState(() {
        _isValidating = false;
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isMobile = mediaQuery.size.width < 768;

    return Align(
      alignment: AlignmentDirectional.center,
      child: Container(
        width: isMobile ? mediaQuery.size.width * 0.9 : 450,
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: mediaQuery.size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: Offset(0, 15),
              spreadRadius: -5,
            ),
          ],
          border: Border.all(
            color: _borderColor.withOpacity(0.6),
            width: 1.5,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header do modal
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: _borderColor.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
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
                        child: FaIcon(
                          FontAwesomeIcons.checkCircle,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verificação de Segurança',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Confirme seu número de telefone',
                              style: TextStyle(
                                fontSize: 13,
                                color: _textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _surfaceColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _borderColor,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: _textSecondary,
                          ),
                          onPressed: () async {
                            context.safePop();
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Conteúdo do modal
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mensagem de instrução
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _primaryColor.withOpacity(0.1),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.sms_rounded,
                                color: _primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Insira o código que recebeu no seu contacto telefônico',
                              style: TextStyle(
                                fontSize: 14,
                                color: _textSecondary,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Título dos campos OTP
                    Text(
                      'Código de Verificação',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),

                    Text(
                      'Digite o código de 6 dígitos recebido por SMS',
                      style: TextStyle(
                        fontSize: 14,
                        color: _textSecondary,
                      ),
                    ),
                    SizedBox(height: 24),

                    // Campos OTP com quadrados - CORREÇÃO DO OVERFLOW
                    Container(
                      height: 72,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Calcula o tamanho dinâmico baseado na largura disponível
                          final availableWidth = constraints.maxWidth;
                          final spacing =
                              8.0; // Espaçamento mínimo entre os campos
                          final maxFieldWidth = 52.0;

                          // Calcula o tamanho ideal para os campos
                          double fieldWidth =
                              (availableWidth - (5 * spacing)) / 6;
                          fieldWidth = fieldWidth.clamp(40.0, maxFieldWidth);

                          // Se for muito pequeno, reduzimos o espaçamento
                          double actualSpacing =
                              (availableWidth - (6 * fieldWidth)) / 5;
                          actualSpacing = actualSpacing.clamp(4.0, 12.0);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (index) {
                              return SizedBox(
                                width: fieldWidth,
                                height: fieldWidth,
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _otpFocusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: TextStyle(
                                    fontSize: fieldWidth > 45 ? 22 : 20,
                                    fontWeight: FontWeight.w700,
                                    color: _textPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    filled: true,
                                    fillColor: _otpFocusNodes[index].hasFocus
                                        ? Colors.white
                                        : _backgroundColor,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: _borderColor,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: _primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: _borderColor,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < 5) {
                                      FocusScope.of(context).requestFocus(
                                          _otpFocusNodes[index + 1]);
                                    }
                                    if (value.isEmpty && index > 0) {
                                      FocusScope.of(context).requestFocus(
                                          _otpFocusNodes[index - 1]);
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),

                    // Botão de reenviar
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Não recebeu o código? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: _textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: Implementar reenvio do OTP
                              print('Reenviar OTP pressionado');
                              _clearOtpFields();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Código reenviado com sucesso!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: _successColor,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Text(
                              'Reenviar código',
                              style: TextStyle(
                                fontSize: 14,
                                color: _primaryColor,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Botão de confirmação
                    Container(
                      height: 56,
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
                          onTap: _isValidating ? null : _validateOtp,
                          child: _isValidating
                              ? Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Validando...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    'CONFIRMAR E CONTINUAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),

                    // Informações de segurança
                    Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _borderColor.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.security_rounded,
                              size: 16,
                              color: _successColor,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Este código expira em 10 minutos. Mantenha-o em segurança.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _textSecondary,
                                ),
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
    );
  }
}
