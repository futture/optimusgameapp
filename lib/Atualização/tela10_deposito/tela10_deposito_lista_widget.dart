import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_game_quiz/Atualiza%C3%A7%C3%A3o/tela10_deposito/tela10_deposito_lista_model.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';
import 'package:projeto_game_quiz/pages/payment/payment_forms/payment_form.dart';
import '/flutter_flow/flutter_flow_theme.dart';
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
  // Cores premium alinhadas com o tema
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _primaryDark = Color(0xFFD17E0C);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _cardColor = Colors.white;
  final Color _textPrimary = Color(0xFF1E293B);
  final Color _textSecondary = Color(0xFF64748B);
  final Color _borderColor = Color(0xFFE2E8F0);
  final Color _successColor = Color(0xFF10B981);
  final Color _warningColor = Color(0xFFF59E0B);
  final Color _errorColor = Color(0xFFEF4444);
  final Color _infoColor = Color(0xFF3B82F6);

  // Gradientes premium
  final LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 1,
      'name': 'Multicaixa',
      'icon': Icons.credit_card_rounded,
      'description': 'Pagamento via terminal ATM',
      'available': true,
      'popular': true,
      'color': Color(0xFFEC8D0D),
      'entidade': '12345',
      'type': 'atm',
    },
    {
      'id': 2,
      'name': 'Express',
      'icon': Icons.bolt_rounded,
      'description': 'Transferência expressa',
      'available': true,
      'popular': true,
      'color': Color(0xFF3B82F6),
      'type': 'transfer',
    },
    {
      'id': 3,
      'name': 'Afrimoney',
      'icon': Icons.account_balance_wallet_rounded,
      'description': 'Carteira digital segura',
      'available': false,
      'popular': false,
      'color': Color(0xFF059669),
      'type': 'wallet',
    },
    {
      'id': 4,
      'name': 'Unitel Money',
      'icon': Icons.phone_iphone_rounded,
      'description': 'Pagamento móvel rápido',
      'available': false,
      'popular': false,
      'color': Color(0xFF8B5CF6),
      'type': 'mobile',
    },
    {
      'id': 5,
      'name': 'Africel',
      'icon': Icons.phone_rounded,
      'description': 'Solução digital completa',
      'available': false,
      'popular': false,
      'color': Color(0xFFEC4899),
      'type': 'mobile',
    },
    {
      'id': 6,
      'name': 'M-Pesa',
      'icon': Icons.money_rounded,
      'description': 'Pagamentos móveis',
      'available': false,
      'popular': false,
      'color': Color(0xFF0EA5E9),
      'type': 'mobile',
    },
  ];
  
  late Tela10DepositoListaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Inicializar o modelo
    _model = createModel(context, () => Tela10DepositoListaModel());
    _model.getUserInfoAndAccountInfoAsync(setState, context);
    
    // Inicializar animações
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
    
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final safePadding = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              // Conteúdo Principal
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Espaço para o header fixo
                      SizedBox(height: safePadding + (isMobile ? 70 : 80)),
                      
                      // Conteúdo com animação de slide
                      Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Padding(
                            padding: EdgeInsets.all(isMobile ? 16 : 20),
                            child: Column(
                              children: [
                                _buildWelcomeSection(isMobile),
                                SizedBox(height: isMobile ? 24 : 32),
                                _buildMethodsSection(isMobile),
                                SizedBox(height: isMobile ? 24 : 32),
                                _buildSecuritySection(isMobile),
                                SizedBox(height: isMobile ? 20 : 24),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Header Fixo (sem borda arredondada)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildHeader(isMobile, safePadding),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isMobile, double safePadding) {
    return Container(
      decoration: BoxDecoration(
        gradient: _primaryGradient,
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 20,
            vertical: isMobile ? 12 : 16,
          ),
          child: Row(
            children: [
              // Botão Voltar
              _buildIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: () => Navigator.pop(context),
                isMobile: isMobile,
              ),
              
              SizedBox(width: isMobile ? 12 : 16),
              
              // Título
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DEPOSITAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Escolha o método de pagamento',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: isMobile ? 13 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Ícone de ajuda
              _buildIconButton(
                icon: Icons.help_outline_rounded,
                onPressed: _showHelpDialog,
                isMobile: isMobile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isMobile,
  }) {
    return Container(
      width: isMobile ? 44 : 48,
      height: isMobile ? 44 : 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
              size: isMobile ? 20 : 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        gradient: _cardGradient,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(
          color: _borderColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ícone e título
          Row(
            children: [
              Container(
                width: isMobile ? 52 : 60,
                height: isMobile ? 52 : 60,
                decoration: BoxDecoration(
                  gradient: _primaryGradient,
                  borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.25),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.white,
                    size: isMobile ? 26 : 30,
                  ),
                ),
              ),
              SizedBox(width: isMobile ? 16 : 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adicionar Fundos',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 22,
                        fontWeight: FontWeight.w800,
                        color: _textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Depósito rápido e seguro',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 15,
                        color: _textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: isMobile ? 20 : 24),
          
          // Descrição
          Text(
            'Selecione uma das opções abaixo para adicionar saldo à sua conta. '
            'Todas as transações são processadas instantaneamente com segurança garantida.',
            style: TextStyle(
              color: _textSecondary,
              fontSize: isMobile ? 15 : 16,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
          
          SizedBox(height: isMobile ? 20 : 24),
          
          // Features em linha
          _buildFeaturesRow(isMobile),
        ],
      ),
    );
  }

  Widget _buildFeaturesRow(bool isMobile) {
    final features = [
      {
        'icon': Icons.shield_rounded,
        'label': 'Seguro',
        'color': _successColor,
      },
      {
        'icon': Icons.bolt_rounded,
        'label': 'Instantâneo',
        'color': _warningColor,
      },
      {
        'icon': Icons.money,
        'label': 'Sem taxas',
        'color': _infoColor,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: features.map((feature) {
        return Column(
          children: [
            Container(
              width: isMobile ? 56 : 64,
              height: isMobile ? 56 : 64,
              decoration: BoxDecoration(
                color: (feature['color'] as Color?)?.withOpacity(0.08) ?? Colors.transparent,
                borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
                border: Border.all(
                  color: (feature['color'] as Color?)?.withOpacity(0.15) ?? Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  feature['icon'] as IconData?,
                  color: feature['color'] as Color?,
                  size: isMobile ? 24 : 26,
                ),
              ),
            ),
            SizedBox(height: isMobile ? 8 : 10),
            Text(
              feature['label'] as String,
              style: TextStyle(
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w600,
                color: _textSecondary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMethodsSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título da seção
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: _primaryGradient,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Métodos de Pagamento',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 22,
                        fontWeight: FontWeight.w800,
                        color: _textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Escolha a forma mais conveniente para você',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 15,
                    color: _textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: isMobile ? 24 : 32),
        
        // Grid de métodos
        isMobile
            ? _buildMobileMethodsGrid()
            : _buildDesktopMethodsGrid(),
      ],
    );
  }

  Widget _buildMobileMethodsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _paymentMethods.length,
      itemBuilder: (context, index) => _buildMethodCard(index, true),
    );
  }

  Widget _buildDesktopMethodsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.9,
      ),
      itemCount: _paymentMethods.length,
      itemBuilder: (context, index) => _buildMethodCard(index, false),
    );
  }

  Widget _buildMethodCard(int index, bool isMobile) {
    final method = _paymentMethods[index];
    final isAvailable = method['available'] as bool;
    final isPopular = method['popular'] as bool;
    final color = method['color'] as Color;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: _cardColor,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 18),
        child: InkWell(
          borderRadius: BorderRadius.circular(isMobile ? 16 : 18),
          onTap: isAvailable
              ? () => _showPaymentDialog(context, method)
              : null,
          splashColor: color.withOpacity(0.1),
          highlightColor: color.withOpacity(0.05),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isMobile ? 16 : 18),
              border: Border.all(
                color: isAvailable
                    ? _borderColor.withOpacity(0.6)
                    : _borderColor.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com ícone e badge popular
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: isMobile ? 48 : 56,
                      height: isMobile ? 48 : 56,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
                        border: Border.all(
                          color: color.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          method['icon'],
                          color: isAvailable ? color : _textSecondary.withOpacity(0.4),
                          size: isMobile ? 24 : 26,
                        ),
                      ),
                    ),
                    if (isPopular && isAvailable)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 10 : 12,
                          vertical: isMobile ? 5 : 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: _primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: isMobile ? 12 : 13,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'POPULAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 10 : 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                
                SizedBox(height: isMobile ? 16 : 20),
                
                // Nome do método
                Text(
                  method['name'],
                  style: TextStyle(
                    fontSize: isMobile ? 17 : 18,
                    fontWeight: FontWeight.w800,
                    color: isAvailable ? _textPrimary : _textSecondary.withOpacity(0.6),
                    letterSpacing: -0.3,
                  ),
                ),
                
                SizedBox(height: isMobile ? 6 : 8),
                
                // Descrição
                Expanded(
                  child: Text(
                    method['description'],
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 14,
                      color: isAvailable
                          ? _textSecondary
                          : _textSecondary.withOpacity(0.5),
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                SizedBox(height: isMobile ? 16 : 20),
                
                // Botão de ação
                Container(
                  width: double.infinity,
                  height: isMobile ? 42 : 46,
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? color.withOpacity(0.08)
                        : _backgroundColor,
                    borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                    border: Border.all(
                      color: isAvailable
                          ? color.withOpacity(0.3)
                          : _borderColor,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isAvailable ? 'SELECIONAR' : 'EM BREVE',
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        fontWeight: FontWeight.w700,
                        color: isAvailable ? color : _textSecondary.withOpacity(0.6),
                        letterSpacing: 0.5,
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

  Widget _buildSecuritySection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _successColor.withOpacity(0.03),
            _successColor.withOpacity(0.01),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(
          color: _successColor.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 64 : 72,
            height: isMobile ? 64 : 72,
            decoration: BoxDecoration(
              color: _successColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: _successColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.verified_user_rounded,
                color: _successColor,
                size: isMobile ? 30 : 34,
              ),
            ),
          ),
          SizedBox(width: isMobile ? 20 : 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Segurança Garantida',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.w800,
                    color: _textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 10),
                Text(
                  'Todas as transações são criptografadas e monitoradas 24/7. '
                  'Seus dados financeiros estão protegidos com as mais avançadas tecnologias de segurança.',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 15,
                    color: _textSecondary,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 4),
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
                        // Ícone
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: _primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.help_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        
                        // Título
                        Text(
                          'Central de Ajuda',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: _textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 12),
                        
                        // Descrição
                        Text(
                          'Tire suas dúvidas sobre depósitos e formas de pagamento.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: _textSecondary,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 32),
                        
                        // Opções de contato
                        _buildContactOption(
                          icon: Icons.phone_in_talk_rounded,
                          title: 'Suporte Telefônico',
                          subtitle: '+244 923 456 789',
                          color: _successColor,
                        ),
                        SizedBox(height: 16),
                        _buildContactOption(
                          icon: Icons.email_rounded,
                          title: 'Email',
                          subtitle: 'suporte@gamequiz.ao',
                          color: _infoColor,
                        ),
                        SizedBox(height: 16),
                        _buildContactOption(
                          icon: Icons.chat_bubble_rounded,
                          title: 'Chat Online',
                          subtitle: 'Resposta em até 5 minutos',
                          color: _primaryColor,
                        ),
                        
                        SizedBox(height: 40),
                        
                        // Botão de fechar
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: _primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: _primaryColor.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => Navigator.pop(context),
                              child: Center(
                                child: Text(
                                  'ENTENDI',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
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
        color: color.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Implementar ação de contato
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
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
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: _textSecondary,
                          fontWeight: FontWeight.w400,
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
      _showMulticaixaInfo(context, method);
    } else {
      _showPaymentForm(context, method);
    }
  }

  void _showPaymentForm(BuildContext context, Map<String, dynamic> method) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600 ? 100 : 20,
          vertical: 40,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header do dialog
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: _primaryGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        method['name'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
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
    );
  }

  void _showMulticaixaInfo(BuildContext context, Map<String, dynamic> method) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          // Variáveis locais para este dialog
          TextEditingController montanteController = TextEditingController();
          bool referenciaGerada = false;
          String referencia = '';
          
          // Funções auxiliares
          String gerarReferenciaAleatoria() {
            final random = Random();
            return List.generate(9, (_) => random.nextInt(10)).join();
          }
          
          String? _validarMontante(String value) {
            if (value.isEmpty) {
              return 'Insira o montante';
            }
            String valorSemFormatacao = value.replaceAll(RegExp(r'[^\d]'), '');
            if (valorSemFormatacao.isEmpty) {
              return 'Valor inválido';
            }
            final valor = double.parse(valorSemFormatacao) / 100;
            
            if (valor < 500.0) {
              return 'Mínimo 500,00 Kz';
            }
            return null;
          }
          
          void _copiarReferencia(BuildContext context) {
            if (referencia.isNotEmpty) {
              Clipboard.setData(ClipboardData(text: referencia));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Referência copiada!'),
                  backgroundColor: _successColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
          
          String _formatarMontante(String value) {
            if (value.isEmpty) return '';
            String cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
            if (cleaned.isEmpty) return '';
            double number = double.parse(cleaned) / 100;
            String formatted = number.toStringAsFixed(2);
            List<String> parts = formatted.split('.');
            String integerPart = parts[0];
            String decimalPart = parts.length > 1 ? parts[1] : '00';
            
            String formattedInteger = '';
            for (int i = integerPart.length - 1, j = 0; i >= 0; i--, j++) {
              if (j > 0 && j % 3 == 0) {
                formattedInteger = '.$formattedInteger';
              }
              formattedInteger = integerPart[i] + formattedInteger;
            }
            
            return '$formattedInteger,$decimalPart';
          }
          
          bool _isMontanteValido() {
            if (montanteController.text.isEmpty) return false;
            String valorSemFormatacao =
                montanteController.text.replaceAll(RegExp(r'[^\d]'), '');
            if (valorSemFormatacao.isEmpty) return false;
            final valor = double.parse(valorSemFormatacao) / 100;
            return valor >= 500.0;
          }
          
          void _clearReferenceIfAmountEmpty(String value) { 
            String valorSemFormatacao = value.replaceAll(RegExp(r'[^\d]'), '');
            if (valorSemFormatacao.isEmpty && referenciaGerada) {
              referencia = '';
              referenciaGerada = false;
            }
          }
          
          void _applyAmountFormatting() {
            final formattedValue = _formatarMontante(montanteController.text);
            if (formattedValue != montanteController.text) {
              montanteController.text = formattedValue;
              montanteController.selection = TextSelection.collapsed(
                offset: formattedValue.length,
              );
            }
          }
          
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            insetPadding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 600 ? 100 : 20,
              vertical: 40,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header do dialog
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: _primaryGradient,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.close_rounded, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            method['name'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Entidade
                          _buildCopyableField(
                            label: 'Entidade',
                            value: method['entidade'] ?? '12345',
                            icon: Icons.account_balance_rounded,
                            showCopyButton: true,
                          ),
                          SizedBox(height: 16),
                          
                          // Montante (campo editável)
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _backgroundColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _borderColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.attach_money_rounded, 
                                        color: _primaryColor, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Montante (Kz)',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                TextField(
                                  controller: montanteController,
                                  decoration: InputDecoration(
                                    hintText: 'Ex: 500,00',
                                    hintStyle: TextStyle(
                                      color: _textSecondary.withOpacity(0.6),
                                    ),
                                    border: InputBorder.none,
                                    errorText: _validarMontante(montanteController.text),
                                    errorStyle: TextStyle(
                                      color: _errorColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: _textPrimary,
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      if (newValue.text.isEmpty) {
                                        return newValue;
                                      }
                                      String formattedValue =
                                          _formatarMontante(newValue.text);
                                      return TextEditingValue(
                                        text: formattedValue,
                                        selection: TextSelection.collapsed(
                                          offset: formattedValue.length,
                                        ),
                                      );
                                    }),
                                  ],
                                  onChanged: (value) {
                                    _clearReferenceIfAmountEmpty(value);
                                    setState(() {});
                                  },
                                  onEditingComplete: () {
                                    _applyAmountFormatting();
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          
                          // Referência
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _backgroundColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _borderColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.receipt_long_rounded,
                                        color: _primaryColor, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Referência',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: referenciaGerada
                                          ? Text(
                                              referencia,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                                color: _textPrimary,
                                                letterSpacing: 0.5,
                                              ),
                                            )
                                          : Text(
                                              _isMontanteValido()
                                                  ? 'Clique para gerar referência'
                                                  : 'Insira montante mínimo de 500,00 Kz',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: _textSecondary.withOpacity(0.6),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                    ),
                                    SizedBox(width: 12),
                                    Row(
                                      children: [
                                        if (referenciaGerada)
                                          Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: _primaryColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(12),
                                              child: InkWell(
                                                borderRadius: BorderRadius.circular(12),
                                                onTap: () => _copiarReferencia(context),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.copy_rounded,
                                                    color: _primaryColor,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        SizedBox(width: 8),
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: _isMontanteValido()
                                                ? _primaryColor.withOpacity(0.1)
                                                : _borderColor.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(12),
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(12),
                                              onTap: _isMontanteValido()
                                                  ? () {
                                                      setState(() {
                                                        referencia = gerarReferenciaAleatoria();
                                                        referenciaGerada = true;
                                                      });
                                                    }
                                                  : null,
                                              child: Center(
                                                child: Icon(
                                                  Icons.refresh_rounded,
                                                  color: _isMontanteValido()
                                                      ? _primaryColor
                                                      : _textSecondary.withOpacity(0.3),
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // Aviso mínimo
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: _primaryColor,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Valor mínimo: 500,00 Kz',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 32),
                          
                          // Instruções
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _primaryColor.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _primaryColor.withOpacity(0.1),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: _primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.info_outline_rounded,
                                          color: _primaryColor,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Como pagar:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: _textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                ...[
                                  '1. Aceda ao terminal Multicaixa',
                                  '2. Selecione "Pagamentos"',
                                  '3. Insira a entidade e referência',
                                  '4. Confirme o montante exato',
                                  '5. Finalize e guarde o comprovante',
                                ].map((step) => Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 6,
                                        color: _primaryColor,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          step,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: _textSecondary,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 24),
                          
                          // Botão de fechar
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: _primaryGradient,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: _primaryColor.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => Navigator.pop(context),
                                child: Center(
                                  child: Text(
                                    'FECHAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  // Widget auxiliar para campos copiáveis
  Widget _buildCopyableField({
    required String label,
    required String value,
    required IconData icon,
    required bool showCopyButton,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (showCopyButton)
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: value));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$label copiado!'),
                            backgroundColor: _successColor,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Center(
                        child: Icon(
                          Icons.copy_rounded,
                          color: _primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}