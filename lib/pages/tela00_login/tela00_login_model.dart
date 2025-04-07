import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'tela00_login_widget.dart' show Tela00LoginWidget;
import 'package:flutter/material.dart';

class Tela00LoginModel extends FlutterFlowModel<Tela00LoginWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for inputEmail widget.
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

  @override
  void initState(BuildContext context) {
    inputSenhaVisibility = false;
  }

  @override
  void dispose() {
    inputEmailFocusNode?.dispose();
    inputEmailTextController?.dispose();

    inputSenhaFocusNode?.dispose();
    inputSenhaTextController?.dispose();
  }
}
