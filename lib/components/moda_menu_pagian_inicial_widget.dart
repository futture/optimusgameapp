import 'package:projeto_game_quiz/core/api/utils/token_util.dart';
import 'package:projeto_game_quiz/pages/deposit_history/deposit_history_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'moda_menu_pagian_inicial_model.dart';
export 'moda_menu_pagian_inicial_model.dart';

class ModaMenuPagianInicialWidget extends StatefulWidget {
  final bool? isMainScreen;
  const ModaMenuPagianInicialWidget({super.key, this.isMainScreen});

  @override
  State<ModaMenuPagianInicialWidget> createState() =>
      _ModaMenuPagianInicialWidgetState();
}

class _ModaMenuPagianInicialWidgetState
    extends State<ModaMenuPagianInicialWidget> {
  late ModaMenuPagianInicialModel _model;

  // Cores premium
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _cardColor = Colors.white;
  final Color _textPrimary = Color(0xFF1E293B);
  final Color _textSecondary = Color(0xFF64748B);
  final Color _borderColor = Color(0xFFE2E8F0);
  final Color _successColor = Color(0xFF10B981);
  final Color _errorColor = Color(0xFFEF4444);
  final Color _infoColor = Color(0xFF3B82F6);

  final LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModaMenuPagianInicialModel());
    _model.getUserIdAsync();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final screenWidth = MediaQuery.of(context).size.width;

    // Aumentando a largura do menu
    final dialogWidth = isMobile ? screenWidth * 0.88 : 440.0;

    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(isMobile ? 16.0 : 20.0),
          border: Border.all(
            color: _borderColor.withOpacity(0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30.0,
              offset: Offset(0.0, 10.0),
              spreadRadius: -5.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header FIXO - não rola com o conteúdo
            Container(
              padding: EdgeInsets.all(isMobile ? 20.0 : 24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFEC8D0D),
                    Color(0xFFF59E0B),
                    Color(0xFFFBBF24),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMobile ? 16.0 : 20.0),
                  topRight: Radius.circular(isMobile ? 16.0 : 20.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Menu Principal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 20.0 : 22.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Navegação rápida',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: isMobile ? 13.0 : 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Container(
                    width: isMobile ? 44.0 : 48.0,
                    height: isMobile ? 44.0 : 48.0,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        onTap: () => context.safePop(),
                        child: Center(
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: isMobile ? 20.0 : 22.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Conteúdo rolável (APENAS o conteúdo, não o header)
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: isMobile ? 8.0 : 12.0),

                      // Menu items - NÃO fecha o menu, navega diretamente
                      _buildMenuItem(
                        icon: Icons.person_rounded,
                        text: 'Meu Perfil',
                        description: 'Gerencie suas informações pessoais',
                        gradient: LinearGradient(
                          colors: [_infoColor, Color(0xFF60A5FA)],
                        ),
                        iconColor: Colors.white,
                        onTap: () =>
                            context.pushNamed(Tela04PerfilWidget.routeName),
                        isMobile: isMobile,
                      ),
                      SizedBox(height: isMobile ? 12.0 : 14.0),

                      _buildMenuItem(
                        icon: Icons.account_balance_rounded,
                        text: 'Dados Financeiros',
                        description: 'Gerencie suas informações financeiras',
                        gradient: LinearGradient(
                          colors: [_successColor, Color(0xFF34D399)],
                        ),
                        iconColor: Colors.white,
                        onTap: () =>
                            context.pushNamed(Tela07FinancasWidget.routeName),
                        isMobile: isMobile,
                      ),
                      SizedBox(height: isMobile ? 12.0 : 14.0),

                      _buildMenuItem(
                        icon: FontAwesomeIcons.wallet,
                        text: 'Carteira',
                        description: 'Gerencie seu saldo e transações',
                        gradient: LinearGradient(
                          colors: [_primaryColor, Color(0xFFF59E0B)],
                        ),
                        iconColor: Colors.white,
                        onTap: () =>
                            context.pushNamed(Tela08CarteiraWidget.routeName),
                        isMobile: isMobile,
                      ),
                      SizedBox(height: isMobile ? 12.0 : 14.0),

                      _buildMenuItem(
                        icon: Icons.sports_esports_rounded,
                        text: 'Histórico de Jogos',
                        description: 'Veja seu histórico de apostas',
                        gradient: LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                        ),
                        iconColor: Colors.white,
                        onTap: () => context
                            .pushNamed(Tela09HistoricoJodosWidget.routeName),
                        isMobile: isMobile,
                      ),
                      SizedBox(height: isMobile ? 12.0 : 14.0),

                      _buildMenuItem(
                        icon: Icons.history_toggle_off_rounded,
                        text: 'Histórico de Depósitos',
                        description: 'Acompanhe seus depósitos',
                        gradient: LinearGradient(
                          colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
                        ),
                        iconColor: Colors.white,
                        onTap: () => context
                            .pushNamed(DepositHistoryScreenWidget.routeName),
                        isMobile: isMobile,
                      ),

                      // Botão Início (condicional)
                      if (widget.isMainScreen == null) ...[
                        SizedBox(height: isMobile ? 12.0 : 14.0),
                        _buildMenuItem(
                          icon: Icons.home_rounded,
                          text: 'Página Inicial',
                          description: 'Voltar para a página principal',
                          gradient: _primaryGradient,
                          iconColor: Colors.white,
                          onTap: () => context
                              .pushNamed(Tela03PrincipalWidget.routeName),
                          isMobile: isMobile,
                        ),
                      ],

                      // Separador
                      SizedBox(height: isMobile ? 24.0 : 28.0),
                      Container(
                        height: 1.0,
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              _borderColor,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isMobile ? 24.0 : 28.0),

                      // Botão de logout - COM DIÁLOGO DE CONFIRMAÇÃO
                      _buildLogoutButton(isMobile),

                      SizedBox(height: isMobile ? 16.0 : 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required String description,
    required LinearGradient gradient,
    required Color iconColor,
    required VoidCallback onTap,
    required bool isMobile,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMobile ? 14.0 : 16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.0,
            offset: Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Material(
        color: _cardColor,
        borderRadius: BorderRadius.circular(isMobile ? 14.0 : 16.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(isMobile ? 14.0 : 16.0),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(isMobile ? 14.0 : 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isMobile ? 14.0 : 16.0),
              border: Border.all(
                color: _borderColor.withOpacity(0.5),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: isMobile ? 44.0 : 48.0,
                  height: isMobile ? 44.0 : 48.0,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(isMobile ? 12.0 : 14.0),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: isMobile ? 20.0 : 22.0,
                    ),
                  ),
                ),
                SizedBox(width: isMobile ? 12.0 : 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: isMobile ? 15.0 : 16.0,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                        ),
                      ),
                      SizedBox(height: isMobile ? 2.0 : 4.0),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: isMobile ? 12.0 : 13.0,
                          color: _textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: gradient.colors.first,
                  size: isMobile ? 14.0 : 16.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(bool isMobile) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isMobile ? 14.0 : 16.0),
          boxShadow: [
            BoxShadow(
              color: _errorColor.withOpacity(0.1),
              blurRadius: 15.0,
              offset: Offset(0.0, 5.0),
            ),
          ],
        ),
        child: Material(
          color: _cardColor,
          borderRadius: BorderRadius.circular(isMobile ? 14.0 : 16.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(isMobile ? 14.0 : 16.0),
            onTap: () => _showLogoutConfirmationDialog(context),
            child: Container(
              padding: EdgeInsets.all(isMobile ? 14.0 : 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isMobile ? 14.0 : 16.0),
                border: Border.all(
                  color: _errorColor.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: isMobile ? 44.0 : 48.0,
                    height: isMobile ? 44.0 : 48.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_errorColor, Color(0xFFEF4444)],
                      ),
                      borderRadius:
                          BorderRadius.circular(isMobile ? 12.0 : 14.0),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: isMobile ? 20.0 : 22.0,
                      ),
                    ),
                  ),
                  SizedBox(width: isMobile ? 12.0 : 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Terminar Sessão',
                          style: TextStyle(
                            fontSize: isMobile ? 15.0 : 16.0,
                            fontWeight: FontWeight.w700,
                            color: _textPrimary,
                          ),
                        ),
                        SizedBox(height: isMobile ? 2.0 : 4.0),
                        Text(
                          'Sair da sua conta atual',
                          style: TextStyle(
                            fontSize: isMobile ? 12.0 : 13.0,
                            color: _textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: _errorColor,
                    size: isMobile ? 14.0 : 16.0,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600 ? 100.0 : 20.0,
          vertical: 40.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header do diálogo
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_errorColor, Color(0xFFEF4444)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                          size: 22.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confirmar Saída',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            'Tem certeza que deseja sair?',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Conteúdo do diálogo
              Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        color: _errorColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _errorColor.withOpacity(0.2),
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: _errorColor,
                          size: 32.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Terminar Sessão?',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Você será desconectado e precisará fazer login novamente para acessar sua conta.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: _textSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 28.0),

                    // Botões de ação
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(
                                color: _borderColor,
                                width: 1.5,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(14.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14.0),
                                onTap: () async {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                  await _executeLogoutSilently(context);
                                },
                                child: Center(
                                  child: Text(
                                    'NÃO',
                                    style: TextStyle(
                                      color: _textSecondary,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_errorColor, Color(0xFFEF4444)],
                              ),
                              borderRadius: BorderRadius.circular(14.0),
                              boxShadow: [
                                BoxShadow(
                                  color: _errorColor.withOpacity(0.3),
                                  blurRadius: 15.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(14.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14.0),
                                onTap: () async {
                                  // Fecha o diálogo e o menu
                                  Navigator.pop(context); // fecha diálogo
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context); // fecha menu
                                  }

                                  // Executa logout silenciosamente
                                  await _executeLogoutSilently(context);
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 18.0,
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(
                                        'SIM',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w800,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _executeLogoutSilently(BuildContext context) async {
    // Fecha apenas diálogos e menus
    Navigator.of(context, rootNavigator: true).pop();

    // Limpa token
    await TokenUtil.removeToken();

    // Logout API (async)
    try {
      await _model.logoutAsync();
    } catch (e) {
      print('API logout error: $e');
    }

    // Navega para login, limpando toda a pilha
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Tela00LoginWidget.routeName,
        (route) => false,
      );
    });
  }
}
