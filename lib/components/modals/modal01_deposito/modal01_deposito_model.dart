import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'modal01_deposito_widget.dart' show Modal01DepositoWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Modal01DepositoModel extends FlutterFlowModel<Modal01DepositoWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for id widget.
  final idKey = GlobalKey();
  FocusNode? idFocusNode;
  TextEditingController? idTextController;
  String? idSelectedOption;
  String? Function(BuildContext, String?)? idTextControllerValidator;
  String? _idTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '123456789 is required';
    }
    if (val != idSelectedOption) {
      return 'Please choose an option from the dropdown';
    }

    return null;
  }

  // State field(s) for montante widget.
  final montanteKey = GlobalKey();
  FocusNode? montanteFocusNode;
  TextEditingController? montanteTextController;
  String? montanteSelectedOption;
  String? Function(BuildContext, String?)? montanteTextControllerValidator;
  String? _montanteTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '1500 is required';
    }
    if (val != montanteSelectedOption) {
      return 'Please choose an option from the dropdown';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    idTextControllerValidator = _idTextControllerValidator;
    montanteTextControllerValidator = _montanteTextControllerValidator;
  }

  @override
  void dispose() {
    idFocusNode?.dispose();

    montanteFocusNode?.dispose();
  }
}
