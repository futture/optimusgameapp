import '/flutter_flow/flutter_flow_util.dart';
import 'tela10_deposito_e_x_p_r_e_s_s_widget.dart'
    show Tela10DepositoEXPRESSWidget;
import 'package:flutter/material.dart';


class Tela10DepositoEXPRESSModel
    extends FlutterFlowModel<Tela10DepositoEXPRESSWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
