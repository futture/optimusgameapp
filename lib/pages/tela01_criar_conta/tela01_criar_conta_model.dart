import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/models/requests/user_request.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';
import 'package:projeto_game_quiz/pages/tela06_salade_jogo/tela06_salade_jogo_widget.dart';

class Tela01CriarContaModel extends FlutterFlowModel<Tela06SaladeJogoWidget> {
  final formKey = GlobalKey<FormState>();
  
  FocusNode? inputMomeCompletoFocusNode;
  TextEditingController? inputMomeCompletoTextController;
  String? Function(BuildContext, String?)? inputMomeCompletoTextControllerValidator;
  
  FocusNode? inputTelefoneFocusNode;
  TextEditingController? inputTelefoneTextController;
  String? Function(BuildContext, String?)? inputTelefoneTextControllerValidator;
  
  FocusNode? inputEmailFocusNode;
  TextEditingController? inputEmailTextController;
  String? Function(BuildContext, String?)? inputEmailTextControllerValidator;
  
  FocusNode? inputSenhaFocusNode1;
  TextEditingController? inputSenhaTextController1;
  late bool inputSenhaVisibility1;
  String? Function(BuildContext, String?)? inputSenhaTextController1Validator;
  
  FocusNode? inputSenhaFocusNode2;
  TextEditingController? inputSenhaTextController2;
  late bool inputSenhaVisibility2;
  String? Function(BuildContext, String?)? inputSenhaTextController2Validator;
  
  bool? checkboxValue;

  bool _isRegistering = false;
  bool _isSendingOtp = false;
  
  bool get isRegistering => _isRegistering;
  bool get isSendingOtp => _isSendingOtp;
  
  set isRegistering(bool value) => _isRegistering = value;
  
  final UserService _userService = UserService();

  void initState(BuildContext context) {
    inputSenhaVisibility1 = false;
    inputSenhaVisibility2 = false;
  }

  void dispose() {
    inputMomeCompletoFocusNode?.dispose();
    inputMomeCompletoTextController?.dispose();

    inputTelefoneFocusNode?.dispose();
    inputTelefoneTextController?.dispose();

    inputEmailFocusNode?.dispose();
    inputEmailTextController?.dispose();

    inputSenhaFocusNode1?.dispose();
    inputSenhaTextController1?.dispose();

    inputSenhaFocusNode2?.dispose();
    inputSenhaTextController2?.dispose();
  }
  void initializeValidators() {
    inputMomeCompletoTextControllerValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, insira seu nome completo';
      }
      if (value.trim().split(' ').length < 2) {
        return 'Por favor, insira seu nome completo (nome e sobrenome)';
      }
      return null;
    };

    inputTelefoneTextControllerValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, insira seu número de telefone';
      }
      final phoneDigits = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (phoneDigits.length < 9) {
        return 'Por favor, insira um número de telefone válido (mínimo 9 dígitos)';
      }
      return null;
    };

    inputEmailTextControllerValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, insira seu email';
      }
      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(value.trim())) {
        return 'Por favor, insira um email válido';
      }
      return null;
    };

    inputSenhaTextController1Validator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, insira uma senha';
      }
      if (value.length < 6) {
        return 'A senha deve ter pelo menos 6 caracteres';
      }
      return null;
    };

    inputSenhaTextController2Validator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Por favor, confirme sua senha';
      }
      if (value != inputSenhaTextController1?.text) {
        return 'As senhas não coincidem';
      }
      return null;
    };
  }

  Future<bool> sendOtp(String phoneNumber) async {
    try {
      _isSendingOtp = true;
      await _userService.sendOtp(phoneNumber);
      _isSendingOtp = false;
      return true;
    } catch (e) {
      _isSendingOtp = false;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createUser({
    required String nomeCompleto,
    required String telefone,
    required String email,
    required String senha,
  }) async {
    try {
      _isRegistering = true;
      
      final user = CreateUserRequest(
        name: nomeCompleto,
        password: senha,
        email: email,
        phone_number: telefone,
        phone_number_mask: '+244',
        role: RoleEnum.JOGADOR,
      );

      final result = await _userService.createUser(user);
      
      _isRegistering = false;
      return result;
    } catch (e) {
      _isRegistering = false;
      rethrow;
    }
  }
  Map<String, dynamic> validateFormData() {
    final nomeCompleto = inputMomeCompletoTextController?.text ?? '';
    final telefone = inputTelefoneTextController?.text ?? '';
    final email = inputEmailTextController?.text ?? '';
    final senha = inputSenhaTextController1?.text ?? '';
    final confirmarSenha = inputSenhaTextController2?.text ?? '';

    final errors = <String>[];

    if (nomeCompleto.isEmpty) {
      errors.add('Nome completo é obrigatório');
    } else if (nomeCompleto.trim().split(' ').length < 2) {
      errors.add('Insira nome e sobrenome');
    }

    if (telefone.isEmpty) {
      errors.add('Telefone é obrigatório');
    } else {
      final phoneDigits = telefone.replaceAll(RegExp(r'[^0-9]'), '');
      if (phoneDigits.length < 9) {
        errors.add('Telefone deve ter no mínimo 9 dígitos');
      }
    }

    if (email.isEmpty) {
      errors.add('Email é obrigatório');
    } else {
      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(email.trim())) {
        errors.add('Email inválido');
      }
    }

    if (senha.isEmpty) {
      errors.add('Senha é obrigatória');
    } else if (senha.length < 6) {
      errors.add('Senha deve ter pelo menos 6 caracteres');
    }

    if (confirmarSenha.isEmpty) {
      errors.add('Confirmação de senha é obrigatória');
    } else if (senha != confirmarSenha) {
      errors.add('As senhas não coincidem');
    }

    if (!(checkboxValue ?? false)) {
      errors.add('Aceite os termos e políticas para continuar');
    }

    return {
      'isValid': errors.isEmpty,
      'errors': errors,
      'data': errors.isEmpty
          ? {
              'nomeCompleto': nomeCompleto,
              'telefone': telefone,
              'email': email,
              'senha': senha,
            }
          : null,
    };
  }
  void clearForm() {
    inputMomeCompletoTextController?.clear();
    inputTelefoneTextController?.clear();
    inputEmailTextController?.clear();
    inputSenhaTextController1?.clear();
    inputSenhaTextController2?.clear();
    checkboxValue = false;
  }

  String formatPhoneNumberForOtp(String phoneNumber) {
    final digits = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (!digits.startsWith('+')) {
      return '+244$digits';
    }
    
    return digits;
  }

  void resetLoadingStates() {
    _isRegistering = false;
    _isSendingOtp = false;
  }
}