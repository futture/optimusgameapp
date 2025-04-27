import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'warning00_campo_vazio_model.dart';
export 'warning00_campo_vazio_model.dart';

class Warning00CampoVazioWidget extends StatefulWidget {
  final String titulo;
  final String detalhe;
  const Warning00CampoVazioWidget({
    super.key,
    required this.titulo,
    required this.detalhe,
  });

  @override
  State<Warning00CampoVazioWidget> createState() =>
      _Warning00CampoVazioWidgetState();
}

class _Warning00CampoVazioWidgetState extends State<Warning00CampoVazioWidget> {
  late Warning00CampoVazioModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Warning00CampoVazioModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.0,
      constraints: BoxConstraints(
        minWidth: 280.0,
        maxWidth: 400.0,
        minHeight: 200.0,
        maxHeight: 300.0,
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 60.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
            child: Text(
              widget.titulo,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Colors.red,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 0.0),
            child: Text(
              widget.detalhe,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.0,
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            child: FFButtonWidget(
              onPressed: () async {
                context.safePop();
              },
              text: 'OK',
              options: FFButtonOptions(
                height: 45.0,
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

class Warning00ErrorUtil {
  static Future<void> showDialogMessageError(
      context, String title, String description) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment: AlignmentDirectional(0.0, 0.0)
              .resolve(Directionality.of(context)),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(dialogContext).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Warning00CampoVazioWidget(
              titulo: title,
              detalhe: description,
            ),
          ),
        );
      },
    );
  }
}
