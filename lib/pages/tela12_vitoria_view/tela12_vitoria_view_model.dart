import '/flutter_flow/flutter_flow_util.dart';
import 'tela12_vitoria_view_widget.dart' show Tela12VitoriaViewWidget;
import 'package:flutter/material.dart';

class Tela12VitoriaViewModel extends FlutterFlowModel<Tela12VitoriaViewWidget> {
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
