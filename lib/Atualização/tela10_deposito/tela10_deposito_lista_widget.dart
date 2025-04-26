import 'package:flutter/services.dart';
import 'package:projeto_game_quiz/Atualiza%C3%A7%C3%A3o/tela10_deposito_e_x_p_r_e_s_s/tela10_deposito_e_x_p_r_e_s_s_widget.dart';
import 'package:projeto_game_quiz/pages/payment/payment_forms/payment_form.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'tela10_deposito_lista_model.dart';
export 'tela10_deposito_lista_model.dart';

class Tela10DepositoListaWidget extends StatefulWidget {
  const Tela10DepositoListaWidget({super.key});

  static String routeName = 'Tela10DepositoLista';
  static String routePath = '/tela10DepositoLista';

  @override
  State<Tela10DepositoListaWidget> createState() =>
      _Tela10DepositoListaWidgetState();
}

class _Tela10DepositoListaWidgetState extends State<Tela10DepositoListaWidget> {
  final List<Map<String, String>> methods = [
    {
      'label': 'Multicaixa',
    },
    {
      'label': 'Express',
    },
    {
      'label': 'Afrimoney',
    },
    {
      'label': 'Unitel Money',
    },
  ];
  late Tela10DepositoListaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela10DepositoListaModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(18.0, 0.0, 0.0, 0.0),
            child: FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 45.0,
              fillColor: FlutterFlowTheme.of(context).primaryBackground,
              icon: Icon(
                Icons.arrow_back,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ),
          title: Text(
            'DEPOSITAR',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'Inter Tight',
                  color: Color(0xFFEC8D0D),
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 4.0,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 25.0, 25.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                constraints: BoxConstraints(
                  minWidth: 300.0,
                  minHeight: 852.0,
                  maxWidth: 500.0,
                  maxHeight: 1000.0,
                ),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          width: 330.0,
                          height: 80.0,
                          constraints: BoxConstraints(
                            minWidth: 330.0,
                            minHeight: 80.0,
                            maxWidth: 500.0,
                            maxHeight: 80.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                                spreadRadius: 4.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/multicaixa.png',
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment(0.0, 0.0),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () {
                                    _showPaymentDialog(context, 'Multicaixa');
                                  },
                                  text: '',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: double.infinity,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: Color(0x00FFFFFF),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Inter Tight',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          width: 330.0,
                          height: 80.0,
                          constraints: BoxConstraints(
                            minWidth: 330.0,
                            minHeight: 80.0,
                            maxWidth: 500.0,
                            maxHeight: 80.0,
                          ),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                                spreadRadius: 4.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/Unknown.jpeg',
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  alignment: Alignment(0.0, 0.0),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () {
                                    _showPaymentDialog(context, 'Express');
                                  },
                                  text: '',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: double.infinity,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: Color(0x004B39EF),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Inter Tight',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          width: 330.0,
                          height: 80.0,
                          constraints: BoxConstraints(
                            minWidth: 330.0,
                            minHeight: 80.0,
                            maxWidth: 500.0,
                            maxHeight: 80.0,
                          ),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                                spreadRadius: 4.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/unitel-mobile-.png',
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.fill,
                                  alignment: Alignment(0.0, 0.0),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () {
                                    _showPaymentDialog(context, 'Unitel Money');
                                  },
                                  text: '',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: double.infinity,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: Color(0x004B39EF),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Inter Tight',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          width: 330.0,
                          height: 80.0,
                          constraints: BoxConstraints(
                            minWidth: 330.0,
                            minHeight: 80.0,
                            maxWidth: 500.0,
                            maxHeight: 80.0,
                          ),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                                spreadRadius: 4.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/paypay_africa_logo.jpeg',
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  alignment: Alignment(0.0, 0.0),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () {
                                    _showPaymentDialog(context, 'Pay Pay');
                                  },
                                  text: '',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: double.infinity,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: Color(0x004B39EF),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Inter Tight',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          width: 330.0,
                          height: 80.0,
                          constraints: BoxConstraints(
                            minWidth: 330.0,
                            minHeight: 80.0,
                            maxWidth: 500.0,
                            maxHeight: 80.0,
                          ),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                                spreadRadius: 4.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/images.png',
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  alignment: Alignment(0.0, 0.0),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () {
                                    _showPaymentDialog(context, 'Afrimoney');
                                  },
                                  text: '',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: double.infinity,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: Color(0x004B39EF),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Inter Tight',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                        .divide(SizedBox(height: 20.0))
                        .addToStart(SizedBox(height: 20.0)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AlertDialog _genericPaymentDialog(BuildContext context, String method) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          _getIconForMethod(method),
          const SizedBox(width: 8),
          Text(
            method,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 350,
        child: PaymentForm(method: method), // único formulário reutilizável
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Fechar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ],
    );
  }

  AlertDialog _multicaixaDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      title: Row(
        children: const [
          Icon(Icons.credit_card, color: Color(0xFFD2A739)),
          SizedBox(width: 8),
          Text(
            'Multicaixa',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Color(0xFFD2A739),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(thickness: 1),
          const SizedBox(height: 12),
          _buildCopyableText(context, 'Entidade', '00000000'),
          const SizedBox(height: 10),
          _buildCopyableText(context, 'Referência', '000000'),
          const SizedBox(height: 24),
          const Text(
            'Como carregar via Multicaixa: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _buildInstructionStep('1. Vá a um  ATM.'),
          _buildInstructionStep(
              '2. Vá até a opção “Pagamento por Referência”.'),
          _buildInstructionStep(
              '3. Insira a Entidade e Referência fornecidas.'),
          _buildInstructionStep('4. Confirme o valor e finalize o pagamento.'),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.redAccent),
          label: const Text(
            'Fechar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCopyableText(BuildContext context, String label, String value) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('$label copiado para a área de transferência')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFFD2A739), width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.copy, color: Color(0xFFD2A739)),
            const SizedBox(width: 10),
            Text(
              '$label: ',
              style: const TextStyle(
                  fontWeight: FontWeight.normal, color: Colors.black),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right, size: 20, color: Colors.black54),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  AlertDialog _empressDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.flash_on, color: Colors.deepPurple),
          SizedBox(width: 8),
          Text(
            'Express',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 350,
        child: Tela10DepositoEXPRESSWidget(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Fechar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ],
    );
  }

  AlertDialog _afrimoneyUnitelDialog(BuildContext context, String method) {
    return AlertDialog(
      title: Text(method,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          TextField(
              decoration: InputDecoration(
                  labelText: 'Número de Telefone',
                  labelStyle: TextStyle(color: Colors.deepPurple))),
          SizedBox(height: 12),
          TextField(
              decoration: InputDecoration(
                  labelText: 'Montante',
                  labelStyle: TextStyle(color: Colors.deepPurple))),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Fechar',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        ),
      ],
    );
  }

  void _showCommonDialog({
    required BuildContext context,
    required String method,
    required Icon icon,
    required Color color,
    required Widget content,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              method,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        content: SizedBox(width: 350, child: content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fechar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, String method) {
    showDialog(
      context: context,
      builder: (_) {
        if (method == 'Multicaixa') {
          return _multicaixaDialog(context);
        } else {
          return _genericPaymentDialog(context, method);
        }
      },
    );
  }

  Icon _getIconForMethod(String method) {
    switch (method) {
      case 'Express':
        return const Icon(Icons.flash_on, color: Colors.deepPurple);
      case 'Unitel Money':
      case 'Afrimoney':
        return const Icon(Icons.phone_android, color: Colors.deepPurple);
      case 'Pay Pay':
        return const Icon(Icons.account_balance_wallet,
            color: Colors.deepPurple);
      default:
        return const Icon(Icons.warning, color: Colors.deepPurple);
    }
  }
}
