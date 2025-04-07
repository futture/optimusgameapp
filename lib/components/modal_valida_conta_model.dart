import '/flutter_flow/flutter_flow_util.dart';
import 'modal_valida_conta_widget.dart' show ModalValidaContaWidget;
import 'package:flutter/material.dart';

class ModalValidaContaModel extends FlutterFlowModel<ModalValidaContaWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for otp widget.
  FocusNode? otpFocusNode;
  TextEditingController? otpTextController;
  String? Function(BuildContext, String?)? otpTextControllerValidator;
  String? _otpTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'OTP is required';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    otpTextControllerValidator = _otpTextControllerValidator;
  }

  @override
  void dispose() {
    otpFocusNode?.dispose();
    otpTextController?.dispose();
  }
}
