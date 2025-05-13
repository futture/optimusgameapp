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
  final VoidCallback? onConfirmed;

  const Warning04ReducaoDeSaldoWidget({
    super.key,
    this.matchInfo,
    this.subscribe,
    this.recebeuNotificaca,
    this.onConfirmed,
  });

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

    _model.getUserIdAsync(() => setState(() {}), setState);
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
      width: MediaQuery.of(context).size.width * 0.85,
      constraints: BoxConstraints(
        maxWidth: 400.0, 
        minHeight: 240.0,
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Icon(
                Icons.warning_rounded,
                color: const Color(0xFFFF3B30),
                size: 48.0,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Atenção',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF3B30),
                    ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Ao se inscrever nesta sala será debitado do seu saldo a taxa de ${_model.matchInfo.room!.roomConfiguration!.minimumAmountToPlay} Kz para poder jogar.',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.0,
                    ),
                softWrap: true, 
                maxLines: 4, 
                overflow: TextOverflow
                    .ellipsis, 
              ),
            ),

            const SizedBox(height: 20.0),

            SizedBox(
              width: double.infinity,
              child: FFButtonWidget(
                onPressed: () async {
                  if (widget.subscribe == null) _model.showWaitingDialog();
                  await _model.joinTheMatchAsync(
                      widget.subscribe, widget.recebeuNotificaca);
                  widget.onConfirmed?.call();
                },
                text: 'CONFIRMAR INSCRIÇÃO',
                options: FFButtonOptions(
                  height: 48.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  color: const Color(0xFF34C759),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter Tight',
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
