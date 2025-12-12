import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/account_service.dart';
import 'package:projeto_game_quiz/core/api/services/account_transaction_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/generate_reference_request.dart';
import 'package:projeto_game_quiz/core/models/responses/account_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'tela10_deposito_lista_widget.dart' show Tela10DepositoListaWidget;
import 'package:flutter/material.dart';

class Tela10DepositoListaModel
    extends FlutterFlowModel<Tela10DepositoListaWidget> {

  UserResponse? user;
  String reference = "";
  AccountResponse? userAccountInfo;
  final AccountService accountService = AccountService();
  
  AccountTransactionService accountTransactionService = AccountTransactionService();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  Future<void> getUserInfoAndAccountInfoAsync(
      void Function(VoidCallback fn) setState, BuildContext context) async {
    await getUserInfo(setState);
    await getUserAccountInfo(setState);
  }

  Future<void> getUserInfo(void Function(VoidCallback fn) setState) async {
    var _user = await UserUtil.getUserInfo();
    setState(() {
      user = _user!;
    });
  }

  Future<void> getUserAccountInfo(
      void Function(VoidCallback fn) setState) async {
    var result = await accountService.getAccountByUserIdAsync(user!.id);
    if (result["isSuccess"]) {
      setState(() {
        userAccountInfo = result["data"];
      });
    } else {
      Warning00ErrorUtil.showDialogMessageError(context,
          result["error"].detail.message, result["error"].detail.details);
    }
  }
  
  // CORREÇÃO 1: Mudar o tipo do parâmetro para VoidCallback
  Future<Map<String, dynamic>> generateReference(
    String amount, 
    VoidCallback updateUI,
    BuildContext context,
  ) async { 
    
    try { 
      var result = await accountTransactionService.generateReference(
        GenerateReferenceRequest(Amount: amount, AccountId: userAccountInfo!.id, UserId: user!.id)
      );
       
      print(result["isSuccess"]);
      if (result["isSuccess"]) { 
        reference = result["data"].Reference.toString(); 
        if (updateUI != null) {
          updateUI();
        }
        
        return {
          'isSuccess': true,
          'data': result["data"]
        };
      } else { 
        Warning00ErrorUtil.showDialogMessageError(
          context,
          result["error"].detail.message,
          result["error"].detail.details,
        );
        
        return {
          'isSuccess': false,
          'error': result["error"]
        };
      }
    } catch (e) {
      print('Erro ao gerar referência: $e');
      
      return {
        'isSuccess': false,
        'error': {
          'detail': {
            'message': 'Erro ao gerar referência',
            'details': e.toString()
          }
        }
      };
    }
  }
  
  // Método alternativo simplificado (opcional)
  Future<Map<String, dynamic>> generateReferenceSimple(String amount) async {
    try {
      var result = await accountTransactionService.generateReference(
        GenerateReferenceRequest(Amount: amount, AccountId: userAccountInfo!.id)
      );
      
      if (result["isSuccess"]) {
        reference = result["data"].toString();
        return {
          'isSuccess': true,
          'data': result["data"]
        };
      } else {
        return {
          'isSuccess': false,
          'error': result["error"]
        };
      }
    } catch (e) {
      print('Erro no generateReferenceSimple: $e');
      return {
        'isSuccess': false,
        'error': {
          'detail': {
            'message': 'Erro de conexão',
            'details': e.toString()
          }
        }
      };
    }
  }
}