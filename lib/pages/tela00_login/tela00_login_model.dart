import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';

class Tela00LoginModel extends FlutterFlowModel<Tela00LoginWidget> {
  ///  State fields for stateful widgets in this page.
  UserService userService = UserService();

  final formKey = GlobalKey<FormState>();
  bool isLoggingIn = false;

  // Login fields (already exist)
  FocusNode? inputEmailFocusNode;
  TextEditingController? inputEmailTextController;
  String? Function(BuildContext, String?)? inputEmailTextControllerValidator;

  // State field(s) for inputSenha widget.
  FocusNode? inputSenhaFocusNode;
  TextEditingController? inputSenhaTextController;
  late bool inputSenhaVisibility;
  String? Function(BuildContext, String?)? inputSenhaTextControllerValidator;

  // State field(s) for Checkbox widget.
  bool? checkboxValue;

  // ------------------------------------------------------------------
  // PASSWORD RECOVERY FIELDS (ADD THESE)
  // ------------------------------------------------------------------

  // Email recovery fields
  TextEditingController? _emailRecoveryController;
  FocusNode? _emailRecoveryFocusNode;

  // Phone recovery fields
  TextEditingController? _phoneRecoveryController;
  FocusNode? _phoneRecoveryFocusNode;

  // Password recovery state
  bool _isRecoveryEmailSelected = true;
  bool _isSendingRecoveryCode = false;

  // ------------------------------------------------------------------
  // VALIDATORS (ADD THESE)
  // ------------------------------------------------------------------

  String? _inputEmailTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'is required';
    }
    return null;
  }

  String? _inputSenhaTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Januario Pinto is required';
    }
    return null;
  }

  // ------------------------------------------------------------------
  // INITIALIZATION (UPDATE initState)
  // ------------------------------------------------------------------

  @override
  void initState(BuildContext context) {
    inputEmailTextControllerValidator = _inputEmailTextControllerValidator;
    inputSenhaVisibility = false;
    inputSenhaTextControllerValidator = _inputSenhaTextControllerValidator;

    // Initialize password recovery controllers
    _emailRecoveryController = TextEditingController();
    _emailRecoveryFocusNode = FocusNode();
    _phoneRecoveryController = TextEditingController();
    _phoneRecoveryFocusNode = FocusNode();
  }

  // ------------------------------------------------------------------
  // DISPOSAL (UPDATE dispose)
  // ------------------------------------------------------------------

  @override
  void dispose() {
    // Dispose login fields
    inputEmailFocusNode?.dispose();
    inputEmailTextController?.dispose();
    inputSenhaFocusNode?.dispose();
    inputSenhaTextController?.dispose();

    // Dispose password recovery fields
    _emailRecoveryController?.dispose();
    _emailRecoveryFocusNode?.dispose();
    _phoneRecoveryController?.dispose();
    _phoneRecoveryFocusNode?.dispose();
  }

  // ------------------------------------------------------------------
  // PASSWORD RECOVERY METHODS (ADD THESE)
  // ------------------------------------------------------------------

  // Getters for the password recovery fields
  TextEditingController get emailRecoveryController =>
      _emailRecoveryController!;
  FocusNode get emailRecoveryFocusNode => _emailRecoveryFocusNode!;
  TextEditingController get phoneRecoveryController =>
      _phoneRecoveryController!;
  FocusNode get phoneRecoveryFocusNode => _phoneRecoveryFocusNode!;

  // Getter for recovery method selection
  bool get isRecoveryEmailSelected => _isRecoveryEmailSelected;

  // Method to toggle recovery method
  void toggleRecoveryMethod(Function setState) {
    setState(() {
      _isRecoveryEmailSelected = !_isRecoveryEmailSelected;
    });
  }

  // Method to set recovery method
  void setRecoveryMethod(Function setState, bool isEmailSelected) {
    setState(() {
      _isRecoveryEmailSelected = isEmailSelected;
    });
  }

  // Getter for sending state
  bool get isSendingRecoveryCode => _isSendingRecoveryCode;

  // Method to set sending state
  void setSendingRecoveryCode(Function setState, bool isSending) {
    setState(() {
      _isSendingRecoveryCode = isSending;
    });
  }

  // Method to validate recovery input
  String? validateRecoveryInput(BuildContext context) {
    if (_isRecoveryEmailSelected) {
      final email = _emailRecoveryController?.text ?? '';
      if (email.isEmpty) {
        return 'Please enter your email';
      }
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        return 'Please enter a valid email';
      }
    } else {
      final phone = _phoneRecoveryController?.text ?? '';
      if (phone.isEmpty) {
        return 'Please enter your phone number';
      }
      final phoneDigits = phone.replaceAll(RegExp(r'[^\d]'), '');
      if (phoneDigits.length < 10) {
        return 'Please enter a valid phone number';
      }
    }
    return null;
  }

  // Method to clear recovery fields
  void clearRecoveryFields() {
    _emailRecoveryController?.clear();
    _phoneRecoveryController?.clear();
  }

  // ------------------------------------------------------------------
  // PASSWORD RECOVERY API METHODS (ADD THESE)
  // ------------------------------------------------------------------

  Future<Map<String, dynamic>> sendEmailRecoveryCode() async {
    final email = _emailRecoveryController?.text.trim() ?? '';

    if (email.isEmpty) {
      return {
        'success': false,
        'message': 'Informe um email válido',
      };
    }

    try {
      final response = await userService.requestPasswordReset(email);

      if (response != null && response['isSuccess'] == true) {
        return {
          'success': true,
          'message': response['message'] ?? 'Email enviado com sucesso',
        };
      }

      return {
        'success': false,
        'message': response?['message'] ?? 'Erro ao enviar email',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de comunicação com o servidor',
      };
    }
  }

  Future<Map<String, dynamic>> sendSMSRecoveryCode() async {
    final phone = _phoneRecoveryController?.text ?? '';
    // Here you would call your API to send SMS recovery code
    // For now, returning a simulated response
    await Future.delayed(Duration(seconds: 2));
    return {'success': true, 'message': 'Verification code sent to your phone'};
  }

  // ------------------------------------------------------------------
  // EXISTING LOGIN METHOD (KEEP AS IS)
  // ------------------------------------------------------------------

  Future<void> signInAsync(Function setState) async {
    setState(() {
      isLoggingIn = true;
    });
    final email = inputEmailTextController!.text;
    final password = inputSenhaTextController!.text;
    if (email.isEmpty) {
      setState(() {
        isLoggingIn = false;
      });
      Warning00ErrorUtil.showDialogMessageError(
          context, "Falha ao efetuar o login", "Preencha o campo email");
      return;
    }
    if (password.isEmpty) {
      setState(() {
        isLoggingIn = false;
      });
      Warning00ErrorUtil.showDialogMessageError(
          context, "Falha ao efetuar o login", "Preencha o campo senha");
      return;
    }
    final resultToken = await userService.loginUser(email, password);
    if (resultToken["isSuccess"]) {
      setState(() {
        isLoggingIn = false;
      });
      await Future.delayed(Duration(seconds: 1));
      context!.pushNamed(Tela03PrincipalWidget.routeName);
    } else {
      setState(() {
        isLoggingIn = false;
      });
      Warning00ErrorUtil.showDialogMessageError(
          context,
          resultToken["error"].detail.message,
          resultToken["error"].detail.details);
      return;
    }
  }
}
