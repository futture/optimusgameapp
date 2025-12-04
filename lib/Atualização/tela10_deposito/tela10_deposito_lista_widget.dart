import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_game_quiz/Atualiza%C3%A7%C3%A3o/tela10_deposito/tela10_deposito_lista_model.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';
import 'package:projeto_game_quiz/pages/payment/payment_forms/payment_form.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

// Primeiro, adicione estas imagens na sua pasta assets:
// assets/images/payment_methods/
// - multicaixa.png
// - express.png
// - afrimoney.png
// - unitel_money.png
// - africel.png
// - mpesa.png

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

  // Métodos de pagamento com IMAGENS REAIS
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 1,
      'name': 'Multicaixa',
      'description': 'Pagamento via terminal ATM',
      'available': true,
      'popular': true,
      'color': Color(0xFFEC8D0D),
      'image': 'multicaixa', // Nome do arquivo da imagem
      'imageType': 'asset', // Tipo: asset ou icon
      'entidade': '11454',
      'type': 'atm',
      'iconData': Icons.atm_rounded, // Fallback icon
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

  // Fallback para ícones quando as imagens não estiverem disponíveis
  final Map<String, IconData> _paymentIcons = {
    'multicaixa': Icons.atm_rounded,
    'express': Icons.bolt_rounded,
    'afrimoney': Icons.account_balance_wallet_rounded,
    'unitel_money': Icons.phone_iphone_rounded,
    'africel': Icons.phone_rounded,
    'mpesa': Icons.money_rounded,
  };

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
    final isMobile = MediaQuery.of(context).size.width < 600;
    final safePadding = MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              children: [
                // Background decorative elements
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
                              padding: EdgeInsets.all(isMobile ? 18 : 24),
                              child: Column(
                                children: [
                                  _buildWelcomeSection(isMobile),
                                  SizedBox(height: isMobile ? 30 : 40),
                                  _buildMethodsSection(isMobile, width),
                                  SizedBox(height: isMobile ? 30 : 40),
                                  _buildSecuritySection(isMobile),
                                  SizedBox(height: isMobile ? 30 : 40),
                                  _buildFAQSection(isMobile),
                                  SizedBox(height: isMobile ? 24 : 32),
                                ],
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
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 24,
            vertical: isMobile ? 18 : 22,
          ),
          child: Row(
            children: [
              _buildHeaderButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: () => Navigator.pop(context),
                isMobile: isMobile,
              ),
              SizedBox(width: isMobile ? 18 : 22),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DEPOSITAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 24 : 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Escolha o método de pagamento',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: isMobile ? 14 : 15,
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
          width: isMobile ? 52 : 58,
          height: isMobile ? 52 : 58,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 15,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onPressed,
              splashColor: Colors.white.withOpacity(0.3),
              highlightColor: Colors.white.withOpacity(0.2),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isMobile ? 24 : 26,
                ),
              ),
            ),
          ),
        ),
        if (badge)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWelcomeSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(isMobile ? 22 : 28),
        border: Border.all(
          color: _borderColor.withOpacity(0.7),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 40,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 40,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: isMobile ? 72 : 84,
                height: isMobile ? 72 : 84,
                decoration: BoxDecoration(
                  gradient: _primaryGradient,
                  borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.4),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.white,
                    size: isMobile ? 36 : 42,
                  ),
                ),
              ),
              SizedBox(width: isMobile ? 22 : 28),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Adicionar ',
                            style: TextStyle(
                              fontSize: isMobile ? 26 : 30,
                              fontWeight: FontWeight.w900,
                              color: _textPrimary,
                              letterSpacing: -0.8,
                            ),
                          ),
                          TextSpan(
                            text: 'Fundos',
                            style: TextStyle(
                              fontSize: isMobile ? 26 : 30,
                              fontWeight: FontWeight.w900,
                              color: _primaryColor,
                              letterSpacing: -0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Depósito rápido, seguro e instantâneo',
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 17,
                        color: _textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 28 : 36),
          _buildFeaturesRow(isMobile),
        ],
      ),
    );
  }

  Widget _buildFeaturesRow(bool isMobile) {
    final features = [
      {
        'icon': Icons.shield_rounded,
        'label': '100% Seguro',
        'color': _successColor,
        'gradient': LinearGradient(
          colors: [_successColor, Color(0xFF34D399)],
        ),
      },
      {
        'icon': Icons.bolt_rounded,
        'label': 'Instantâneo',
        'color': _warningColor,
        'gradient': LinearGradient(
          colors: [_warningColor, Color(0xFFFBBF24)],
        ),
      },
      {
        'icon': Icons.money_off_rounded,
        'label': 'Sem taxas',
        'color': _infoColor,
        'gradient': LinearGradient(
          colors: [_infoColor, Color(0xFF60A5FA)],
        ),
      },
      {
        'icon': Icons.support_agent_rounded,
        'label': 'Suporte 24/7',
        'color': _primaryColor,
        'gradient': _primaryGradient,
      },
    ];

    return Wrap(
      spacing: isMobile ? 20 : 30,
      runSpacing: isMobile ? 20 : 30,
      alignment: WrapAlignment.spaceEvenly,
      children: features.map((feature) {
        return Column(
          children: [
            Container(
              width: isMobile ? 76 : 88,
              height: isMobile ? 76 : 88,
              decoration: BoxDecoration(
                gradient: feature['gradient'] as LinearGradient,
                borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
                boxShadow: [
                  BoxShadow(
                    color: (feature['color'] as Color).withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 20,
                    offset: Offset(0, -8),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  feature['icon'] as IconData,
                  color: Colors.white,
                  size: isMobile ? 32 : 36,
                ),
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Text(
              feature['label'] as String,
              style: TextStyle(
                fontSize: isMobile ? 13 : 15,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMethodsSection(bool isMobile, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: _primaryGradient,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Métodos Disponíveis',
                      style: TextStyle(
                        fontSize: isMobile ? 26 : 30,
                        fontWeight: FontWeight.w900,
                        color: _textPrimary,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(left: 24),
                child: Text(
                  'Escolha a forma mais conveniente para você',
                  style: TextStyle(
                    fontSize: isMobile ? 15 : 17,
                    color: _textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 32 : 40),

        // Lista responsiva de métodos
        if (isMobile)
          _buildMobileMethodsList()
        else if (width < 1100)
          _buildDesktopMethodsGrid(2)
        else if (width < 1500)
          _buildDesktopMethodsGrid(3)
        else
          _buildDesktopMethodsGrid(4),
      ],
    );
  }

  Widget _buildMobileMethodsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _paymentMethods.length,
      separatorBuilder: (context, index) => SizedBox(height: 20),
      itemBuilder: (context, index) => _buildMethodListItem(index),
    );
  }

  Widget _buildMethodListItem(int index) {
    final method = _paymentMethods[index];
    final isAvailable = method['available'] as bool;
    final isPopular = method['popular'] as bool;
    final color = method['color'] as Color;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: isAvailable ? () => _showPaymentDialog(context, method) : null,
          splashColor: color.withOpacity(0.15),
          highlightColor: color.withOpacity(0.1),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isAvailable
                    ? _borderColor.withOpacity(0.7)
                    : _borderColor.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // Imagem do método de pagamento
                _buildPaymentMethodImage(method, 68, true),
                SizedBox(width: 20),

                // Informações do método
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              method['name'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: isAvailable
                                    ? _textPrimary
                                    : _textSecondary.withOpacity(0.6),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          if (isPopular && isAvailable)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: _primaryGradient,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: _primaryColor.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.trending_up_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'POPULAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        method['description'],
                        style: TextStyle(
                          fontSize: 15,
                          color: isAvailable
                              ? _textSecondary
                              : _textSecondary.withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? color.withOpacity(0.1)
                              : _backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isAvailable
                                ? color.withOpacity(0.3)
                                : _borderColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isAvailable)
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: color,
                                  size: 18,
                                ),
                              SizedBox(width: isAvailable ? 8 : 0),
                              Text(
                                isAvailable ? 'SELECIONAR' : 'EM BREVE',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isAvailable
                                      ? color
                                      : _textSecondary.withOpacity(0.6),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopMethodsGrid(int crossAxisCount) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio:
            crossAxisCount == 2 ? 1.15 : (crossAxisCount == 3 ? 1.05 : 0.95),
      ),
      itemCount: _paymentMethods.length,
      itemBuilder: (context, index) => _buildMethodCard(index),
    );
  }

  Widget _buildMethodCard(int index) {
    final method = _paymentMethods[index];
    final isAvailable = method['available'] as bool;
    final isPopular = method['popular'] as bool;
    final color = method['color'] as Color;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: _cardColor,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: isAvailable ? () => _showPaymentDialog(context, method) : null,
          splashColor: color.withOpacity(0.15),
          highlightColor: color.withOpacity(0.1),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isAvailable
                    ? _borderColor.withOpacity(0.7)
                    : _borderColor.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho com imagem e badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPaymentMethodImage(method, 72, false),
                    if (isPopular && isAvailable)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: _primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.4),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'POPULAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 24),

                // Nome do método
                Text(
                  method['name'],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: isAvailable
                        ? _textPrimary
                        : _textSecondary.withOpacity(0.6),
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 12),

                // Descrição
                Expanded(
                  child: Text(
                    method['description'],
                    style: TextStyle(
                      fontSize: 16,
                      color: isAvailable
                          ? _textSecondary
                          : _textSecondary.withOpacity(0.5),
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Botão de ação
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color:
                        isAvailable ? color.withOpacity(0.1) : _backgroundColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color:
                          isAvailable ? color.withOpacity(0.3) : _borderColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isAvailable)
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: color,
                            size: 20,
                          ),
                        SizedBox(width: isAvailable ? 10 : 0),
                        Text(
                          isAvailable ? 'SELECIONAR' : 'EM BREVE',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isAvailable
                                ? color
                                : _textSecondary.withOpacity(0.6),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Limites (se disponível)
                if (isAvailable && method.containsKey('minAmount'))
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: color.withOpacity(0.7),
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Limite: ${method['minAmount']} - ${method['maxAmount']} Kz',
                            style: TextStyle(
                              fontSize: 12,
                              color: color.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodImage(
      Map<String, dynamic> method, double size, bool isList) {
    final color = method['color'] as Color;
    final isAvailable = method['available'] as bool;
    final imageName = method['image'] as String;
    final imageType = method['imageType'] as String;

    // Se for do tipo asset, carrega a imagem
    if (imageType == 'asset') {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: isAvailable
              ? LinearGradient(
                  colors: [
                    color.withOpacity(0.15),
                    color.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: !isAvailable ? _backgroundColor : null,
          borderRadius: BorderRadius.circular(isList ? 16 : 18),
          border: Border.all(
            color: isAvailable
                ? color.withOpacity(0.25)
                : _borderColor.withOpacity(0.4),
            width: isAvailable ? 2 : 1.5,
          ),
          boxShadow: isAvailable
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.15),
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isList ? 16 : 18),
          child: Container(
            color: Colors.white,
            child: Center(
              child: _buildPaymentMethodIcon(method, size * 0.6),
            ),
          ),
        ),
      );
    } else {
      // Fallback para ícone
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: isAvailable
              ? LinearGradient(
                  colors: [
                    color.withOpacity(0.15),
                    color.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: !isAvailable ? _backgroundColor : null,
          borderRadius: BorderRadius.circular(isList ? 16 : 18),
          border: Border.all(
            color: isAvailable
                ? color.withOpacity(0.25)
                : _borderColor.withOpacity(0.4),
            width: isAvailable ? 2 : 1.5,
          ),
          boxShadow: isAvailable
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.15),
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: _buildPaymentMethodIcon(method, size * 0.5),
        ),
      );
    }
  }

  Widget _buildPaymentMethodIcon(Map<String, dynamic> method, double iconSize) {
    final isAvailable = method['available'] as bool;
    final color = method['color'] as Color;

    // Tenta carregar a imagem do asset
    try {
      return Image.asset(
        'assets/images/${method['image']}.png',
        width: iconSize,
        height: iconSize,
        color: isAvailable ? null : _textSecondary.withOpacity(0.4),
        colorBlendMode: isAvailable ? BlendMode.srcIn : BlendMode.modulate,
        errorBuilder: (context, error, stackTrace) {
          // Fallback para ícone se a imagem não existir
          return Icon(
            method['iconData'] as IconData? ?? Icons.credit_card_rounded,
            color: isAvailable ? color : _textSecondary.withOpacity(0.4),
            size: iconSize,
          );
        },
      );
    } catch (e) {
      // Fallback para ícone se ocorrer erro
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
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _successColor.withOpacity(0.1),
            _successColor.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isMobile ? 22 : 28),
        border: Border.all(
          color: _successColor.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 76 : 88,
            height: isMobile ? 76 : 88,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_successColor, Color(0xFF10B981)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _successColor.withOpacity(0.4),
                  blurRadius: 25,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.verified_user_rounded,
                color: Colors.white,
                size: isMobile ? 36 : 42,
              ),
            ),
          ),
          SizedBox(width: isMobile ? 24 : 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Segurança Total Garantida',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.w900,
                    color: _textPrimary,
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(height: isMobile ? 14 : 18),
                Text(
                  'Seus dados financeiros permanecem seguros'
                  'mantendo total confidencialidade e integridade em cada operação',
                  style: TextStyle(
                    fontSize: isMobile ? 15 : 17,
                    color: _textSecondary,
                    height: 1.7,
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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(isMobile ? 22 : 28),
        border: Border.all(
          color: _borderColor.withOpacity(0.7),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 28,
                decoration: BoxDecoration(
                  gradient: _primaryGradient,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Perguntas Frequentes',
                style: TextStyle(
                  fontSize: isMobile ? 24 : 28,
                  fontWeight: FontWeight.w900,
                  color: _textPrimary,
                  letterSpacing: -0.8,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 24 : 32),
          ...faqs.asMap().entries.map((entry) {
            final index = entry.key;
            final faq = entry.value;

            return Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor.withOpacity(0.5)),
              ),
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                collapsedIconColor: _textSecondary,
                iconColor: _primaryColor,
                title: Text(
                  faq['question']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Text(
                      faq['answer']!,
                      style: TextStyle(
                        fontSize: 15,
                        color: _textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
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
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(36),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 50,
                offset: Offset(0, -15),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle do modal
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 8),
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: _borderColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Ícone do help
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: _primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _primaryColor.withOpacity(0.4),
                                blurRadius: 30,
                                offset: Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.live_help_rounded,
                              color: Colors.white,
                              size: 56,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Título
                        Text(
                          'Central de Ajuda',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: _textPrimary,
                            letterSpacing: -1.0,
                          ),
                        ),
                        SizedBox(height: 12),

                        // Descrição
                        Text(
                          'Tire suas dúvidas sobre depósitos e formas de pagamento. '
                          'Nossa equipe está disponível 24/7 para ajudar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: _textSecondary,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 36),

                        // Opções de contato
                        _buildContactOption(
                          icon: Icons.phone_in_talk_rounded,
                          title: 'Suporte Telefônico',
                          subtitle: '+244 923 456 789',
                          color: _successColor,
                          gradient: LinearGradient(
                            colors: [_successColor, Color(0xFF10B981)],
                          ),
                        ),
                        SizedBox(height: 16),

                        _buildContactOption(
                          icon: Icons.email_rounded,
                          title: 'Email',
                          subtitle: 'suporte@gamequiz.ao',
                          color: _infoColor,
                          gradient: LinearGradient(
                            colors: [_infoColor, Color(0xFF3B82F6)],
                          ),
                        ),
                        SizedBox(height: 16),

                        _buildContactOption(
                          icon: Icons.chat_bubble_rounded,
                          title: 'Chat Online',
                          subtitle: 'Resposta em até 5 minutos',
                          color: _primaryColor,
                          gradient: _primaryGradient,
                        ),
                        SizedBox(height: 40),

                        // Botão de fechar
                        Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: _primaryGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _primaryColor.withOpacity(0.5),
                                blurRadius: 25,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => Navigator.pop(context),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'ENTENDI, OBRIGADO!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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
    required LinearGradient gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: _cardColor,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: _textPrimary,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 15,
                          color: _textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: _borderColor,
                  size: 30,
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
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600 ? 140 : 20,
          vertical: 24, // Reduzido de 60 para 24
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height *
                0.85, // Limitar altura máxima
            minWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 50,
                  offset: Offset(0, 25),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Usar MainAxisSize.min
              children: [
                // Header compacto
                Container(
                  padding: EdgeInsets.all(20), // Reduzido de 28
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        method['color'] as Color,
                        (method['color'] as Color).withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Botão de fechar mais compacto
                      Container(
                        width: 48, // Reduzido de 56
                        height: 48, // Reduzido de 56
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
                            onTap: () => Navigator.pop(context),
                            child: Center(
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 22, // Reduzido de 26
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16), // Reduzido de 20
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method['name'],
                              style: TextStyle(
                                fontSize: 22, // Reduzido de 26
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.6, // Reduzido
                              ),
                            ),
                            SizedBox(height: 4), // Reduzido de 6
                            Text(
                              method['description'],
                              style: TextStyle(
                                fontSize: 14, // Reduzido de 15
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildPaymentMethodImage(
                          method, 48, false), // Reduzido de 56
                    ],
                  ),
                ),

                // Formulário com tamanho fixo
                Flexible(
                  fit: FlexFit.loose, // Usar Flexible em vez de Expanded
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height *
                          0.5, // Limitar altura
                    ),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(20), // Reduzido de 28
                      child: PaymentForm(method: method['name']),
                    ),
                  ),
                ),

                // Footer compacto
                Container(
                  padding: EdgeInsets.all(20), // Reduzido de 24
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    border: Border(
                      top: BorderSide(
                          color: _borderColor, width: 1.5), // Reduzido de 2
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 52, // Reduzido de 60
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(16), // Reduzido de 18
                            border: Border.all(
                                color: _borderColor, width: 1.5), // Reduzido
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8, // Reduzido de 10
                                offset: Offset(0, 4), // Reduzido de 5
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
                                  'CANCELAR',
                                  style: TextStyle(
                                    color: _textSecondary,
                                    fontSize: 15, // Reduzido de 17
                                    fontWeight:
                                        FontWeight.w700, // Reduzido de 800
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16), // Reduzido de 20
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 52, // Reduzido de 60
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                method['color'] as Color,
                                (method['color'] as Color).withOpacity(0.8),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(16), // Reduzido de 18
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (method['color'] as Color).withOpacity(0.5),
                                blurRadius: 20, // Reduzido de 25
                                offset: Offset(0, 8), // Reduzido de 10
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                // Lógica de pagamento
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lock_rounded,
                                      color: Colors.white,
                                      size: 20, // Reduzido de 24
                                    ),
                                    SizedBox(width: 8), // Reduzido de 12
                                    Text(
                                      'CONFIRMAR',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15, // Reduzido de 17
                                        fontWeight:
                                            FontWeight.w800, // Reduzido de 900
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
      barrierColor: Colors.black.withOpacity(0.8),
      barrierDismissible: false,
      builder: (context) => MulticaixaDialog(model: _model),
    );
  }
}

// ======================================================================
// CLASSE SEPARADA PARA O DIÁLOGO MULTICAIXA
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

  // Cores simplificadas
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _cardColor = Colors.white;
  final Color _textPrimary = Color(0xFF1E293B);
  final Color _textSecondary = Color(0xFF64748B);
  final Color _borderColor = Color(0xFFE2E8F0);
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
    final valor = double.tryParse(_montanteController.text.replaceAll(',', '.'));
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
        final message = error?['detail']?['message'] ?? "Falha ao gerar referência";
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
    if (widget.model.reference.isNotEmpty && _montanteController.text.isNotEmpty) {
      String tudo = 'Entidade: 11454\nReferência: ${widget.model.reference}\nValor: Kz ${_montanteController.text}';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header simples
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(Icons.close, color: Colors.white, size: 20),
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
                              fontSize: isSmallScreen ? 18 : 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Pagamento por referência',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/payment_methods/multicaixa.png',
                      width: 40,
                      height: 40,
                      color: Colors.white,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.atm,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),

              // Mensagem de status
              if (_mostrarMensagem)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: _corMensagem.withOpacity(0.1),
                  child: Row(
                    children: [
                      Icon(
                        _corMensagem == _successColor ? Icons.check_circle : Icons.error,
                        color: _corMensagem,
                        size: 18,
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
                        child: Icon(Icons.close, size: 18, color: _textSecondary),
                      ),
                    ],
                  ),
                ),

              // Conteúdo principal
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Entidade
                      _buildInfoCard(
                        title: 'Entidade',
                        value: '11454',
                        description: 'Código da empresa',
                        onCopy: _copiarEntidade,
                        icon: Icons.account_balance,
                      ),
                      SizedBox(height: 16),

                      // Montante
                      _buildAmountCard(),
                      SizedBox(height: 16),

                      // Referência
                      _buildReferenceCard(),
                      SizedBox(height: 20),

                      // Botões principais
                      _buildMainActionButtons(),

                      if (_referenciaGerada) ...[
                        SizedBox(height: 16),
                        _buildCopyAllButton(),
                      ],

                      SizedBox(height: 20),

                      // Instruções (somente quando referência gerada)
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
    required IconData icon,
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
          Row(
            children: [
              Icon(icon, color: _primaryColor, size: 20),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
            ],
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
                        fontSize: 18,
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
              SizedBox(width: 12),
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
          Row(
            children: [
              Icon(Icons.attach_money, color: _primaryColor, size: 20),
              SizedBox(width: 10),
              Text(
                'Montante',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
            ],
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
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              prefixText: 'Kz ',
              prefixStyle: TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w600,
              ),
              errorText: _validarMontante(_montanteController.text),
              errorStyle: TextStyle(fontSize: 12, color: _errorColor),
              suffixIcon: _montanteController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, size: 18, color: _textSecondary),
                      onPressed: () => _montanteController.clear(),
                      padding: EdgeInsets.zero,
                    )
                  : null,
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _isMontanteValido() ? _gerarReferencia() : null,
          ),
          SizedBox(height: 8),
          Text(
            'Mínimo: 500,00 Kz • Máximo: 1.000.000 Kz',
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
          color: _referenciaGerada ? _successColor.withOpacity(0.3) : _borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long, color: _successColor, size: 20),
              SizedBox(width: 10),
              Text(
                'Referência',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _referenciaGerada ? _successColor.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _referenciaGerada ? _successColor.withOpacity(0.2) : _borderColor,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_referenciaGerada && widget.model.reference.isNotEmpty)
                        Text(
                          widget.model.reference,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _successColor,
                            fontFamily: 'Monospace',
                          ),
                          overflow: TextOverflow.ellipsis,
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
                      if (_referenciaGerada && widget.model.reference.isNotEmpty)
                        SizedBox(height: 4),
                      if (_referenciaGerada && widget.model.reference.isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: _successColor),
                            SizedBox(width: 4),
                            Text(
                              'Válida por 24 horas',
                              style: TextStyle(
                                fontSize: 11,
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
                    _mostrarMensagemTemporaria('Configuração concluída', _successColor);
                    Future.delayed(Duration(seconds: 1), () {
                      if (mounted) Navigator.pop(context);
                    });
                  }
                : (_isMontanteValido() && !_isLoading) ? _gerarReferencia : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _referenciaGerada ? _successColor : _primaryColor,
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
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
          Row(
            children: [
              Icon(Icons.info, color: _primaryColor, size: 18),
              SizedBox(width: 8),
              Text(
                'Como pagar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
            ],
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
                  fontSize: 13,
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