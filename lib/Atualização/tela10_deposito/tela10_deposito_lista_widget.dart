import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  // Cores do tema atualizadas para melhor contraste
  final Color _primaryColor = const Color(0xFFEC8D0D);
  final Color _secondaryColor = const Color(0xFF2C3E50);
  final Color _backgroundColor = const Color(0xFFF5F7FA);
  final Color _surfaceColor = Colors.white;
  final Color _onPrimaryColor = Colors.white;
  final Color _onSurfaceColor = const Color(0xFF2C3E50);
  final Color _borderColor = const Color(0xFFE0E0E0);

  // Métodos de pagamento com sombras mais sutis
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'label': 'Multicaixa',
      'icon': Icons.credit_card_outlined,
      'image': 'assets/images/multicaixa.png',
      'color': Color(0xFFD2A739),
      'gradient': [Color(0xFFD2A739), Color(0xFFF5D76E)],
      'description': 'Pagamento via terminal ATM',
      'shadow': BoxShadow(
        color: Color(0xFFD2A739).withOpacity(0.2),
        blurRadius: 10,
        offset: Offset(0, 4),
      )
    },
    {
      'label': 'Express',
      'icon': Icons.bolt_outlined,
      'image': 'assets/images/express.png',
      'color': Color(0xFFFF8008),
      'gradient': [Color(0xFFFF8008), Color(0xFFFFC837)],
      'description': 'Transferência expressa',
      'shadow': BoxShadow(
        color: Color(0xFFFF8008).withOpacity(0.2),
        blurRadius: 10,
        offset: Offset(0, 4),
      )
    },
    {
      'label': 'Afrimoney',
      'icon': Icons.phone_android_outlined,
      'image': 'assets/images/afrimoney.png',
      'color': Color(0xFF1D976C),
      'gradient': [Color(0xFF1D976C), Color(0xFF93F9B9)],
      'description': 'Carteira digital segura',
      'shadow': BoxShadow(
        color: Color(0xFF1D976C).withOpacity(0.2),
        blurRadius: 10,
        offset: Offset(0, 4),
      )
    },
    {
      'label': 'Unitel Money',
      'icon': Icons.phone_iphone_outlined,
      'image': 'assets/images/unitel-money.png',
      'color': Color(0xFF3498DB),
      'gradient': [Color(0xFF3498DB), Color(0xFF2ECC71)],
      'description': 'Pagamento móvel rápido',
      'shadow': BoxShadow(
        color: Color(0xFF3498DB).withOpacity(0.2),
        blurRadius: 10,
        offset: Offset(0, 4),
      )
    },
    {
      'label': 'Pay Pay',
      'icon': Icons.account_balance_wallet_outlined,
      'image': 'assets/images/paypay.png',
      'color': Color(0xFF9D50BB),
      'gradient': [Color(0xFF6E48AA), Color(0xFF9D50BB)],
      'description': 'Solução digital completa',
      'shadow': BoxShadow(
        color: Color(0xFF9D50BB).withOpacity(0.2),
        blurRadius: 10,
        offset: Offset(0, 4),
      )
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: _primaryColor,
          secondary: _secondaryColor,
          background: _backgroundColor,
          surface: _surfaceColor,
          onPrimary: _onPrimaryColor,
          onSurface: _onSurfaceColor,
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.zero,
        ),
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Depositar',
        style: TextStyle(
          color: _onSurfaceColor,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, 
                  color: _primaryColor, size: 22),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.help_outline_rounded, 
                    color: _primaryColor, size: 24),
          onPressed: () => _showHelpDialog(context),
        ),
      ],
      elevation: 0,
      backgroundColor: _surfaceColor,
      shape: Border(
        bottom: BorderSide(color: _borderColor, width: 1),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        Expanded(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPaymentMethodCard(context, index),
                    ),
                    childCount: _paymentMethods.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _primaryColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.account_balance_wallet_rounded, 
                        color: _primaryColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Depósito Instantâneo',
                  style: TextStyle(
                    color: _onSurfaceColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Saldo disponível em até 15 minutos após confirmação',
                  style: TextStyle(
                    color: _onSurfaceColor.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(BuildContext context, int index) {
    final method = _paymentMethods[index];
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showPaymentDialog(context, method['label']),
        splashColor: method['color'].withOpacity(0.2),
        highlightColor: method['color'].withOpacity(0.1),
        child: Ink(
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: method['gradient'],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [method['shadow']],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Logo container
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Image.asset(
                      method['image'],
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Text content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method['label'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        method['description'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.9),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: _surfaceColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  color: _primaryColor,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Ajuda com Depósitos',
                style: TextStyle(
                  color: _onSurfaceColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Selecione um método de pagamento para depositar fundos na sua conta. '
                  'Todos os depósitos são processados de forma segura e rápida.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _onSurfaceColor.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: _onPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'ENTENDI',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
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
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 0,
              offset: Offset(0, -5),
            )
          ],
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: methodData['gradient'],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      methodData['image'],
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              methodData['label'],
              style: TextStyle(
                color: _onSurfaceColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: SingleChildScrollView(
                child: PaymentForm(method: method),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _onSurfaceColor,
                      side: BorderSide(color: _borderColor),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'CANCELAR',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: _onPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'CONFIRMAR',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showMulticaixaDialog(BuildContext context) {
    final method = _paymentMethods[0];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 0,
              offset: Offset(0, -5),
            )
          ],
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: method['gradient'],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      method['image'],
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Multicaixa',
              style: TextStyle(
                color: _onSurfaceColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildCopyableField(
              context,
              label: 'Entidade',
              value: '00000000',
              iconColor: method['color'],
            ),
            const SizedBox(height: 12),
            _buildCopyableField(
              context,
              label: 'Referência',
              value: '000000',
              iconColor: method['color'],
            ),
            const SizedBox(height: 16),
            Text(
              'Como realizar o pagamento:',
              style: TextStyle(
                color: _onSurfaceColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ..._buildInstructionSteps(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: _onPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'FECHAR',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyableField(
    BuildContext context, {
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _onSurfaceColor.withOpacity(0.7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Material(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(10),
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label copiado!'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: _primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _borderColor),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _onSurfaceColor,
                      ),
                    ),
                  ),
                  Icon(Icons.copy, size: 20, color: iconColor),
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
    ].map((step) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.circle,
              size: 6,
              color: _primaryColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              step,
              style: TextStyle(
                color: _onSurfaceColor.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    )).toList();
  }
}