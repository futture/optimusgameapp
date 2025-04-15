import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'warning04_reducao_de_saldo_model.dart';
export 'warning04_reducao_de_saldo_model.dart';

class Warning04ReducaoDeSaldoWidget extends StatefulWidget {
  final bool? subscribe;
  final dynamic matchInfo;
  final bool? recebeuNotificaca;

  const Warning04ReducaoDeSaldoWidget(
      {super.key, this.matchInfo, this.subscribe, this.recebeuNotificaca});

  @override
  State<Warning04ReducaoDeSaldoWidget> createState() =>
      _Warning04ReducaoDeSaldoWidgetState();
}

class _Warning04ReducaoDeSaldoWidgetState
    extends State<Warning04ReducaoDeSaldoWidget> {
  late Warning04ReducaoDeSaldoModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Warning04ReducaoDeSaldoModel());

    _model.getUserIdAsync(() => setState(() {}));
    _model.onStateUpdate = () => setState(() {});
    _model.matchInfo = widget.matchInfo;
    _model.initState(context);
  }

  @override
  void dispose() {
    _model.dispose();
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.0,
      height: 210.0,
      constraints: BoxConstraints(
        minWidth: 280.0,
        minHeight: 200.0,
        maxWidth: 400.0,
        maxHeight: 250.0,
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 7.0, 0.0, 0.0),
            child: Icon(
              Icons.warning_amber,
              color: Color(0xFFFF0000),
              size: 60.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Atenção: ao se inscrever nesta sala será reduzido do seu saldo a taxa de ${_model.matchInfo.matchConfiguration!.minimumAmountToPlay}Kz para poder jogar',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
            child: FFButtonWidget(
              onPressed: () async {
                setState(() {
                  _model.isWaitingPlayers = true;
                });

                await _model.joinTheMatchAsync(widget.subscribe, widget.recebeuNotificaca);
              },
              text: 'Confirmar Inscrição',
              options: FFButtonOptions(
                height: 45.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                color: Color(0xFF00C804),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter Tight',
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                elevation: 0.0,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
