import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'tela06_salade_jogo_widget.dart' show Tela06SaladeJogoWidget;
import 'package:flutter/material.dart';

class Tela06SaladeJogoModel extends FlutterFlowModel<Tela06SaladeJogoWidget> {
  /// State fields
  final formKey = GlobalKey<FormState>();

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

  // ✅ Apenas um controlador de rádio
  FormFieldController<String>? radioGroupValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    timerController.dispose();
  }

  /// Getter para acessar a opção selecionada
  String? get selectedOption => radioGroupValueController?.value;
}
