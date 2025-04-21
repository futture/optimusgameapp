import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/account_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/responses/account_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'modals_deposito_widget.dart' show ModalsDepositoWidget;
import 'package:flutter/material.dart';

class ModalsDepositoModel extends FlutterFlowModel<ModalsDepositoWidget> {
  final formKey = GlobalKey<FormState>();
  // Campo 1
  final textFieldKey1 = GlobalKey();
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? textFieldSelectedOption1;
  String? Function(BuildContext, String?)? textController1Validator;

  // Campo 2
  final textFieldKey2 = GlobalKey();
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? textFieldSelectedOption2;
  String? Function(BuildContext, String?)? textController2Validator;

  final textFieldPhoneKey = GlobalKey();
  FocusNode? textFieldPhoneFocusNode;
  TextEditingController? textControllerPhone;
  String? Function(BuildContext, String?)? textControllerPhoneValidator;

  UserResponse? user;
  final AccountService accountService = AccountService();
  AccountResponse? userAccountInfo;

  final List<Map<String, dynamic>> _paymentOptions = [
    {
      'label': 'Multicaixa Express',
      'icon': Icons.credit_card,
    },
    {
      'label': 'Unitel Money',
      'icon': Icons.account_balance_wallet,
    },
    {
      'label': 'Outro',
      'icon': Icons.money,
    },
  ];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textFieldFocusNode2?.dispose();
    textFieldPhoneFocusNode?.dispose(); // 👈 importante
  }

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
      Warning00ErrorUtil.showDialogMessageError(
        context,
        result["error"].detail.message,
        result["error"].detail.details,
      );
    }
  }

  List<DropdownMenuItem<String>> buildPaymentOptions() {
    return _paymentOptions.map<DropdownMenuItem<String>>((option) {
      return DropdownMenuItem<String>(
        value: option['label'],
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                option['icon'],
                color: Colors.deepPurple,
                size: 14,
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                option['label'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
