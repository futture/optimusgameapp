import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/dialogs/error-dialog-widget.dart';
import 'package:projeto_game_quiz/dialogs/success-dialog-widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
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

  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _backgroundColor = Color(0xFFFAFAFA);
  final Color _surfaceColor = Color(0xFFFFFFFF);
  final Color _textPrimary = Color(0xFF1F2937);
  final Color _textSecondary = Color(0xFF6B7280);
  final Color _borderColor = Color(0xFFE5E7EB);
  final Color _successColor = Color(0xFF10B981);
  final Color _errorColor = Color(0xFFEF4444);

  final LinearGradient _primaryGradient = LinearGradient(
    colors: [
      Color(0xFFEC8D0D),
      Color(0xFFF59E0B),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalValidaContaModel());
    _model.initState(context);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _validateOtp() async {
    final validationResult = _model.validateOtpFields();

    if (!validationResult['isValid']) {
      final errors = validationResult['errors'] as List<String>;
      _showErrorSnackBar(
          errors.isNotEmpty ? errors.first : 'Erro na validação');
      _model.focusOnFirstEmptyField();
      return;
    }

    final otpCode = validationResult['otpCode'] as String;

    final result = await _model.validateOtp(otpCode, widget.phoneNumber!);

    if (result['success'] == true && result['isValid'] == true) {
      await _showSuccessDialog(result['message'] as String);
    } else {
      await _showErrorDialog(result['message'] as String);
    }
  }

  Future<void> _resendOtp() async {
    if (widget.phoneNumber == null || widget.phoneNumber!.isEmpty) {
      _showErrorSnackBar('Número de telefone não disponível');
      return;
    }

    final result = await _model.resendOtp(widget.phoneNumber!);

    if (result['success'] == true) {
      _model.clearOtpFields();
      _showSuccessSnackBar(result['message'] as String);
    } else {
      _showErrorSnackBar(result['message'] as String);
    }
  }

  Future<void> _showSuccessDialog(String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(dialogContext);
          Navigator.pop(context, true);
          if (widget.onOtpValidated != null) {
            widget.onOtpValidated!();
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: SuccessDialogWidget(
            message: message,
            onOk: () {
              if (widget.onOtpValidated != null) {
                widget.onOtpValidated!();
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: ErrorDialogWidget(
            message: message,
            onOk: () {
              Navigator.pop(dialogContext);
              _model.clearOtpFields();
            },
          ),
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: _errorColor,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: _successColor,
        duration: Duration(seconds: 2),
      ),
    );
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
              _buildHeader(),

              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInstructionMessage(),

                    _buildOtpTitle(),

                    _buildOtpFields(isMobile),

                    _buildResendButton(),

                    _buildConfirmButton(),

                    _buildSecurityInfo(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
    );
  }

  Widget _buildInstructionMessage() {
    return Container(
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
    );
  }

  Widget _buildOtpTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildOtpFields(bool isMobile) {
    return Container(
      height: 72,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final spacing = 8.0;
          final maxFieldWidth = 52.0;

          double fieldWidth = (availableWidth - (5 * spacing)) / 6;
          fieldWidth = fieldWidth.clamp(40.0, maxFieldWidth);

          double actualSpacing = (availableWidth - (6 * fieldWidth)) / 5;
          actualSpacing = actualSpacing.clamp(4.0, 12.0);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return SizedBox(
                width: fieldWidth,
                height: fieldWidth,
                child: TextField(
                  controller: _model.otpControllers[index],
                  focusNode: _model.otpFocusNodes[index],
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
                    fillColor: _model.otpFocusNodes[index].hasFocus
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
                      FocusScope.of(context)
                          .requestFocus(_model.otpFocusNodes[index + 1]);
                    }
                    if (value.isEmpty && index > 0) {
                      FocusScope.of(context)
                          .requestFocus(_model.otpFocusNodes[index - 1]);
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
    );
  }

  Widget _buildResendButton() {
    return Padding(
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
            onTap: _resendOtp,
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
    );
  }

  Widget _buildConfirmButton() {
    return Container(
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
          onTap: _model.canValidate() ? _validateOtp : null,
          child: _model.isValidating
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
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
    );
  }

  Widget _buildSecurityInfo() {
    return Padding(
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
    );
  }
}
