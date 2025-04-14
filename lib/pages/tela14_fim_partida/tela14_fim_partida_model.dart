import '/flutter_flow/flutter_flow_util.dart';
import 'tela14_fim_partida_widget.dart' show Tela14FimPartidaViewWidget;
import 'package:flutter/material.dart';

class Tela14FimPartidaViewModel extends FlutterFlowModel<Tela14FimPartidaViewWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
