import 'package:projeto_game_quiz/pages/support/support_screen.dart';
import 'package:projeto_game_quiz/pages/tela11_editar_perfil/tela11_editar_perfil_widget.dart';
import 'package:projeto_game_quiz/pages/tela12_vitoria_view/tela12_vitoria_view_widget.dart';
import 'package:projeto_game_quiz/pages/tela17_notificacao/tela17_notificacao_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'tela04_perfil_model.dart';
export 'tela04_perfil_model.dart';

class Tela04PerfilWidget extends StatefulWidget {
  const Tela04PerfilWidget({super.key});

  static String routeName = 'Tela04Perfil';
  static String routePath = '/tela04Perfil';

  @override
  State<Tela04PerfilWidget> createState() => _Tela04PerfilWidgetState();
}

class _Tela04PerfilWidgetState extends State<Tela04PerfilWidget>
    with SingleTickerProviderStateMixin {
  late Tela04PerfilModel _model;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Cores do tema premium com laranja como primária
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _primaryDark = Color(0xFFD17A0A);
  final Color _primaryLight = Color(0xFFFFA726);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);
  final Color _successColor = Color(0xFF10B981);

  // Gradientes premium
  final LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _cardGradient = LinearGradient(
    colors: [Colors.white, Color(0xFFFEF6E6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela04PerfilModel());

    // Configuração das animações
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _model.getUserInfoAndAccountInfoAsync(setState, context);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _model.dispose();
    super.dispose();
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool showArrow = true,
    Color? iconColor,
    bool isPremium = false,
    BuildContext? context,
  }) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context!).size.width > 600 ? 24.0 : 20.0,
          vertical: 6.0,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width > 600 ? 80.0 : 72.0,
              decoration: BoxDecoration(
                gradient: isPremium ? _primaryGradient : _cardGradient,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: isPremium ? Colors.transparent : _outlineColor,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 600 ? 24.0 : 20.0,
                  vertical: MediaQuery.of(context).size.width > 600 ? 20.0 : 16.0,
                ),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width > 600 ? 48.0 : 44.0,
                      height: MediaQuery.of(context).size.width > 600 ? 48.0 : 44.0,
                      decoration: BoxDecoration(
                        color: isPremium
                            ? Colors.white.withOpacity(0.2)
                            : _primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: isPremium ? Colors.white : _primaryColor,
                        size: MediaQuery.of(context).size.width > 600 ? 22.0 : 20.0,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width > 600 ? 20.0 : 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: isPremium ? Colors.white : _onSurfaceColor,
                              fontSize: MediaQuery.of(context).size.width > 600 ? 17.0 : 16.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2.0),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: isPremium
                                    ? Colors.white.withOpacity(0.8)
                                    : _onSurfaceColor.withOpacity(0.6),
                                fontSize: MediaQuery.of(context).size.width > 600 ? 13.0 : 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (showArrow)
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: isPremium
                            ? Colors.white
                            : _onSurfaceColor.withOpacity(0.5),
                        size: MediaQuery.of(context).size.width > 600 ? 18.0 : 16.0,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
    required BuildContext context,
  }) {
    final isWide = MediaQuery.of(context).size.width > 600;
    
    return Container(
      width: isWide ? 130 : 110,
      height: isWide ? 120 : 100,
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(isWide ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _outlineColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isWide ? 48 : 40,
            height: isWide ? 48 : 40,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: _primaryColor,
              size: isWide ? 24 : 20,
            ),
          ),
          SizedBox(height: isWide ? 12 : 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isWide ? 22 : 18,
              fontWeight: FontWeight.w700,
              color: _onSurfaceColor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isWide ? 14 : 12,
              fontWeight: FontWeight.w500,
              color: _onSurfaceColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final safePadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: child,
            ),
          );
        },
        child: Column(
          children: [
            // Header Premium
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: _primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 32,
                    vertical: isMobile ? 16 : 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Botão Voltar Premium
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
                            ),
                            child: IconButton(
                              onPressed: () {
                                context.safePop();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                                size: isMobile ? 20 : 22,
                              ),
                              splashRadius: isMobile ? 20 : 24,
                            ),
                          ),
                          SizedBox(width: isMobile ? 16 : 20),
                          Expanded(
                            child: Text(
                              'Meu Perfil',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 24 : 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          // Ícone de configurações
                          Container(
                            width: isMobile ? 44 : 52,
                            height: isMobile ? 44 : 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.settings_rounded,
                              color: Colors.white,
                              size: isMobile ? 22 : 24,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 8 : 12),
                      // Barra de progresso sutil
                      Container(
                        height: 2,
                        width: isMobile ? 60 : 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 800,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Seção do Perfil
                      Container(
                        margin: EdgeInsets.all(isMobile ? 20 : 32),
                        padding: EdgeInsets.all(isMobile ? 24 : 32),
                        decoration: BoxDecoration(
                          color: _surfaceColor,
                          borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: isMobile ? 80.0 : 96.0,
                              height: isMobile ? 80.0 : 96.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _primaryColor,
                                  width: isMobile ? 3.0 : 4.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _primaryColor.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(isMobile ? 40.0 : 48.0),
                                child: Image.asset(
                                  'assets/images/profile.jpeg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: _primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        color: _primaryColor,
                                        size: isMobile ? 30 : 36,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: isMobile ? 20.0 : 28.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _model.user == null
                                        ? 'Carregando...'
                                        : _model.user!.name.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: isMobile ? 20.0 : 24.0,
                                      fontWeight: FontWeight.w700,
                                      color: _onSurfaceColor,
                                      letterSpacing: -0.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: isMobile ? 6.0 : 8.0),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isMobile ? 12 : 16,
                                      vertical: isMobile ? 4 : 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _successColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                                    ),
                                    child: Text(
                                      _model.userAccountInfo == null
                                          ? "Carregando..."
                                          : '${_model.user?.phone_number}',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: isMobile ? 12.0 : 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: _successColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: isMobile ? 8.0 : 10.0),
                                  Text(
                                    '${_model.user?.email}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: isMobile ? 14.0 : 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: _onSurfaceColor.withOpacity(0.6),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Stats Cards
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 32),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final containerWidth = constraints.maxWidth;
                            final cardWidth = isMobile ? 110 : 130;
                            final spacing = isMobile ? 12 : 16;
                            final availableWidth = containerWidth - (2 * spacing);
                            
                            // Calcula quantos cards cabem na largura disponível
                            final cardsPerRow = (availableWidth / cardWidth).floor();
                            final adjustedCardWidth = availableWidth / cardsPerRow;
                            
                            return Wrap(
                              spacing: spacing.toDouble(),
                              runSpacing: spacing.toDouble(),
                              alignment: WrapAlignment.center,
                              children: [
                                SizedBox(
                                  width: adjustedCardWidth,
                                  child: _buildStatCard(
                                    value: _model.rankingMetrics == null ? '0' : _model.rankingMetrics!.totalScoreFormatted,
                                    label: 'Pontos',
                                    icon: Icons.emoji_events_rounded,
                                    context: context,
                                  ),
                                ),
                                SizedBox(
                                  width: adjustedCardWidth,
                                  child: _buildStatCard(
                                    value: _model.rankingMetrics == null ? '0' : _model.rankingMetrics!.totalWins.toString(),
                                    label: 'Vitórias',
                                    icon: Icons.workspace_premium_rounded,
                                    context: context,
                                  ),
                                ),
                                SizedBox(
                                  width: adjustedCardWidth,
                                  child: _buildStatCard(
                                    value: _model.rankingMetrics == null ? '0' : '${_model.rankingMetrics!.winRate.toStringAsFixed(0)}%',
                                    label: 'Taxa de Vitória',
                                    icon: Icons.trending_up_rounded,
                                    context: context,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      SizedBox(height: isMobile ? 24 : 32),

                      // Seção CONTA
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 24.0 : 32.0,
                        ),
                        child: Text(
                          'MINHA CONTA',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: _onSurfaceColor.withOpacity(0.5),
                            fontSize: isMobile ? 12.0 : 14.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: isMobile ? 8 : 12),

                      _buildProfileItem(
                        context: context,
                        icon: Icons.emoji_events_rounded,
                        title: 'Ranking de Partida',
                        subtitle: 'Ver sua posição no ranking',
                        onTap: () {
                          context.pushNamed(
                            Tela12VitoriaViewWidget.routeName,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.rightToLeft,
                              ),
                            },
                          );
                        },
                      ),

                      _buildProfileItem(
                        context: context,
                        icon: Icons.notifications_active_rounded,
                        title: 'Notificações',
                        subtitle: 'Central de Notificações',
                        onTap: () {
                          context
                              .pushNamed(Tela17NotificacaoViewWidget.routeName);
                        },
                      ),

                      _buildProfileItem(
                        context: context,
                        icon: Icons.edit_rounded,
                        title: 'Editar Perfil',
                        subtitle: 'Atualizar informações pessoais',
                        onTap: () {
                          context.pushNamed(Tela11EditarPerfilWidget.routeName);
                        },
                      ),

                      SizedBox(height: isMobile ? 16 : 20),

                      // Seção GERAL
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 24.0 : 32.0,
                        ),
                        child: Text(
                          'GERAL',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: _onSurfaceColor.withOpacity(0.5),
                            fontSize: isMobile ? 12.0 : 14.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: isMobile ? 8 : 12),

                      _buildProfileItem(
                        context: context,
                        icon: Icons.support_agent_rounded,
                        title: 'Suporte',
                        subtitle: 'Central de ajuda e suporte',
                        onTap: () {
                          context.pushNamed(TelaSuporteWidget.routeName);
                        },
                      ),

                      _buildProfileItem(
                        context: context,
                        icon: Icons.privacy_tip_rounded,
                        title: 'Termos de Serviço',
                        subtitle: 'Políticas e termos de uso',
                      ),

                      _buildProfileItem(
                        context: context,
                        icon: Icons.ios_share_rounded,
                        title: 'Convidar Amigos',
                        subtitle: 'Compartilhe e ganhe recompensas',
                        isPremium: true,
                      ),

                      // Item de Logout
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20.0 : 32.0,
                          vertical: isMobile ? 12.0 : 16.0,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(isMobile ? 16.0 : 20.0),
                            onTap: () {
                              // Adicionar lógica de logout
                            },
                            child: Container(
                              width: double.infinity,
                              height: isMobile ? 60.0 : 68.0,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(isMobile ? 16.0 : 20.0),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout_rounded,
                                      color: Colors.red,
                                      size: isMobile ? 20 : 22,
                                    ),
                                    SizedBox(width: isMobile ? 8 : 12),
                                    Text(
                                      'Sair da Conta',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.red,
                                        fontSize: isMobile ? 16 : 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: isMobile ? 32 : 40),
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
}