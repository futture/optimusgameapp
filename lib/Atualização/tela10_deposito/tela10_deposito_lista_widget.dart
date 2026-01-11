import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_game_quiz/Atualiza%C3%A7%C3%A3o/tela10_deposito/tela10_deposito_lista_model.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';
import 'package:projeto_game_quiz/pages/payment/payment_forms/payment_form.dart';
import '/flutter_flow/flutter_flow_util.dart';

class Tela10DepositoListaWidget extends StatefulWidget {
  const Tela10DepositoListaWidget({super.key});

  static String routeName = 'Tela10DepositoLista';
  static String routePath = '/tela10DepositoLista';

  @override
  State<Tela10DepositoListaWidget> createState() =>
      _Tela10DepositoListaWidgetState();
}

class _Tela10DepositoListaWidgetState extends State<Tela10DepositoListaWidget>
    with TickerProviderStateMixin {
  final Color _primaryColor = Color(0xFFEC8D0D); 
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _cardColor = Colors.white;
  final Color _textPrimary = Color(0xFF111827);
  final Color _textSecondary = Color(0xFF6B7280);
  final Color _borderColor = Color(0xFFE5E7EB);
  final Color _successColor = Color(0xFF10B981);
  final Color _warningColor = Color(0xFFF59E0B); 
  final Color _infoColor = Color(0xFF3B82F6);

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 1,
      'name': 'Multicaixa',
      'description': 'Pagamento via terminal ATM',
      'available': true,
      'popular': true,
      'color': Color(0xFFEC8D0D),
      'image': 'multicaixa',
      'imageType': 'asset',
      'entidade': '11454',
      'type': 'atm',
      'iconData': Icons.atm_rounded,
      'brandColor': Color(0xFFEC8D0D),
      'minAmount': 500.0,
      'maxAmount': 1000000.0,
    },
    {
      'id': 2,
      'name': 'Express',
      'description': 'Transferência expressa',
      'available': true,
      'popular': true,
      'color': Color(0xFF3B82F6),
      'image': 'express',
      'imageType': 'asset',
      'type': 'transfer',
      'iconData': Icons.bolt_rounded,
      'brandColor': Color(0xFF3B82F6),
      'minAmount': 100.0,
      'maxAmount': 500000.0,
    },
    {
      'id': 3,
      'name': 'Afrimoney',
      'description': 'Carteira digital segura',
      'available': false,
      'popular': false,
      'color': Color(0xFF059669),
      'image': 'afrimoney',
      'imageType': 'asset',
      'type': 'wallet',
      'iconData': Icons.account_balance_wallet_rounded,
      'brandColor': Color(0xFF059669),
      'minAmount': 50.0,
      'maxAmount': 100000.0,
    },
    {
      'id': 4,
      'name': 'Unitel Money',
      'description': 'Pagamento móvel rápido',
      'available': false,
      'popular': false,
      'color': Color(0xFF8B5CF6),
      'image': 'unitel_money',
      'imageType': 'asset',
      'type': 'mobile',
      'iconData': Icons.phone_iphone_rounded,
      'brandColor': Color(0xFF8B5CF6),
      'minAmount': 50.0,
      'maxAmount': 50000.0,
    },
    {
      'id': 5,
      'name': 'Africel',
      'description': 'Solução digital completa',
      'available': false,
      'popular': false,
      'color': Color(0xFFEC4899),
      'image': 'africel',
      'imageType': 'asset',
      'type': 'mobile',
      'iconData': Icons.phone_rounded,
      'brandColor': Color(0xFFEC4899),
      'minAmount': 50.0,
      'maxAmount': 50000.0,
    },
    {
      'id': 6,
      'name': 'M-Pesa',
      'description': 'Pagamentos móveis',
      'available': false,
      'popular': false,
      'color': Color(0xFF0EA5E9),
      'image': 'mpesa',
      'imageType': 'asset',
      'type': 'mobile',
      'iconData': Icons.money_rounded,
      'brandColor': Color(0xFF0EA5E9),
      'minAmount': 10.0,
      'maxAmount': 100000.0,
    },
  ];

  late Tela10DepositoListaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => Tela10DepositoListaModel());
    _model.getUserInfoAndAccountInfoAsync(setState, context);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    Future.delayed(Duration(milliseconds: 150), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;
    final safePadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              children: [
                _buildBackgroundElements(),
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: safePadding + (isMobile ? 85 : 95)),
                        Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 16 : 24,
                                vertical: 16,
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 1200,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: isMobile ? 24 : 32),
                                    _buildMethodsSection(context),
                                    SizedBox(height: isMobile ? 24 : 32),
                                    _buildSecuritySection(isMobile),
                                    SizedBox(height: isMobile ? 24 : 32),
                                    _buildFAQSection(isMobile),
                                    SizedBox(height: isMobile ? 16 : 24),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildHeader(isMobile, safePadding),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return Positioned.fill(
      child: Column(
        children: [
          Container(
            height: 350,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _primaryColor.withOpacity(0.1),
                  _primaryColor.withOpacity(0.03),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: _backgroundColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile, double safePadding) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFEC8D0D),
            Color(0xFFF59E0B),
            Color(0xFFFBBF24),
          ],
          stops: [0.0, 0.7, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 25,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 32,
            vertical: isMobile ? 16 : 20,
          ),
          child: Row(
            children: [
              _buildHeaderButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: () => Navigator.pop(context),
                isMobile: isMobile,
              ),
              SizedBox(width: isMobile ? 16 : 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DEPOSITAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 22 : 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Escolha o método de pagamento',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: isMobile ? 13 : 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildHeaderButton(
                icon: Icons.help_outline_rounded,
                onPressed: _showHelpDialog,
                isMobile: isMobile,
                badge: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isMobile,
    bool badge = false,
  }) {
    return Stack(
      children: [
        Container(
          width: isMobile ? 48 : 56,
          height: isMobile ? 48 : 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onPressed,
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isMobile ? 22 : 24,
                ),
              ),
            ),
          ),
        ),
        if (badge)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWelcomeSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(
          color: _borderColor.withOpacity(0.7),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ), 
    );
  } 
  Widget _buildMethodsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Métodos Disponíveis',
          style: TextStyle(
            fontSize: screenWidth < 600 ? 20 : 24,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Escolha a forma mais conveniente para você',
          style: TextStyle(
            fontSize: screenWidth < 600 ? 14 : 16,
            color: _textSecondary,
          ),
        ),
        SizedBox(height: screenWidth < 600 ? 20 : 28),

        // Grid responsivo - ESTILO DA ÚLTIMA VERSÃO
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            int crossAxisCount;

            if (width < 600) {
              crossAxisCount = 1;
            } else if (width < 900) {
              crossAxisCount = 2;
            } else if (width < 1200) {
              crossAxisCount = 3;
            } else {
              crossAxisCount = 4;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: crossAxisCount == 1 ? 2.8 : 1.1,
              ),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                return crossAxisCount == 1
                    ? _buildMethodRow(index)
                    : _buildMethodCard(index);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMethodRow(int index) {
    final method = _paymentMethods[index];
    final isAvailable = method['available'] as bool;
    final isPopular = method['popular'] as bool;
    final color = method['color'] as Color;

    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isAvailable ? () => _showPaymentDialog(context, method) : null,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color:
                        isAvailable ? color.withOpacity(0.1) : _backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          isAvailable ? color.withOpacity(0.2) : _borderColor,
                    ),
                  ),
                  child: Center(
                    child: _buildPaymentMethodIcon(method, 28),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              method['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color:
                                    isAvailable ? _textPrimary : _textSecondary,
                              ),
                            ),
                          ),
                          if (isPopular && isAvailable)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Popular',
                                style: TextStyle(
                                  color: _primaryColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        method['description'],
                        style: TextStyle(
                          fontSize: 13,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        isAvailable ? color.withOpacity(0.1) : _backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isAvailable ? color.withOpacity(0.3) : _borderColor,
                    ),
                  ),
                  child: Text(
                    isAvailable ? 'Selecionar' : 'Em breve',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isAvailable ? color : _textSecondary,
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

  Widget _buildMethodCard(int index) {
    final method = _paymentMethods[index];
    final isAvailable = method['available'] as bool;
    final isPopular = method['popular'] as bool;
    final color = method['color'] as Color;

    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isAvailable ? () => _showPaymentDialog(context, method) : null,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? color.withOpacity(0.1)
                            : _backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isAvailable
                              ? color.withOpacity(0.2)
                              : _borderColor,
                        ),
                      ),
                      child: Center(
                        child: _buildPaymentMethodIcon(method, 24),
                      ),
                    ),
                    if (isPopular && isAvailable)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Popular',
                          style: TextStyle(
                            color: _primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  method['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isAvailable ? _textPrimary : _textSecondary,
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: Text(
                    method['description'],
                    style: TextStyle(
                      fontSize: 13,
                      color: _textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color:
                        isAvailable ? color.withOpacity(0.1) : _backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isAvailable ? color.withOpacity(0.3) : _borderColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isAvailable ? 'Selecionar' : 'Em breve',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isAvailable ? color : _textSecondary,
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

  Widget _buildPaymentMethodIcon(Map<String, dynamic> method, double iconSize) {
    final isAvailable = method['available'] as bool;
    final color = method['color'] as Color;

    try {
      return Image.asset(
        'assets/images/${method['image']}.png',
        width: iconSize,
        height: iconSize,
        color: isAvailable ? null : _textSecondary.withOpacity(0.4),
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            method['iconData'] as IconData? ?? Icons.credit_card_rounded,
            color: isAvailable ? color : _textSecondary.withOpacity(0.4),
            size: iconSize,
          );
        },
      );
    } catch (e) {
      return Icon(
        method['iconData'] as IconData? ?? Icons.credit_card_rounded,
        color: isAvailable ? color : _textSecondary.withOpacity(0.4),
        size: iconSize,
      );
    }
  }

  Widget _buildSecuritySection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        color: _successColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _successColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 60 : 72,
            height: isMobile ? 60 : 72,
            decoration: BoxDecoration(
              color: _successColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: Colors.white,
              size: isMobile ? 28 : 32,
            ),
          ),
          SizedBox(width: isMobile ? 16 : 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Segurança Total Garantida',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 12),
                Text(
                  'Seus dados financeiros permanecem seguros mantendo total confidencialidade e integridade em cada operação',
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 15,
                    color: _textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(bool isMobile) {
    final faqs = [
      {
        'question': 'Quanto tempo leva para o depósito ser processado?',
        'answer':
            'A maioria dos depósitos é processada instantaneamente. Em alguns casos, pode levar de 5 a 15 minutos.',
      },
      {
        'question': 'Existem taxas para depositar?',
        'answer': 'Não cobramos taxas para depósitos.',
      },
      {
        'question': 'Qual é o valor mínimo para depósito?',
        'answer': 'O valor mínimo é 500,00 Kz',
      },
      {
        'question': 'Os meus dados estão seguros?',
        'answer':
            'Sim, utilizamos criptografia de ponta a ponta e nunca compartilhamos seus dados com terceiros.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Perguntas Frequentes',
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
          ),
        ),
        SizedBox(height: isMobile ? 16 : 24),
        ...faqs.asMap().entries.map((entry) {
          final faq = entry.value;
          final isLast = entry.key == faqs.length - 1;

          return Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              collapsedIconColor: _textSecondary,
              iconColor: _primaryColor,
              title: Text(
                faq['question']!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Text(
                    faq['answer']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: _textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  void _showHelpDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_primaryColor, Color(0xFFF59E0B)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.help_outline_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Central de Ajuda',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: _textPrimary,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Tire suas dúvidas sobre depósitos e formas de pagamento. '
                          'Nossa equipe está disponível 24/7 para ajudar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: _textSecondary,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 32),
                        _buildContactOption(
                          icon: Icons.phone_in_talk_rounded,
                          title: 'Suporte Telefônico',
                          subtitle: '+244 923 456 789',
                          color: _successColor,
                        ),
                        SizedBox(height: 12),
                        _buildContactOption(
                          icon: Icons.email_rounded,
                          title: 'Email',
                          subtitle: 'suporte@gamequiz.ao',
                          color: _infoColor,
                        ),
                        SizedBox(height: 12),
                        _buildContactOption(
                          icon: Icons.chat_bubble_rounded,
                          title: 'Chat Online',
                          subtitle: 'Resposta em até 5 minutos',
                          color: _primaryColor,
                        ),
                        SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Entendi, obrigado!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: _borderColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, Map<String, dynamic> method) {
    if (method['type'] == 'atm') {
      _showMulticaixaInfo(context);
    } else {
      _showPaymentForm(context, method);
    }
  }

  void _showPaymentForm(BuildContext context, Map<String, dynamic> method) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600 ? 100 : 16,
          vertical: 16,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            maxWidth: 600,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: method['color'] as Color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_rounded),
                        color: Colors.white,
                        iconSize: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method['name'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              method['description'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: _buildPaymentMethodIcon(method, 24),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(24),
                    child: PaymentForm(method: method['name']),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMulticaixaInfo(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false,
      builder: (context) => MulticaixaDialog(model: _model),
    );
  }
}

// ======================================================================
// CLASSE MULTICAIXA DIALOG (MANTIDA COM MELHORIAS DE DESIGN)
// ======================================================================

class MulticaixaDialog extends StatefulWidget {
  final Tela10DepositoListaModel model;

  const MulticaixaDialog({Key? key, required this.model}) : super(key: key);

  @override
  _MulticaixaDialogState createState() => _MulticaixaDialogState();
}

class _MulticaixaDialogState extends State<MulticaixaDialog> {
  final TextEditingController _montanteController = TextEditingController();
  final FocusNode _montanteFocusNode = FocusNode();
  bool _referenciaGerada = false;
  bool _isLoading = false;
  String _mensagemStatus = '';
  bool _mostrarMensagem = false;
  Color _corMensagem = Colors.transparent;
  Timer? _timerMensagem;

  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _cardColor = Colors.white;
  final Color _textPrimary = Color(0xFF111827);
  final Color _textSecondary = Color(0xFF6B7280);
  final Color _borderColor = Color(0xFFE5E7EB);
  final Color _successColor = Color(0xFF10B981);
  final Color _errorColor = Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    _montanteController.addListener(_onMontanteChanged);
    _montanteFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _montanteController.removeListener(_onMontanteChanged);
    _montanteController.dispose();
    _montanteFocusNode.dispose();
    _timerMensagem?.cancel();
    super.dispose();
  }

  void _onMontanteChanged() {
    setState(() {
      _mostrarMensagem = false;
      _timerMensagem?.cancel();
    });
  }

  bool _isMontanteValido() {
    if (_montanteController.text.isEmpty) return false;
    final valor =
        double.tryParse(_montanteController.text.replaceAll(',', '.'));
    return valor != null && valor >= 500;
  }

  String? _validarMontante(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira o montante';
    }
    final valor = double.tryParse(value.replaceAll(',', '.'));
    if (valor == null) return 'Valor inválido';
    if (valor < 500) return 'Mínimo 500 Kz';
    if (valor > 1000000) return 'Máximo 1.000.000 Kz';
    return null;
  }

  void _mostrarMensagemTemporaria(String mensagem, Color cor) {
    _timerMensagem?.cancel();

    setState(() {
      _mensagemStatus = mensagem;
      _corMensagem = cor;
      _mostrarMensagem = true;
    });

    _timerMensagem = Timer(Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _mostrarMensagem = false);
      }
    });
  }

  Future<void> _gerarReferencia() async {
    if (!_isMontanteValido() || _isLoading) return;

    _montanteFocusNode.unfocus();

    setState(() {
      _isLoading = true;
      _mostrarMensagem = false;
    });

    try {
      final result = await widget.model.generateReference(
        _montanteController.text,
        () {
          setState(() => _referenciaGerada = widget.model.reference.isNotEmpty);
        },
        context,
      );

      if (result != null && result["isSuccess"] == true) {
        setState(() {
          _referenciaGerada = true;
          _isLoading = false;
        });

        _mostrarMensagemTemporaria(
          'Referência gerada com sucesso!',
          _successColor,
        );
      } else if (result != null && result["isSuccess"] == false) {
        setState(() => _isLoading = false);

        final error = result["error"];
        final message =
            error?['detail']?['message'] ?? "Falha ao gerar referência";
        final details = error?['detail']?['details'] ?? "";

        _mostrarMensagemTemporaria(
          '$message${details.isNotEmpty ? ' — $details' : ''}',
          _errorColor,
        );
      }
    } catch (e) {
      print('Erro: $e');
      setState(() => _isLoading = false);
      _mostrarMensagemTemporaria('Erro inesperado', _errorColor);
    }
  }

  void _copiarReferencia() {
    if (widget.model.reference.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: widget.model.reference));
      _mostrarMensagemTemporaria('Referência copiada', _primaryColor);
    }
  }

  void _copiarEntidade() {
    Clipboard.setData(ClipboardData(text: '11454'));
    _mostrarMensagemTemporaria('Entidade copiada', _primaryColor);
  }

  void _copiarTudo() {
    if (widget.model.reference.isNotEmpty &&
        _montanteController.text.isNotEmpty) {
      String tudo =
          'Entidade: 11454\nReferência: ${widget.model.reference}\nValor: Kz ${_montanteController.text}';
      Clipboard.setData(ClipboardData(text: tudo));
      _mostrarMensagemTemporaria('Todos dados copiados', _primaryColor);
    }
  }

  void _limparFormulario() {
    _montanteController.clear();
    setState(() {
      _referenciaGerada = false;
      _mostrarMensagem = false;
    });
    _montanteFocusNode.requestFocus();
    _timerMensagem?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 24,
        vertical: 16,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: 500,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child:
                              Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Multicaixa',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Pagamento por referência',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.atm,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_mostrarMensagem)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  color: _corMensagem.withOpacity(0.1),
                  child: Row(
                    children: [
                      Icon(
                        _corMensagem == _successColor
                            ? Icons.check_circle
                            : Icons.error,
                        color: _corMensagem,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _mensagemStatus,
                          style: TextStyle(
                            color: _textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() => _mostrarMensagem = false);
                          _timerMensagem?.cancel();
                        },
                        child:
                            Icon(Icons.close, size: 20, color: _textSecondary),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildInfoCard(
                        title: 'Entidade',
                        value: '11454',
                        description: 'Código da empresa',
                        onCopy: _copiarEntidade,
                      ),
                      SizedBox(height: 16),
                      _buildAmountCard(),
                      SizedBox(height: 16),
                      _buildReferenceCard(),
                      SizedBox(height: 20),
                      _buildMainActionButtons(),
                      if (_referenciaGerada) ...[
                        SizedBox(height: 16),
                        _buildCopyAllButton(),
                      ],
                      SizedBox(height: 20),
                      if (_referenciaGerada) _buildInstructionsCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required String description,
    required VoidCallback onCopy,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _primaryColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onCopy,
                icon: Icon(Icons.copy, color: _primaryColor, size: 20),
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Montante',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: _montanteController,
            focusNode: _montanteFocusNode,
            decoration: InputDecoration(
              hintText: 'Ex: 1000',
              hintStyle: TextStyle(color: _textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _primaryColor),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              prefixText: 'Kz ',
              prefixStyle: TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              errorText: _validarMontante(_montanteController.text),
              errorStyle: TextStyle(fontSize: 12, color: _errorColor),
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) =>
                _isMontanteValido() ? _gerarReferencia() : null,
          ),
          SizedBox(height: 8),
          Text(
            'Mínimo: 500,00 Kz',
            style: TextStyle(fontSize: 12, color: _textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _referenciaGerada ? _successColor.withOpacity(0.3) : _borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Referência',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _referenciaGerada
                  ? _successColor.withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _referenciaGerada
                    ? _successColor.withOpacity(0.2)
                    : _borderColor,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_referenciaGerada &&
                          widget.model.reference.isNotEmpty)
                        Text(
                          widget.model.reference,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _successColor,
                            fontFamily: 'Monospace',
                          ),
                        ),
                      if (!_referenciaGerada || widget.model.reference.isEmpty)
                        Text(
                          'Gere uma referência primeiro',
                          style: TextStyle(
                            fontSize: 14,
                            color: _textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      if (_referenciaGerada &&
                          widget.model.reference.isNotEmpty)
                        SizedBox(height: 4),
                      if (_referenciaGerada &&
                          widget.model.reference.isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 14, color: _successColor),
                            SizedBox(width: 4),
                            Text(
                              'Válida por 24 horas',
                              style: TextStyle(
                                fontSize: 12,
                                color: _successColor,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                if (_referenciaGerada && widget.model.reference.isNotEmpty)
                  IconButton(
                    onPressed: _copiarReferencia,
                    icon: Icon(Icons.copy, color: _successColor, size: 20),
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _limparFormulario,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: _borderColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 18, color: _textSecondary),
                SizedBox(width: 8),
                Text(
                  'Limpar',
                  style: TextStyle(color: _textSecondary),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _referenciaGerada
                ? () {
                    _mostrarMensagemTemporaria(
                        'Configuração concluída', _successColor);
                    Future.delayed(Duration(seconds: 1), () {
                      if (mounted) Navigator.pop(context);
                    });
                  }
                : (_isMontanteValido() && !_isLoading)
                    ? _gerarReferencia
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _referenciaGerada ? _successColor : _primaryColor,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _referenciaGerada ? Icons.check : Icons.arrow_forward,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        _referenciaGerada ? 'OK' : 'Gerar Referência',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildCopyAllButton() {
    return OutlinedButton.icon(
      onPressed: _copiarTudo,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        side: BorderSide(color: _primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(Icons.copy_all, size: 18, color: _primaryColor),
      label: Text(
        'Copiar tudo',
        style: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Como pagar',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          SizedBox(height: 12),
          ..._buildInstructionSteps(),
        ],
      ),
    );
  }

  List<Widget> _buildInstructionSteps() {
    final steps = [
      'Acesse um terminal Multicaixa (ATM)',
      'Selecione "Pagamento por Referência"',
      'Insira os dados fornecidos acima',
      'Confirme o valor e finalize',
      'Guarde o comprovante',
    ];

    return steps.asMap().entries.map((entry) {
      final index = entry.key;
      final step = entry.value;

      return Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                step,
                style: TextStyle(
                  fontSize: 14,
                  color: _textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
