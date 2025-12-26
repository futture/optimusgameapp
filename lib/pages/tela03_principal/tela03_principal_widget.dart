import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/components/warnings/warning04_reducao_de_saldo/warning04_reducao_de_saldo_widget.dart';
import 'package:projeto_game_quiz/core/api/services/fcm_token_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/dialogs/common_dialog_widget.dart';
import 'package:projeto_game_quiz/utils.dart';
import '/components/moda_listade_sala_widget.dart';
import '/components/moda_menu_pagian_inicial_widget.dart';
import '/components/modals_saque_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tela03_principal_model.dart';

export 'tela03_principal_model.dart';

class Tela03PrincipalWidget extends StatefulWidget {
  const Tela03PrincipalWidget({super.key});

  static String routeName = 'Tela03Principal';
  static String routePath = '/tela03Principal';

  @override
  State<Tela03PrincipalWidget> createState() => _Tela03PrincipalWidgetState();
}

class _Tela03PrincipalWidgetState extends State<Tela03PrincipalWidget> {
  late Tela03PrincipalModel _model;
  final matchService = MatchService();

  // Mapa para controlar loading individual de cada partida
  final Map<String, bool> _matchLoadingStates = {};

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FcmTokenService _fcmTokenService = FcmTokenService();

  // Cores e gradientes do tema premium
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);

  // Cores mais suaves para os cards
  final Color _cardLightOrange = Color(0xFFFFA726); // Laranja mais suave
  final Color _cardDarkOrange = Color(0xFFFB8C00); // Laranja escuro mais suave

  final LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _fcmTokenService.initFirebaseMessaging(context);

    _model = createModel(context, () => Tela03PrincipalModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
    _model.getUserInfoAndAccountInfoAsync(setState, context);
    _model.loadMatches(setState);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: _backgroundColor,
          body: Column(
            children: [
              // Header Premium - Mesmo estilo da tela de finanças
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
                      horizontal: _getResponsivePadding(context),
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Botão Menu Premium
                            Container(
                              width: _getIconSize(context),
                              height: _getIconSize(context),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: _showMenuModal,
                                icon: Icon(
                                  FontAwesomeIcons.bars,
                                  color: Colors.white,
                                  size: _getIconSize(context) - 28,
                                ),
                                splashRadius: 20,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'GAME QUIZ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _getFontSize(context, baseSize: 20),
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            // Ícone de notificações
                            Container(
                              width: _getIconSize(context),
                              height: _getIconSize(context),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                  size: _getIconSize(context) - 24,
                                ),
                                onPressed: () {
                                  // Adicionar funcionalidade de notificações aqui
                                },
                                splashRadius: 20,
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
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 1000 : double.infinity,
                    ),
                    child: RefreshIndicator(
                      onRefresh: _refreshData,
                      color: const Color(0xFFEC8D0D),
                      backgroundColor: _backgroundColor,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(_getResponsivePadding(context)),
                        child: Column(
                          children: [
                            _buildUserProfileCard(context),
                            const SizedBox(height: 24),
                            _buildGameRoomButton(context),
                            const SizedBox(height: 24),
                            _buildSuperLeagueHeader(context),
                            const SizedBox(height: 20),
                            if (_model.isLoadingMatches)
                              _buildLoadingState()
                            else if (_model.matchList.isEmpty)
                              _buildEmptyMatchesState(context)
                            else
                              _buildMatchList(context),
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
      ),
    );
  }

  // Métodos auxiliares para responsividade
  double _getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 350) return 12;
    if (width < 400) return 14;
    if (width < 500) return 16;
    return 20;
  }

  double _getIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 350) return 38;
    if (width < 400) return 40;
    return 44;
  }

  double _getFontSize(BuildContext context, {required double baseSize}) {
    final width = MediaQuery.of(context).size.width;
    if (width < 350) return baseSize * 0.85;
    if (width < 400) return baseSize * 0.9;
    return baseSize;
  }

  Future<void> _refreshData() async {
    await _model.getUserInfoAndAccountInfoAsync(setState, context);
    await _model.loadMatches(setState);
  }

  void _showMenuModal() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const ModaMenuPagianInicialWidget(isMainScreen: true),
        ),
      ),
    );
    safeSetState(() {});
  }

  Widget _buildUserProfileCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: _outlineColor,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.pushNamed(
                    Tela04PerfilWidget.routeName,
                    extra: <String, dynamic>{
                      kTransitionInfoKey: const TransitionInfo(
                        hasTransition: true,
                        transitionType: PageTransitionType.rightToLeft,
                      ),
                    },
                  ),
                  child: Container(
                    width: isSmallScreen ? 60 : 70,
                    height: isSmallScreen ? 60 : 70,
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
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Image.asset(
                        'assets/images/profile.jpeg',
                        fit: BoxFit.cover,
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded) return child;
                          return AnimatedOpacity(
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(milliseconds: 300),
                            child: child,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isSmallScreen ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _model.user?.name ?? "Carregando...",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: isSmallScreen ? 16.0 : 18.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.0,
                          color: _onSurfaceColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 10 : 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.phone_rounded,
                              size: isSmallScreen ? 12 : 14,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: isSmallScreen ? 4 : 6),
                            Flexible(
                              child: Text(
                                _model.userAccountInfo != null
                                    ? '${_model.user!.phone_number}'
                                    : "Carregando...",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: isSmallScreen ? 12.0 : 13.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 14 : 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: _primaryColor.withOpacity(0.05),
                border: Border.all(
                  color: _primaryColor.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SALDO DISPONÍVEL',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: isSmallScreen ? 11.0 : 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _model.userAccountInfo != null
                              ? CurrencyUtil.formatKwanza(
                                      _model.userAccountInfo!.balance)
                                  .toString()
                              : "0,00",
                          style: TextStyle(
                            fontFamily: 'Inter Tight',
                            fontSize: isSmallScreen ? 22.0 : 28.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w800,
                            color: _primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kwanza (AOA)',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: isSmallScreen ? 11.0 : 12.0,
                            letterSpacing: 0.0,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: isSmallScreen ? 40 : 44,
                    height: isSmallScreen ? 40 : 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: isSmallScreen ? 20 : 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  context: context,
                  icon: Icons.add_circle_outlined,
                  label: 'DEPOSITAR',
                  color: Color(0xFF00B80E),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Tela10DepositoListaWidget(),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                _buildActionButton(
                  context: context,
                  icon: Icons.remove_circle_outlined,
                  label: 'SACAR',
                  color: _primaryColor,
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      useSafeArea: true,
                      context: context,
                      builder: (context) => GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: const ModalsSaqueWidget(),
                        ),
                      ),
                    );
                    if (mounted) {
                      await _refreshData();
                      safeSetState(() {});
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return Expanded(
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: color.withOpacity(0.1),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: isSmallScreen ? 36 : 44,
                  height: isSmallScreen ? 36 : 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: isSmallScreen ? 18 : 22,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 6 : 10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: isSmallScreen ? 12.0 : 14.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.0,
                    color: Colors.grey.shade800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameRoomButton(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00B80E),
            Color(0xFF009107),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00B80E).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SALA DE JOGO',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: isSmallScreen ? 11.0 : 12.0,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 2 : 4),
                      Text(
                        'Escolha sua sala e comece a ganhar!',
                        style: TextStyle(
                          fontFamily: 'Inter Tight',
                          fontSize: isSmallScreen ? 16.0 : 18.0,
                          color: Colors.white,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: isSmallScreen ? 48 : 56,
                  height: isSmallScreen ? 48 : 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.videogame_asset_rounded,
                    color: Colors.white,
                    size: isSmallScreen ? 22 : 26,
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 16 : 20),
            Material(
              borderRadius: BorderRadius.circular(14),
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    context: context,
                    builder: (context) => GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Padding(
                        padding: MediaQuery.viewInsetsOf(context),
                        child: const ModaListadeSalaWidget(),
                      ),
                    ),
                  );
                  safeSetState(() {});
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isSmallScreen ? 14 : 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: isSmallScreen ? 32 : 36,
                        height: isSmallScreen ? 32 : 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF00B80E).withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Color(0xFF00B80E),
                          size: isSmallScreen ? 18 : 20,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Flexible(
                        child: Text(
                          'ESCOLHER PARTIDA',
                          style: TextStyle(
                            fontFamily: 'Inter Tight',
                            color: Color(0xFF00B80E),
                            fontSize: isSmallScreen ? 14.0 : 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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

  Widget _buildSuperLeagueHeader(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 10 : 14,
                      vertical: isSmallScreen ? 6 : 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bolt_rounded,
                          color: Colors.white,
                          size: isSmallScreen ? 16 : 20,
                        ),
                        SizedBox(width: isSmallScreen ? 6 : 8),
                        Flexible(
                          child: Text(
                            'SUPER LIGA',
                            style: TextStyle(
                              fontFamily: 'Inter Tight',
                              fontSize: isSmallScreen ? 14.0 : 18.0,
                              color: Colors.white,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_model.nextMatch != null)
                  _buildCountdownTimer(isSmallScreen)
                else
                  _buildPlaceholderTimer(isSmallScreen),
              ],
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Text(
              'Habilita-se a ganhar grandes prêmios participando nas partidas abaixo. '
              'Basta clicar na partida para se inscrever.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isSmallScreen ? 13.0 : 14.0,
                color: Colors.white.withOpacity(0.95),
                letterSpacing: 0.0,
                height: 1.5,
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Wrap(
              spacing: isSmallScreen ? 6 : 8,
              runSpacing: isSmallScreen ? 6 : 8,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 10 : 12,
                    vertical: isSmallScreen ? 5 : 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.emoji_events_rounded,
                        size: isSmallScreen ? 14 : 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 6),
                      Flexible(
                        child: Text(
                          'PRÊMIOS EXCLUSIVOS',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: isSmallScreen ? 11.0 : 12.0,
                            color: Colors.white,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 10 : 12,
                    vertical: isSmallScreen ? 5 : 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: isSmallScreen ? 14 : 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 6),
                      Flexible(
                        child: Text(
                          'TORNEIOS',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: isSmallScreen ? 11.0 : 12.0,
                            color: Colors.white,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownTimer(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 10 : 14,
        vertical: isSmallScreen ? 6 : 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFEC8D0D),
            Color(0xFFD2691E),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEC8D0D).withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_rounded,
            size: isSmallScreen ? 16 : 18,
            color: Colors.white,
          ),
          SizedBox(width: isSmallScreen ? 4 : 6),
          Text(
            _formatCountdown(_model.timerMilliseconds),
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTimer(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 10 : 14,
        vertical: isSmallScreen ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_rounded,
            size: isSmallScreen ? 16 : 18,
            color: Colors.white,
          ),
          SizedBox(width: isSmallScreen ? 4 : 6),
          Text(
            "EM BREVE",
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEC8D0D)),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Carregando partidas...',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.0,
              letterSpacing: 0.0,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMatchesState(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _surfaceColor,
        border: Border.all(
          color: _outlineColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isSmallScreen ? 60 : 80,
            height: isSmallScreen ? 60 : 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.videogame_asset_outlined,
              size: isSmallScreen ? 30 : 40,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          Text(
            'Nenhuma partida disponível',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isSmallScreen ? 16.0 : 18.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.0,
              color: _onSurfaceColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            'Novas partidas serão anunciadas em breve',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: isSmallScreen ? 20 : 24),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FFButtonWidget(
              onPressed: () async {
                await _model.loadMatches(setState);
              },
              text: 'ATUALIZAR',
              icon: Icon(
                Icons.refresh_rounded,
                size: isSmallScreen ? 16 : 18,
              ),
              options: FFButtonOptions(
                width: isSmallScreen ? 150 : 180,
                height: isSmallScreen ? 44 : 48,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                color: _primaryColor,
                textStyle: TextStyle(
                  fontFamily: 'Inter Tight',
                  color: Colors.white,
                  fontSize: isSmallScreen ? 14 : 15,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w700,
                ),
                elevation: 0,
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchList(BuildContext context) {
    return Column(
      children: _model.matchList.map((match) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildMatchCard(match, context),
        );
      }).toList(),
    );
  }

  Widget _buildMatchCard(MatchResponse match, BuildContext context) {
    final isRegistered = match.isUserRegistered ?? false;
    final isThisCardLoading = _matchLoadingStates[match.id] ?? false;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isVerySmallScreen = screenWidth < 350;

    final entryAmount = match.room?.roomConfiguration?.minimumAmountToPlay ?? 0;
    final formattedAmount = '${entryAmount}KZ';

    final isNextMatch = _model.nextMatch?.id == match.id;

    return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () async {
            if (isThisCardLoading) return;

            setState(() {
              _matchLoadingStates[match.id] = true;
            });

            try {
              await _model.getUsersByMatchId(setState, match.id);
              CommonDialogWidget.showMatchParticipantsDialog(
                  context,
                  List.empty(),
                  null,
                  match,
                  _model.users,
                  _model.user,
                  buildMatchButton(
                    isRegistered: isRegistered,
                    match: match,
                    onJoin: (m) => _handleMatchTap(m as MatchResponse),
                    onLeave: (m) => _leaveMatch(m as MatchResponse),
                    context: context,
                  ),
                  isPlaySound: false,
                  isProgressBar: false);
            } catch (e) {
              Warning00ErrorUtil.showDialogMessageError(
                context,
                "Erro ao carregar partida",
                "Ocorreu um erro ao carregar os detalhes da partida.",
              );
            } finally {
              setState(() {
                _matchLoadingStates[match.id] = false;
              });
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            constraints: BoxConstraints(
              minHeight: isSmallScreen ? 140 : 160,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isRegistered
                    ? [
                        Color(0xFF4CAF50),
                        Color(0xFF2E7D32),
                      ]
                    : isNextMatch
                        ? [
                            Color(0xFFEC8D0D),
                            Color(0xFFD2691E),
                          ]
                        : [
                            _cardLightOrange,
                            _cardDarkOrange,
                          ],
              ),
              boxShadow: [
                BoxShadow(
                  color: (isRegistered
                          ? Color(0xFF4CAF50)
                          : isNextMatch
                              ? Color(0xFFEC8D0D)
                              : _cardLightOrange)
                      .withOpacity(isNextMatch ? 0.35 : 0.25),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(isVerySmallScreen
                      ? 12
                      : isSmallScreen
                          ? 14
                          : 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: isVerySmallScreen
                                      ? 32
                                      : isSmallScreen
                                          ? 36
                                          : 42,
                                  height: isVerySmallScreen
                                      ? 32
                                      : isSmallScreen
                                          ? 36
                                          : 42,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.25),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.4),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    isNextMatch
                                        ? Icons.bolt_rounded
                                        : Icons.emoji_events_rounded,
                                    color: Colors.white,
                                    size: isVerySmallScreen
                                        ? 16
                                        : isSmallScreen
                                            ? 18
                                            : 22,
                                  ),
                                ),
                                SizedBox(
                                    width: isVerySmallScreen
                                        ? 6
                                        : isSmallScreen
                                            ? 8
                                            : 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isNextMatch
                                            ? 'PRÓXIMA PARTIDA'
                                            : 'SUPER PARTIDA',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: isVerySmallScreen
                                              ? 9.0
                                              : isSmallScreen
                                                  ? 10.0
                                                  : 12.0,
                                          color: Colors.white.withOpacity(0.95),
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                          height: isVerySmallScreen
                                              ? 1
                                              : isSmallScreen
                                                  ? 1
                                                  : 2),
                                      Text(
                                        'das ${formatHour(match.matchStartDate)}',
                                        style: TextStyle(
                                          fontFamily: 'Inter Tight',
                                          color: Colors.white,
                                          fontSize: isVerySmallScreen
                                              ? 14.0
                                              : isSmallScreen
                                                  ? 15.0
                                                  : 17.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w800,
                                          height: 1.2,
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
                          SizedBox(
                              width: isVerySmallScreen
                                  ? 6
                                  : isSmallScreen
                                      ? 8
                                      : 10),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: isVerySmallScreen
                                  ? 70
                                  : isSmallScreen
                                      ? 80
                                      : 100,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: isVerySmallScreen
                                  ? 8
                                  : isSmallScreen
                                      ? 10
                                      : 14,
                              vertical: isVerySmallScreen
                                  ? 5
                                  : isSmallScreen
                                      ? 6
                                      : 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius:
                                  BorderRadius.circular(isVerySmallScreen
                                      ? 10
                                      : isSmallScreen
                                          ? 12
                                          : 14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Entrada',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: isVerySmallScreen
                                        ? 8.0
                                        : isSmallScreen
                                            ? 9.0
                                            : 10.0,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                    height: isVerySmallScreen
                                        ? 1
                                        : isSmallScreen
                                            ? 1
                                            : 2),
                                Text(
                                  formattedAmount,
                                  style: TextStyle(
                                    fontFamily: 'Inter Tight',
                                    color: Colors.white,
                                    fontSize: isVerySmallScreen
                                        ? 12.0
                                        : isSmallScreen
                                            ? 14.0
                                            : 16.0,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // CRONÔMETRO APENAS PARA PRÓXIMA PARTIDA
                      if (isNextMatch)
                        Padding(
                          padding: EdgeInsets.only(
                            top: isVerySmallScreen
                                ? 6
                                : isSmallScreen
                                    ? 8
                                    : 10,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isVerySmallScreen
                                    ? 8
                                    : isSmallScreen
                                        ? 10
                                        : 12,
                                vertical: isVerySmallScreen
                                    ? 3
                                    : isSmallScreen
                                        ? 4
                                        : 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFD4AF37), // Dourado
                                    Color(0xFFB8860B), // Dourado escuro
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.circular(isVerySmallScreen
                                        ? 8
                                        : isSmallScreen
                                            ? 10
                                            : 12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFD4AF37).withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.timer_rounded,
                                    size: isVerySmallScreen
                                        ? 12
                                        : isSmallScreen
                                            ? 14
                                            : 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                      width: isVerySmallScreen
                                          ? 4
                                          : isSmallScreen
                                              ? 5
                                              : 6),
                                  Text(
                                    'COMEÇA EM:',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: isVerySmallScreen
                                          ? 8.0
                                          : isSmallScreen
                                              ? 9.0
                                              : 10.0,
                                      color: Colors.white.withOpacity(0.95),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  SizedBox(
                                      width: isVerySmallScreen
                                          ? 2
                                          : isSmallScreen
                                              ? 3
                                              : 4),
                                  Text(
                                    _formatCountdown(_model.timerMilliseconds),
                                    style: TextStyle(
                                      fontFamily: 'Inter Tight',
                                      color: Colors.white,
                                      fontSize: isVerySmallScreen
                                          ? 12.0
                                          : isSmallScreen
                                              ? 13.0
                                              : 14.0,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      SizedBox(
                          height: isVerySmallScreen
                              ? (isNextMatch
                                  ? 8
                                  : 10) // Espaço menor se tiver cronômetro
                              : isSmallScreen
                                  ? (isNextMatch ? 10 : 12)
                                  : (isNextMatch ? 12 : 16)),

                      // Informações da partida - Mantendo layout horizontal sempre
                      Container(
                        padding: EdgeInsets.all(isVerySmallScreen
                            ? 8
                            : isSmallScreen
                                ? 10
                                : 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(isVerySmallScreen
                              ? 10
                              : isSmallScreen
                                  ? 12
                                  : 14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoItem(
                              isVerySmallScreen: isVerySmallScreen,
                              isSmallScreen: isSmallScreen,
                              icon: Icons.people_alt_rounded,
                              label: 'JOGADORES',
                              value: '${match.matchPlayers?.length ?? 0}',
                            ),
                            Container(
                              height: isVerySmallScreen
                                  ? 20
                                  : isSmallScreen
                                      ? 24
                                      : 30,
                              width: 1,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            _buildInfoItem(
                              isVerySmallScreen: isVerySmallScreen,
                              isSmallScreen: isSmallScreen,
                              icon: Icons.schedule_rounded,
                              label: 'HORÁRIO',
                              value: formatHour(match.matchStartDate),
                            ),
                            Container(
                              height: isVerySmallScreen
                                  ? 20
                                  : isSmallScreen
                                      ? 24
                                      : 30,
                              width: 1,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            _buildInfoItem(
                              isVerySmallScreen: isVerySmallScreen,
                              isSmallScreen: isSmallScreen,
                              icon: Icons.calendar_today_rounded,
                              label: 'DATA',
                              value: _formatDate(match.matchStartDate),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                          height: isVerySmallScreen
                              ? 10
                              : isSmallScreen
                                  ? 12
                                  : 16),

                      // Status do usuário na partida
                      if (isRegistered)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: isVerySmallScreen
                                ? 10
                                : isSmallScreen
                                    ? 12
                                    : 16,
                            vertical: isVerySmallScreen
                                ? 7
                                : isSmallScreen
                                    ? 8
                                    : 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius:
                                BorderRadius.circular(isVerySmallScreen
                                    ? 10
                                    : isSmallScreen
                                        ? 12
                                        : 14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                                size: isVerySmallScreen
                                    ? 14
                                    : isSmallScreen
                                        ? 16
                                        : 18,
                              ),
                              SizedBox(
                                  width: isVerySmallScreen
                                      ? 4
                                      : isSmallScreen
                                          ? 6
                                          : 8),
                              Flexible(
                                child: Text(
                                  'VOCÊ ESTÁ INSCRITO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isVerySmallScreen
                                        ? 10.0
                                        : isSmallScreen
                                            ? 11.0
                                            : 13.0,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: isVerySmallScreen
                                ? 10
                                : isSmallScreen
                                    ? 12
                                    : 16,
                            vertical: isVerySmallScreen
                                ? 7
                                : isSmallScreen
                                    ? 8
                                    : 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(isVerySmallScreen
                                    ? 10
                                    : isSmallScreen
                                        ? 12
                                        : 14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Colors.white.withOpacity(0.9),
                                size: isVerySmallScreen
                                    ? 12
                                    : isSmallScreen
                                        ? 14
                                        : 16,
                              ),
                              SizedBox(
                                  width: isVerySmallScreen
                                      ? 4
                                      : isSmallScreen
                                          ? 6
                                          : 8),
                              Expanded(
                                child: Text(
                                  'Clique para ver detalhes',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: isVerySmallScreen
                                        ? 10.0
                                        : isSmallScreen
                                            ? 11.0
                                            : 12.5,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Loading overlay apenas para este card
                if (isThisCardLoading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  Widget _buildInfoItem({
    required bool isVerySmallScreen,
    required bool isSmallScreen,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isVerySmallScreen
                    ? 10
                    : isSmallScreen
                        ? 12
                        : 14,
                color: Colors.white.withOpacity(0.9),
              ),
              SizedBox(
                  width: isVerySmallScreen
                      ? 2
                      : isSmallScreen
                          ? 3
                          : 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: isVerySmallScreen
                        ? 8.0
                        : isSmallScreen
                            ? 9.0
                            : 10.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(
              height: isVerySmallScreen
                  ? 1
                  : isSmallScreen
                      ? 2
                      : 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isVerySmallScreen
                  ? 10.0
                  : isSmallScreen
                      ? 11.0
                      : 13.0,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Future<void> _handleMatchTap(MatchResponse match) async {
    await _model.checkPlayerAlreadyRegisteredMatchAsync(setState, match.id);

    if (!_model.isNotRegisteredMatch) {
      Navigator.pop(context);
      Warning00ErrorUtil.showDialogMessageError(
        context,
        "Falha ao se increver na partida",
        "Jogador já inscrito na partida.",
      );
    } else {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(24),
            child: Warning04ReducaoDeSaldoWidget(
              subscribe: true,
              matchInfo: match,
              onConfirmed: () => Navigator.of(context).pop(true),
            ),
          );
        },
      );

      if (result == true) {
        Navigator.pop(context);

        setState(() {
          _model.getUserInfoAndAccountInfoAsync(setState, context);
          _model.loadMatches(setState);
        });
      }
    }
  }

  String formatHour(DateTime? dateTime) {
    if (dateTime == null) return '--:--';
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '--/--';
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    return '$day/$month';
  }

  String _formatCountdown(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);

    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  Future<void> _leaveMatch(MatchResponse match) async {
    try {
      Navigator.pop(context);
      await _model.leaveMatchAsync(match.id);
      setState(() {
        _model.getUserInfoAndAccountInfoAsync(setState, context);
        _model.loadMatches(setState);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Você saiu da partida com sucesso'),
          backgroundColor: Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      Warning00ErrorUtil.showDialogMessageError(
        context,
        "Erro ao sair da partida",
        "Ocorreu um erro ao tentar sair da partida. Tente novamente.",
      );
    }
  }

  Widget buildMatchButton({
    required bool isRegistered,
    required dynamic match,
    required Future<void> Function(dynamic) onJoin,
    required Future<void> Function(dynamic) onLeave,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (isRegistered ? Colors.red : Color(0xFF00B80E))
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FFButtonWidget(
        onPressed: () async {
          if (isRegistered) {
            await onLeave(match);
          } else {
            await onJoin(match);
          }
        },
        text: isRegistered ? 'SAIR DA PARTIDA' : 'INSCREVER-SE AGORA',
        icon: Icon(
          isRegistered ? Icons.logout_rounded : Icons.login_rounded,
          size: 20,
        ),
        options: FFButtonOptions(
          width: double.infinity,
          height: 52,
          color: isRegistered ? Colors.redAccent : Color(0xFF00B80E),
          textStyle: TextStyle(
            fontFamily: 'Inter Tight',
            color: Colors.white,
            fontSize: 16,
            letterSpacing: 0,
            fontWeight: FontWeight.w800,
          ),
          elevation: 0,
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
