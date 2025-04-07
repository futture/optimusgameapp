import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'tela01_criar_conta_widget.dart' show Tela01CriarContaWidget;
import 'package:flutter/material.dart';

class Tela01CriarContaModel extends FlutterFlowModel<Tela01CriarContaWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for inputMomeCompleto widget.
  FocusNode? inputMomeCompletoFocusNode;
  TextEditingController? inputMomeCompletoTextController;
  String? Function(BuildContext, String?)?
      inputMomeCompletoTextControllerValidator;
  // State field(s) for inputTelefone widget.
  FocusNode? inputTelefoneFocusNode;
  TextEditingController? inputTelefoneTextController;
  String? Function(BuildContext, String?)? inputTelefoneTextControllerValidator;
  // State field(s) for inputEmail widget.
  FocusNode? inputEmailFocusNode;
  TextEditingController? inputEmailTextController;
  String? Function(BuildContext, String?)? inputEmailTextControllerValidator;
  // State field(s) for inputSenha widget.
  FocusNode? inputSenhaFocusNode1;
  TextEditingController? inputSenhaTextController1;
  late bool inputSenhaVisibility1;
  String? Function(BuildContext, String?)? inputSenhaTextController1Validator;
  // State field(s) for inputSenha widget.
  FocusNode? inputSenhaFocusNode2;
  TextEditingController? inputSenhaTextController2;
  late bool inputSenhaVisibility2;
  String? Function(BuildContext, String?)? inputSenhaTextController2Validator;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;

  @override
  void initState(BuildContext context) {
    inputSenhaVisibility1 = false;
    inputSenhaVisibility2 = false;
  }

  @override
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
}
