import '/flutter_flow/flutter_flow_util.dart';
import 'modals_saque_widget.dart' show ModalsSaqueWidget;
import 'package:flutter/material.dart';

class ModalsSaqueModel extends FlutterFlowModel<ModalsSaqueWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  final textFieldKey = GlobalKey();
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? textFieldSelectedOption;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
  }
}
