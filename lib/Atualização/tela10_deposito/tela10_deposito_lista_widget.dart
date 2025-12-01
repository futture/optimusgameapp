import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_game_quiz/Atualiza%C3%A7%C3%A3o/tela10_deposito/tela10_deposito_lista_model.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';
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
  final Color _primaryColor = Color(0xFF7C3AED);
  final Color _secondaryColor = Color(0xFF059669);
  final Color _backgroundColor = Color(0xFFF1F5F9);
  final Color _surfaceColor = Color(0xFFF8FAFC);
  final Color _cardColor = Color(0xFFFFFFFF);
  final Color _textPrimary = Color(0xFF0F172A);
  final Color _textSecondary = Color(0xFF475569);
  final Color _borderColor = Color(0xFFE2E8F0);
  final Color _successColor = Color(0xFF10B981);

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'Multicaixa',
      'icon': Icons.credit_card_rounded,
      'description': 'Pagamento via terminal ATM',
      'available': true,
      'popular': true,
      'color': Color(0xFF7C3AED),
    },
    {
      'name': 'Express',
      'icon': Icons.bolt_rounded,
      'description': 'Transferência expressa',
      'available': true,
      'popular': false,
      'color': Color(0xFFF59E0B),
    },
    {
      'name': 'Afrimoney',
      'icon': Icons.account_balance_wallet_rounded,
      'description': 'Carteira digital segura',
      'available': true,
      'popular': true,
      'color': Color(0xFF059669),
    },
    {
      'name': 'Unitel Money',
      'icon': Icons.phone_iphone_rounded,
      'description': 'Pagamento móvel rápido',
      'available': false,
      'popular': false,
      'color': Color(0xFF3B82F6),
    },
    {
      'name': 'Africel',
      'icon': Icons.phone_rounded,
      'description': 'Solução digital completa',
      'available': false,
      'popular': false,
      'color': Color(0xFFEC4899),
    },
  ];
  late Tela10DepositoListaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela10DepositoListaModel());
    _model.getUserInfoAndAccountInfoAsync(setState, context);
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'Depositar',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: _backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: _textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon:
                Icon(Icons.help_outline_rounded, size: 22, color: _textPrimary),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildWelcomeSection(),
            SizedBox(height: 24),
            _buildMethodsSection(),
            SizedBox(height: 32),
            _buildSecuritySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _primaryColor.withOpacity(0.05),
            _secondaryColor.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: _primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Adicionar Fundos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Escolha um método de pagamento para depositar na sua conta de forma segura e rápida.',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16),
          _buildFeatureTags(),
        ],
      ),
    );
  }

  Widget _buildFeatureTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        _buildFeatureTag('Seguro', Icons.security_rounded, _successColor),
        _buildFeatureTag('Rápido', Icons.bolt_rounded, Color(0xFFF59E0B)),
        _buildFeatureTag('24/7', Icons.access_time_rounded, _primaryColor),
      ],
    );
  }

  Widget _buildFeatureTag(String text, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Métodos de Pagamento',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Escolha como deseja depositar',
          style: TextStyle(
            color: _textSecondary,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: _paymentMethods.length,
          itemBuilder: (context, index) => _buildMethodCard(index),
        ),
      ],
    );
  }

  Widget _buildMethodCard(int index) {
    final method = _paymentMethods[index];
    final isAvailable = method['available'] as bool;
    final isPopular = method['popular'] as bool;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isAvailable
              ? () => _showPaymentDialog(context, method['name'])
              : null,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isAvailable ? _borderColor : _borderColor.withOpacity(0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com ícone
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: method['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          method['icon'],
                          color: isAvailable ? method['color'] : _textSecondary,
                          size: 22,
                        ),
                      ),
                    ),
                    if (isPopular && isAvailable)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Popular',
                          style: TextStyle(
                            color: _successColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12),
                // Nome do método
                Text(
                  method['name'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isAvailable ? _textPrimary : _textSecondary,
                  ),
                ),
                SizedBox(height: 4),
                // Descrição
                Text(
                  method['description'],
                  style: TextStyle(
                    color: isAvailable
                        ? _textSecondary
                        : _textSecondary.withOpacity(0.6),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
                Spacer(),
                // Botão de ação
                Container(
                  width: double.infinity,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? method['color'].withOpacity(0.1)
                        : _backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      isAvailable ? 'Selecionar' : 'Em breve',
                      style: TextStyle(
                        color: isAvailable ? method['color'] : _textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: _successColor,
              size: 22,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transações Protegidas',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Criptografia avançada em todas as operações',
                  style: TextStyle(
                    color: _textSecondary,
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

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_rounded,
                  color: _primaryColor,
                  size: 28,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Ajuda com Depósitos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Precisa de ajuda? Entre em contato com nosso suporte.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Entendi'),
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
      _showMulticaixaInfo(context);
    } else {
      _showPaymentForm(context, method);
    }
  }

  void _showPaymentForm(BuildContext context, String method) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width:
              MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: _textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 8),
                    Text(
                      method,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: PaymentForm(method: method),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMulticaixaInfo(BuildContext context) {
    // Controladores para os campos editáveis
    TextEditingController montanteController = TextEditingController();

    bool referenciaGerada = false;

    // String gerarReferenciaAleatoria() {
    //   final random = Random();
    //   return List.generate(9, (_) => random.nextInt(10)).join();
    // }

    void _copiarReferencia(BuildContext context) {
      if (_model.reference.isNotEmpty) {
        Clipboard.setData(ClipboardData(text: _model.reference));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Referência copiada para a área de transferência'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }

    bool _isMontanteValido() {
      if (montanteController.text.isEmpty) return false;
      final valor =
          double.tryParse(montanteController.text.replaceAll(',', '.'));
      return valor != null && valor >= 500;
    }

    String? _validarMontante(String? value) {
      if (value == null || value.isEmpty) {
        return 'Insira o montante';
      }
      final valor = double.tryParse(value.replaceAll(',', '.'));
      if (valor == null) {
        return 'Valor inválido';
      }
      if (valor < 500) {
        return 'Mínimo 500 Kz';
      }
      return null;
    }

    // Defina estas cores conforme seu tema
    final Color _cardColor = Colors.white;
    final Color _textPrimary = Colors.black;
    final Color _textSecondary = Colors.grey;
    final Color _primaryColor = Colors.blue;
    final Color _borderColor = Colors.grey[300]!;

    Widget _buildCopyableField(
      BuildContext context, {
      required String label,
      required String value,
      required IconData icon,
    }) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _cardColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: _textSecondary, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: _textSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.copy_rounded, color: _primaryColor, size: 20),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('$label copiado para a área de transferência'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    Widget _buildInstructions() {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _primaryColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Como pagar:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '1. Aceda ao Multicaixa\n'
              '2. Selecione "Pagamentos"\n'
              '3. Insira a entidade e referência\n'
              '4. Confirme o montante\n'
              '5. Finalize a operação',
              style: TextStyle(
                fontSize: 12,
                color: _textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: MediaQuery.of(context).size.width > 600
                  ? 500
                  : double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close_rounded, color: _textSecondary),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Multicaixa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildCopyableField(
                    context,
                    label: 'Entidade',
                    value: '12345',
                    icon: Icons.account_balance_rounded,
                  ),
                  SizedBox(height: 12),
                  // Campo editável para Montante
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _cardColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _borderColor),
                    ),
                    child: Row(
                      children: [
                        // Símbolo do Kwanza
                        Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          child: Text(
                            'Kz',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _textSecondary,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Montante (Kz)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _textSecondary,
                                ),
                              ),
                              SizedBox(height: 4),
                              TextField(
                                controller: montanteController,
                                decoration: InputDecoration(
                                  hintText: 'Digite o valor (mínimo 500 Kz)...',
                                  hintStyle: TextStyle(
                                    color: _textSecondary,
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  errorText:
                                      _validarMontante(montanteController.text),
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _textPrimary,
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _cardColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _borderColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.receipt_rounded,
                            color: _textSecondary, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Referência',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _textSecondary,
                                ),
                              ),
                              SizedBox(height: 4),
                              if (referenciaGerada)
                                Text(
                                  _model.reference,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _textPrimary,
                                  ),
                                ),
                              if (!referenciaGerada)
                                Text(
                                  _isMontanteValido()
                                      ? 'Clique para gerar referência'
                                      : 'Insira montante mínimo de 500 Kz',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _textSecondary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (referenciaGerada)
                          IconButton(
                            icon: Icon(Icons.copy_rounded,
                                color: _primaryColor, size: 20),
                            onPressed: () => _copiarReferencia(context),
                          ),
                        IconButton(
                          icon: Icon(
                            Icons
                                .refresh_rounded, // Mesmo ícone para gerar e atualizar
                            color: _isMontanteValido()
                                ? _primaryColor
                                : _textSecondary,
                            size: 20,
                          ),
                          onPressed: _isMontanteValido()
                              ? () async {
                                  await _model.generateReference(
                                      montanteController.text, setState);
                                  setState(() {
                                    referenciaGerada = true;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildInstructions(),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _model.generateReference(
                            montanteController.text, setState);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Gerar referencia'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        SizedBox(height: 6),
        Material(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label copiado!'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: _successColor,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _borderColor),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: _primaryColor),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(Icons.copy_rounded, size: 16, color: _textSecondary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Como realizar o pagamento:',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        SizedBox(height: 12),
        ...[
          'Acesse um terminal Multicaixa',
          'Selecione "Pagamento por Referência"',
          'Insira os dados fornecidos acima',
          'Confirme o valor e finalize',
          'Guarde o comprovante',
        ].map((step) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 6, color: _primaryColor),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      step,
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
