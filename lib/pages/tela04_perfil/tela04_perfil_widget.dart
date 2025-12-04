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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: 72.0,
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  children: [
                    Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: BoxDecoration(
                        color: isPremium 
                            ? Colors.white.withOpacity(0.2) 
                            : _primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: isPremium ? Colors.white : _primaryColor,
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 16.0),
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
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
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
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (showArrow)
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: isPremium ? Colors.white : _onSurfaceColor.withOpacity(0.5),
                        size: 16.0,
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
  }) {
    return Container(
      width: 110,
      height: 100,
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: _primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _onSurfaceColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Botão Voltar Premium
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () {
                                context.safePop();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              splashRadius: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Meu Perfil',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          // Ícone de configurações
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.settings_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Barra de progresso sutil
                      Container(
                        height: 2,
                        width: 60,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Seção do Perfil
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _surfaceColor,
                        borderRadius: BorderRadius.circular(20),
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
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _primaryColor,
                                width: 3.0,
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
                              borderRadius: BorderRadius.circular(40.0),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://images.unsplash.com/photo-1531123414780-f74242c2b052?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDV8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        color: _primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        color: _primaryColor,
                                        size: 30,
                                      ),
                                    ),
                                errorWidget: (context, url, error) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        color: _primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        color: _primaryColor,
                                        size: 30,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
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
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                    color: _onSurfaceColor,
                                    letterSpacing: -0.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _successColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _model.userAccountInfo == null
                                        ? "Carregando..."
                                        : 'ID: ${_model.userAccountInfo!.availableBalance}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: _successColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Jogador Premium',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: _onSurfaceColor.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Stats Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              value: '1.2K',
                              label: 'Pontos',
                              icon: Icons.emoji_events_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              value: '156',
                              label: 'Vitórias',
                              icon: Icons.workspace_premium_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              value: '89%',
                              label: 'Taxa de Vitória',
                              icon: Icons.trending_up_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Seção CONTA
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'MINHA CONTA',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: _onSurfaceColor.withOpacity(0.5),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    _buildProfileItem(
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
                      icon: Icons.notifications_active_rounded,
                      title: 'Notificações',
                      subtitle: 'Central de notificações',
                      onTap: () {
                        context.pushNamed(Tela17NotificacaoViewWidget.routeName);
                      },
                    ),

                    _buildProfileItem(
                      icon: Icons.edit_rounded,
                      title: 'Editar Perfil',
                      subtitle: 'Atualizar informações pessoais',
                      onTap: () {
                        context.pushNamed(Tela11EditarPerfilWidget.routeName);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Seção GERAL
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'GERAL',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: _onSurfaceColor.withOpacity(0.5),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    _buildProfileItem(
                      icon: Icons.support_agent_rounded,
                      title: 'Suporte',
                      subtitle: 'Central de ajuda e suporte',
                      onTap: () {
                        context.pushNamed(TelaSuporteWidget.routeName);
                      },
                    ),

                    _buildProfileItem(
                      icon: Icons.privacy_tip_rounded,
                      title: 'Termos de Serviço',
                      subtitle: 'Políticas e termos de uso',
                    ),

                    _buildProfileItem(
                      icon: Icons.ios_share_rounded,
                      title: 'Convidar Amigos',
                      subtitle: 'Compartilhe e ganhe recompensas',
                      isPremium: true,
                    ),

                    // Item de Logout
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16.0),
                          onTap: () {
                            // Adicionar lógica de logout
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16.0),
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
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Sair da Conta',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Colors.red,
                                      fontSize: 16,
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

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}