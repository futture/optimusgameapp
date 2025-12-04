import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'moda_menu_pagian_inicial_widget.dart' show ModaMenuPagianInicialWidget;
import 'package:flutter/material.dart';

class ModaMenuPagianInicialModel
    extends FlutterFlowModel<ModaMenuPagianInicialWidget> {
  String? userId;
  UserService _userService = UserService();
  
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  Future<void> getUserIdAsync() async {
    userId = await UserUtil.getUserId();
  }

  Future<void> logoutAsync() async {
    // Garantir que o userId foi carregado antes de fazer logout
    if (userId == null) {
      await getUserIdAsync();
    }
    
    // Verificar novamente se o userId não é null
    if (userId == null || userId!.isEmpty) {
      Warning00ErrorUtil.showDialogMessageError(
        context!,
        "Erro de sessão",
        "Não foi possível obter o ID do usuário. Tente novamente.",
      );
      return;
    }
    
    var result = await _userService.logoutAsync(userId!); 
    if (!result["isSuccess"]) {
      Warning00ErrorUtil.showDialogMessageError(
        context!,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }
}