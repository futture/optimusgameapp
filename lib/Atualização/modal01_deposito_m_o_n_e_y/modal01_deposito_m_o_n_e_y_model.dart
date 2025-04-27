import '/flutter_flow/flutter_flow_util.dart'; 
import 'modal01_deposito_m_o_n_e_y_widget.dart' show Modal01DepositoMONEYWidget;
import 'package:flutter/material.dart'; 

class Modal01DepositoMONEYModel
    extends FlutterFlowModel<Modal01DepositoMONEYWidget> {
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
