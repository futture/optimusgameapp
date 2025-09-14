import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/pages/payment/payment_forms/payment_form.dart';

class Tela10DepositoListaWidget extends StatefulWidget {
  const Tela10DepositoListaWidget({super.key});

  static String routeName = 'Tela10DepositoLista';
  static String routePath = '/tela10DepositoLista';

  @override
  State<Tela10DepositoListaWidget> createState() =>
      _Tela10DepositoListaWidgetState();
}

class _Tela10DepositoListaWidgetState extends State<Tela10DepositoListaWidget> {
  final Color _primaryColor = const Color(0xFF4361EE);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = const Color(0xFF212529);
  final Color _borderColor = const Color(0xFFE9ECEF);
  final Color _successColor = const Color(0xFF4BB543);
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'label': 'Multicaixa',
      'icon': Icons.credit_card,
      'image': 'assets/images/multicaixa.png',
      'color': Color(0xFF2C3E50),
      'description': 'Pagamento via terminal ATM',
    },
    {
      'label': 'Express',
      'icon': Icons.bolt,
      'image': 'assets/images/express.png',
      'color': Color(0xFFFF7B25),
      'description': 'Transferência expressa',
    },
    {
      'label': 'Afrimoney',
      'icon': Icons.phone_android,
      'image': 'assets/images/afrimoney.png',
      'color': Color(0xFF1D976C),
      'description': 'Carteira digital segura',
    },
    {
      'label': 'Unitel Money',
      'icon': Icons.phone_iphone,
      'image': 'assets/images/unitel.png',
      'color': Color(0xFF3498DB),
      'description': 'Pagamento móvel rápido',
    },
    {
      'label': 'Pay Pay',
      'icon': Icons.account_balance_wallet,
      'image': 'assets/images/paypay_africa_logo.jpeg',
      'color': Color(0xFF6E48AA),
      'description': 'Solução digital completa',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: _primaryColor,
          background: _backgroundColor,
          surface: _surfaceColor,
          onSurface: _onSurfaceColor,
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          title: Text(
            'Depositar',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'Inter Tight',
                  color: const Color(0xFFEC8D0D),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          shape: Border(
            bottom: BorderSide(
              color: Colors.black.withOpacity(0.1),
              width: 1,
            ),
          ),
          toolbarHeight: 60,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: const Color(0xFFEC8D0D),
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.help_outline_rounded,
                color: const Color(0xFFEC8D0D).withOpacity(0.8),
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 800), // Largura máxima
              padding: EdgeInsets.all(isWeb ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  SizedBox(height: 24),
                  _buildPaymentMethodsGrid(context, isWeb),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet_rounded,
                    color: _primaryColor, size: 20),
                SizedBox(width: 12),
                Text(
                  'Depósito Rápido',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Selecione um método de pagamento para adicionar fundos à sua conta.',
              style: TextStyle(
                color: _onSurfaceColor.withOpacity(0.7),
                fontSize: 13,
              ),
            ),
            SizedBox(height: 12),
            Divider(height: 1, color: _borderColor),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 16, color: _primaryColor),
                SizedBox(width: 8),
                Text('Disponível em até 15 minutos',
                    style: TextStyle(fontSize: 12)),
                Spacer(),
                Icon(Icons.security_rounded, size: 16, color: _successColor),
                SizedBox(width: 8),
                Text('100% Seguro',
                    style: TextStyle(fontSize: 12, color: _successColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsGrid(BuildContext context, bool isWeb) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero, 
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWeb ? 3 : 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9, 
        mainAxisExtent: 180, 
      ),
      itemCount: _paymentMethods.length,
      itemBuilder: (context, index) => _buildPaymentMethodCard(context, index),
    );
  }

Widget _buildPaymentMethodCard(BuildContext context, int index) {
    final method = _paymentMethods[index];

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 300, // Largura máxima para evitar expansão excessiva
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: _borderColor, width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showPaymentDialog(context, method['label']),
          child: Padding(
            padding: EdgeInsets.all(12), // Reduzido de 16
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64, // Reduzido de 80
                  height: 64, // Reduzido de 80
                  decoration: BoxDecoration(
                    color: method['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      method['image'],
                      fit: BoxFit.contain, // Alterado para contain
                      width: 40, // Tamanho reduzido
                      height: 40, // Tamanho reduzido
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Flexible( // Adicionado Flexible para evitar overflow
                  child: Text(
                    method['label'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 4),
                Flexible( // Adicionado Flexible para evitar overflow
                  child: Text(
                    method['description'],
                    style: TextStyle(
                      fontSize: 12,
                      color: _onSurfaceColor.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, String method) {
    if (method == 'Multicaixa') {
      _showMulticaixaDialog(context);
    } else {
      _showGenericPaymentDialog(context, method);
    }
  }

  void _showGenericPaymentDialog(BuildContext context, String method) {
    final methodData = _paymentMethods.firstWhere((m) => m['label'] == method);

    showDialog(
      context: context,
      builder: (context) => Center(
        // Centraliza o diálogo
        child: Container(
          width:
              MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
          margin: EdgeInsets.all(20),
          child: Dialog(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Spacer(),
                      Text(
                        methodData['label'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(height: 1),
                  SizedBox(height: 16),
                  Flexible(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.6),
                      child: SingleChildScrollView(
                        child: PaymentForm(method: method),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('CANCELAR'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showPaymentSuccess(context, method);
                          },
                          child: Text('CONFIRMAR'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMulticaixaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        // Centraliza o diálogo
        child: Container(
          width:
              MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
          margin: EdgeInsets.all(20),
          child: Dialog(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Spacer(),
                      Text(
                        'Multicaixa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(height: 1),
                  SizedBox(height: 16),
                  _buildCopyableField(
                    context,
                    label: 'Entidade',
                    value: '12345',
                    icon: Icons.account_balance_rounded,
                  ),
                  SizedBox(height: 16),
                  _buildCopyableField(
                    context,
                    label: 'Referência',
                    value: '987654321',
                    icon: Icons.receipt_rounded,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Como realizar o pagamento:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 12),
                  ..._buildInstructionSteps(),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('FECHAR'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentSuccess(BuildContext context, String method) {
    showDialog(
      context: context,
      builder: (context) => Center(
        // Centraliza o diálogo
        child: Container(
          width:
              MediaQuery.of(context).size.width > 600 ? 400 : double.infinity,
          margin: EdgeInsets.all(20),
          child: Dialog(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: _successColor, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Pagamento Processado!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Seu pagamento via $method foi enviado para processamento.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('VOLTAR'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCopyableField(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12)),
        SizedBox(height: 4),
        Material(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label copiado!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _borderColor),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: _primaryColor),
                  SizedBox(width: 12),
                  Expanded(child: Text(value)),
                  Icon(Icons.copy, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildInstructionSteps() {
    return [
      'Acesse um terminal Multicaixa',
      'Selecione "Pagamento por Referência"',
      'Insira os dados fornecidos acima',
      'Confirme o valor e finalize',
      'Guarde o comprovante'
    ]
        .map((step) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 8, color: _primaryColor),
                  SizedBox(width: 8),
                  Expanded(child: Text(step, style: TextStyle(fontSize: 13))),
                ],
              ),
            ))
        .toList();
  }
}
