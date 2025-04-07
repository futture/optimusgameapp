import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'tela06_salade_jogo_widget.dart' show Tela06SaladeJogoWidget;
import 'package:flutter/material.dart';

class Tela06SaladeJogoModel extends FlutterFlowModel<Tela06SaladeJogoWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Timer widget.
  final timerInitialTimeMs = 10000;
  int timerMilliseconds = 10000;
  String timerValue = StopWatchTimer.getDisplayTime(
    10000,
    hours: false,
    minute: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  // State field(s) for RadioButtonA widget.
  FormFieldController<String>? radioButtonAValueController;
  // State field(s) for RadioButtonB widget.
  FormFieldController<String>? radioButtonBValueController;
  // State field(s) for RadioButtonC widget.
  FormFieldController<String>? radioButtonCValueController;
  // State field(s) for RadioButtonD widget.
  FormFieldController<String>? radioButtonDValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    timerController.dispose();
  }

  /// Additional helper methods.
  String? get radioButtonAValue => radioButtonAValueController?.value;
  String? get radioButtonBValue => radioButtonBValueController?.value;
  String? get radioButtonCValue => radioButtonCValueController?.value;
  String? get radioButtonDValue => radioButtonDValueController?.value;
}
