import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/account_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/account_request.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'tela07_financas_widget.dart' show Tela07FinancasWidget;
import 'package:flutter/material.dart';

class Tela07FinancasModel extends FlutterFlowModel<Tela07FinancasWidget> {
  ///  State fields for stateful widgets in this page.
  String? userId = "";
  bool isEditingIban = false;
  bool isEditingConta = false;
  final formKey = GlobalKey<FormState>();
  final _accountService = AccountService();

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }

Future<void> getUserIdAndAccountInfo(void Function(VoidCallback fn) setState, BuildContext context) async {
  await getUserIdAsync(setState);
  await getAccountInfoAsync(setState, context);
}
  Future<void> getUserIdAsync(void Function(VoidCallback fn) setState) async {
    var _userId = await UserUtil.getUserId();
    setState(() {
      userId = _userId;
    });
  }

  Future<void> getAccountInfoAsync(void Function(VoidCallback fn) setState, BuildContext context) async {
    if (userId != null && userId != "") {
      var result = await _accountService.getAccountByUserIdAsync(userId!);
      if (result["isSuccess"]) {
        setState(() {
          textController1.text = result["data"].iban;
          textController2.text = result["data"].accountNumber;
        });
      } else {
        Warning00ErrorUtil.showDialogMessageError(context,
            result["error"].detail.message, result["error"].detail.details);
      }
    }
  }

  Future<void> createAccountInfoAsync() async {
    var result = await _accountService.createAccountAsync(
        userId!,
        CreateAccountRequest(
            iban: textController1.text, accountNumber: textController2.text));

    if (result["isSuccess"]) {
    } else {
      Warning00ErrorUtil.showDialogMessageError(context,
          result["error"].detail.message, result["error"].detail.details);
    }
  }
}
