import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';

class Tela00LoginModel extends FlutterFlowModel<Tela00LoginWidget> {
  ///  State fields for stateful widgets in this page.
  UserService userService = UserService();

  final formKey = GlobalKey<FormState>();
  // State field(s) for inputEmail widget.
  FocusNode? inputEmailFocusNode;
  TextEditingController? inputEmailTextController;
  String? Function(BuildContext, String?)? inputEmailTextControllerValidator;
  String? _inputEmailTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'is required';
    }

    return null;
  }

  // State field(s) for inputSenha widget.
  FocusNode? inputSenhaFocusNode;
  TextEditingController? inputSenhaTextController;
  late bool inputSenhaVisibility;
  String? Function(BuildContext, String?)? inputSenhaTextControllerValidator;
  String? _inputSenhaTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Januario Pinto is required';
    }

    return null;
  }

  // State field(s) for Checkbox widget.
  bool? checkboxValue;

  @override
  void initState(BuildContext context) {
    inputEmailTextControllerValidator = _inputEmailTextControllerValidator;
    inputSenhaVisibility = false;
    inputSenhaTextControllerValidator = _inputSenhaTextControllerValidator;
  }

  @override
  void dispose() {
    inputEmailFocusNode?.dispose();
    inputEmailTextController?.dispose();

    inputSenhaFocusNode?.dispose();
    inputSenhaTextController?.dispose();
  }

  Future<void> signInAsync() async {
    final email = inputEmailTextController.text;
    final password = inputSenhaTextController.text;
    if (email.isEmpty) {
      Warning00ErrorUtil.showDialogMessageError(
          context, "Falha ao efetuar o login", "Preencha o campo email");
      return;
    }
    if (password.isEmpty) {
      Warning00ErrorUtil.showDialogMessageError(
          context, "Falha ao efetuar o login", "Preencha o campo senha");
      return;
    }
    final resultToken = await userService.loginUser(email, password);
    if (resultToken["isSuccess"]) {
      await Future.delayed(Duration(seconds: 1));
      context!.pushNamed(Tela03PrincipalWidget.routeName);
    } else {
      Warning00ErrorUtil.showDialogMessageError(
          context,
          resultToken["error"].detail.message,
          resultToken["error"].detail.details);
      return;
    }
  }
}
