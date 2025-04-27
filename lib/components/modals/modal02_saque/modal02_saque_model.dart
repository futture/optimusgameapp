import '/flutter_flow/flutter_flow_util.dart';
import 'modal02_saque_widget.dart' show Modal02SaqueWidget;
import 'package:flutter/material.dart';

class Modal02SaqueModel extends FlutterFlowModel<Modal02SaqueWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for montanteSaque widget.
  FocusNode? montanteSaqueFocusNode;
  TextEditingController? montanteSaqueTextController;
  String? Function(BuildContext, String?)? montanteSaqueTextControllerValidator;
  String? _montanteSaqueTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '1500 is required';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    montanteSaqueTextControllerValidator =
        _montanteSaqueTextControllerValidator;
  }

  @override
  void dispose() {
    montanteSaqueFocusNode?.dispose();
    montanteSaqueTextController?.dispose();
  }
}
