// import '/flutter_flow/flutter_flow_util.dart';
// import 'modal_valida_conta_widget.dart' show ModalValidaContaWidget;
// import 'package:flutter/material.dart';

// class ModalValidaContaModel extends FlutterFlowModel<ModalValidaContaWidget> {
//   ///  State fields for stateful widgets in this component.

//   final formKey = GlobalKey<FormState>();
//   // State field(s) for otp widget.
//   FocusNode? otpFocusNode;
//   TextEditingController? otpTextController;
//   String? Function(BuildContext, String?)? otpTextControllerValidator;
//   String? _otpTextControllerValidator(BuildContext context, String? val) {
//     if (val == null || val.isEmpty) {
//       return 'OTP is required';
//     }

//     return null;
//   }

//   @override
//   void initState(BuildContext context) {
//     otpTextControllerValidator = _otpTextControllerValidator;
//   }

//   @override
//   void dispose() {
//     otpFocusNode?.dispose();
//     otpTextController?.dispose();
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/components/modal_valida_conta_widget.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/models/responses/otp_code_response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';

class ModalValidaContaModel extends FlutterFlowModel<ModalValidaContaWidget> {

  final formKey = GlobalKey<FormState>();
  
  FocusNode? otpFocusNode;
  TextEditingController? otpTextController;
  String? Function(BuildContext, String?)? otpTextControllerValidator;
  
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );
  
  bool _isValidating = false;
  
  final UserService _userService = UserService();

  List<TextEditingController> get otpControllers => _otpControllers;
  List<FocusNode> get otpFocusNodes => _otpFocusNodes;
  bool get isValidating => _isValidating;
  
  void initState(BuildContext context) {
    otpTextControllerValidator = _otpTextControllerValidator;
    
    for (int i = 0; i < _otpControllers.length; i++) {
      _otpControllers[i].addListener(() {
        final text = _otpControllers[i].text;
        if (text.isNotEmpty && i < _otpControllers.length - 1) {
          FocusNode? nextFocus = _otpFocusNodes[i + 1];
          nextFocus.requestFocus();
        }
        if (text.isEmpty && i > 0) {
          FocusNode? previousFocus = _otpFocusNodes[i - 1];
          previousFocus.requestFocus();
        }
      });
    }
  }

  void dispose() {
    otpFocusNode?.dispose();
    otpTextController?.dispose();
    
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
  }

  String? _otpTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'OTP is required';
    }
    return null;
  }


  String getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void clearOtpFields() {
    for (final controller in _otpControllers) {
      controller.clear();
    }
    if (_otpFocusNodes.isNotEmpty) {
      _otpFocusNodes[0].requestFocus();
    }
  }

  Map<String, dynamic> validateOtpFields() {
    final otpCode = getOtpCode();
    final errors = <String>[];

    if (otpCode.isEmpty) {
      errors.add('Por favor, insira o código OTP');
    } else if (otpCode.length != 6) {
      errors.add('O código OTP deve ter exatamente 6 dígitos');
    }

    int? firstEmptyIndex;
    for (int i = 0; i < _otpControllers.length; i++) {
      if (_otpControllers[i].text.isEmpty) {
        firstEmptyIndex = i;
        break;
      }
    }

    return {
      'isValid': errors.isEmpty,
      'errors': errors,
      'otpCode': otpCode,
      'firstEmptyIndex': firstEmptyIndex,
    };
  }

  void focusOnFirstEmptyField() {
    final validationResult = validateOtpFields();
    final firstEmptyIndex = validationResult['firstEmptyIndex'] as int?;
    
    if (firstEmptyIndex != null && firstEmptyIndex < _otpFocusNodes.length) {
      _otpFocusNodes[firstEmptyIndex].requestFocus();
    } else if (_otpFocusNodes.isNotEmpty) {
      _otpFocusNodes[0].requestFocus();
    }
  }

  Future<Map<String, dynamic>> validateOtp(
    String otpCode,
    String phoneNumber,
  ) async {
    try {
      _isValidating = true;
      
      final response = await _userService.validateOtp(otpCode, phoneNumber);
      
      _isValidating = false;
      
      if (response["isSuccess"]) {
        final data = response["data"] as OtpCodeResponse;
        return {
          'success': true,
          'isValid': data.isValid,
          'data': data,
          'message': data.isValid 
              ? 'Código validado com sucesso!' 
              : 'Código OTP inválido',
        };
      }
      
      return {
        'success': false,
        'isValid': false,
        'message': 'Falha na validação do código',
      };
      
    } catch (e) {
      _isValidating = false;
      
      return {
        'success': false,
        'isValid': false,
        'message': 'Erro ao validar código: $e',
      };
    }
  }

  Future<Map<String, dynamic>> resendOtp(String phoneNumber) async {
    try {
      final formattedPhoneNumber = '+244$phoneNumber';
      await _userService.sendOtp(formattedPhoneNumber);
      
      return {
        'success': true,
        'message': 'Código reenviado com sucesso!',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro ao reenviar código: $e',
      };
    }
  }

  void autoFillOtp(String code) {
    if (code.length != 6) return;
    
    for (int i = 0; i < 6; i++) {
      if (i < _otpControllers.length) {
        _otpControllers[i].text = code[i];
      }
    }
    
    if (_otpFocusNodes.isNotEmpty) {
      _otpFocusNodes.last.requestFocus();
    }
  }

  void reset() {
    clearOtpFields();
    _isValidating = false;
  }

  bool canValidate() {
    return !_isValidating;
  }

  bool addDigitToNextEmptyField(String digit) {
    if (digit.length != 1 || !RegExp(r'^[0-9]$').hasMatch(digit)) {
      return false;
    }

    for (int i = 0; i < _otpControllers.length; i++) {
      if (_otpControllers[i].text.isEmpty) {
        _otpControllers[i].text = digit;
        
        if (i < _otpControllers.length - 1) {
          _otpFocusNodes[i + 1].requestFocus();
        }
        return true;
      }
    }
    
    return false;
  }

  void removeLastDigit() {
    for (int i = _otpControllers.length - 1; i >= 0; i--) {
      if (_otpControllers[i].text.isNotEmpty) {
        _otpControllers[i].clear();
        if (i < _otpFocusNodes.length) {
          _otpFocusNodes[i].requestFocus();
        }
        break;
      }
    }
  }
}