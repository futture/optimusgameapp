import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'modal05_valida_conta_widget.dart' show Modal05ValidaContaWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Modal05ValidaContaModel
    extends FlutterFlowModel<Modal05ValidaContaWidget> {
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
