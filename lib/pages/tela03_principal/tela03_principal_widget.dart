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
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
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
  Map<String, bool> _isLoadingMatchMap = {};
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FcmTokenService _fcmTokenService = FcmTokenService();
  
  // Flag para controlar se o widget foi descartado
  bool _isDisposed = false;

  // Cores e gradientes do tema premium
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _primaryDark = Color(0xFFD17A0A);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);
  final Color _successColor = Color(0xFF10B981);

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

    WidgetsBinding.instance.addPostFrameCallback((_) => _safeSetState(() {}));
    
    // Carrega dados iniciais de forma segura
    Future.microtask(() {
      if (!_isDisposed && mounted) {
        _model.getUserInfoAndAccountInfoAsync(_safeSetState, context);
        _model.loadMatches(_safeSetState);
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _model.dispose();
    super.dispose();
  }

  // Método seguro para setState
  void _safeSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) {
      setState(fn);
    }
  }

  // Método existente mantido para compatibilidade
  void safeSetState(VoidCallback fn) {
    _safeSetState(fn);
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Botão Menu Premium
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: _showMenuModal,
                                icon: Icon(
                                  FontAwesomeIcons.bars,
                                  color: Colors.white,
                                  size: 16,
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            // Ícone de notificações
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                  size: 20,
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
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            _buildUserProfileCard(),
                            const SizedBox(height: 24),
                            _buildGameRoomButton(),
                            const SizedBox(height: 24),
                            _buildSuperLeagueHeader(),
                            const SizedBox(height: 20),
                            if (_model.isLoadingMatches)
                              _buildLoadingState()
                            else if (_model.matchList.isEmpty)
                              _buildEmptyMatchesState()
                            else
                              _buildMatchList(),
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

  Future<void> _refreshData() async {
    if (!_isDisposed && mounted) {
      await _model.getUserInfoAndAccountInfoAsync(_safeSetState, context);
      await _model.loadMatches(_safeSetState);
    }
  }

  void _showMenuModal() async {
    if (!_isDisposed && mounted) {
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
      _safeSetState(() {});
    }
  }

  Widget _buildUserProfileCard() {
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (!_isDisposed && mounted) {
                      context.pushNamed(
                        Tela04PerfilWidget.routeName,
                        extra: <String, dynamic>{
                          kTransitionInfoKey: const TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.rightToLeft,
                          ),
                        },
                      );
                    }
                  },
                  child: Container(
                    width: 70,
                    height: 70,
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
                      child: Image.network(
                        'https://images.unsplash.com/photo-1507679799987-c73779587ccf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxwcm98ZW58MHx8fHwxNzQzNTg0NTYxfDA&ixlib=rb-4.0.3&q=80&w=1080',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              color: _primaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _model.user?.name ?? "Carregando...",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.0,
                          color: _onSurfaceColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.badge_outlined,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _model.userAccountInfo != null
                                  ? 'ID: ${_model.userAccountInfo!.accountNumber}'
                                  : "Carregando...",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
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
              padding: const EdgeInsets.all(18),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SALDO DISPONÍVEL',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
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
                          fontSize: 28.0,
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
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 44,
                    height: 44,
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
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 22,
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
                  icon: Icons.add_circle_outlined,
                  label: 'DEPOSITAR',
                  color: Color(0xFF00B80E),
                  onPressed: () {
                    if (!_isDisposed && mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Tela10DepositoListaWidget(),
                        ),
                      );
                    }
                  },
                ),
                _buildActionButton(
                  icon: Icons.remove_circle_outlined,
                  label: 'SACAR',
                  color: _primaryColor,
                  onPressed: () async {
                    if (!_isDisposed && mounted) {
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
                      _safeSetState(() {});
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
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
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
                    width: 44,
                    height: 44,
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
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.0,
                      color: Colors.grey.shade800,
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

  Widget _buildGameRoomButton() {
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SALA DE JOGO',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Escolha sua sala e comece a ganhar!',
                        style: TextStyle(
                          fontFamily: 'Inter Tight',
                          fontSize: 18.0,
                          color: Colors.white,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.videogame_asset_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Material(
              borderRadius: BorderRadius.circular(14),
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  if (!_isDisposed && mounted) {
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
                    _safeSetState(() {});
                  }
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
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
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF00B80E).withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Color(0xFF00B80E),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'ESCOLHER PARTIDA',
                        style: TextStyle(
                          fontFamily: 'Inter Tight',
                          color: Color(0xFF00B80E),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w800,
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

  Widget _buildSuperLeagueHeader() {
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bolt_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'SUPER LIGA',
                            style: TextStyle(
                              fontFamily: 'Inter Tight',
                              fontSize: 18.0,
                              color: Colors.white,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_model.nextMatch != null)
                  _buildCountdownTimer()
                else
                  _buildPlaceholderTimer(),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Habilita-se a ganhar grandes prêmios participando nas partidas abaixo. '
              'Basta clicar na partida para se inscrever.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                color: Colors.white.withOpacity(0.95),
                letterSpacing: 0.0,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      const Icon(Icons.emoji_events_rounded,
                          size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        'PRÊMIOS EXCLUSIVOS',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: Colors.white,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      const Icon(Icons.star_rounded,
                          size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        'TORNEIOS',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0,
                          color: Colors.white,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
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

  Widget _buildCountdownTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
          const Icon(Icons.timer_rounded, size: 18, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            _formatCountdown(_model.timerMilliseconds),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_rounded, size: 18, color: Colors.white),
          SizedBox(width: 6),
          Text(
            "EM BREVE",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
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
              valueColor:
                  AlwaysStoppedAnimation<Color>(Color(0xFFEC8D0D)),
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

  Widget _buildEmptyMatchesState() {
    return Container(
      padding: const EdgeInsets.all(32),
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
            width: 80,
            height: 80,
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
              size: 40,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Nenhuma partida disponível',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.0,
              color: _onSurfaceColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Novas partidas serão anunciadas em breve',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
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
                if (!_isDisposed && mounted) {
                  await _model.loadMatches(_safeSetState);
                }
              },
              text: 'ATUALIZAR',
              icon: const Icon(Icons.refresh_rounded, size: 18),
              options: FFButtonOptions(
                width: 180,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                color: _primaryColor,
                textStyle: TextStyle(
                  fontFamily: 'Inter Tight',
                  color: Colors.white,
                  fontSize: 15,
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

  Widget _buildMatchList() {
    return Column(
      children: _model.matchList.map((match) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildMatchCard(match),
        );
      }).toList(),
    );
  }

  Widget _buildMatchCard(MatchResponse match) {
    final isRegistered = match.isUserRegistered ?? false;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () async {
          if (_isLoadingMatchMap[match.id] == true || _isDisposed || !mounted) return;

          _safeSetState(() => _isLoadingMatchMap[match.id] = true);

          try {
            await _model.getUsersByMatchId(_safeSetState, match.id);
            
            if (!_isDisposed && mounted) {
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
            }
          } catch (e) {
            if (!_isDisposed && mounted) {
              Warning00ErrorUtil.showDialogMessageError(
                context,
                "Erro ao carregar partida",
                "Ocorreu um erro ao carregar os detalhes da partida.",
              );
            }
          } finally {
            if (!_isDisposed && mounted) {
              _safeSetState(() => _isLoadingMatchMap[match.id] = false);
            }
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isRegistered
                  ? [
                      Color(0xFF4CAF50),
                      Color(0xFF2E7D32),
                    ]
                  : [
                      Color(0xFFEC8D0D),
                      Color(0xFFD2691E),
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: (isRegistered
                        ? Color(0xFF4CAF50)
                        : Color(0xFFEC8D0D))
                    .withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.2),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.emoji_events_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Super Partida',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12.0,
                                        color: Colors.white.withOpacity(0.9),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'das ${formatHour(match.matchStartDate)}',
                                      style: TextStyle(
                                        fontFamily: 'Inter Tight',
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w800,
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            '${match.room?.roomConfiguration?.minimumAmountToPlay ?? 0}KZ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMatchStat(
                          icon: Icons.people_alt_rounded,
                          value: '${match.matchPlayers?.length ?? 0} Jogadores',
                        ),
                        _buildMatchStat(
                          icon: Icons.schedule_rounded,
                          value: formatHour(match.matchStartDate),
                        ),
                        if (isRegistered)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 6.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'INSCRITO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
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
              if (_isLoadingMatchMap[match.id] == true)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
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

  Widget _buildMatchStat({required IconData icon, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleMatchTap(MatchResponse match) async {
    if (_isDisposed || !mounted) return;

    await _model.checkPlayerAlreadyRegisteredMatchAsync(_safeSetState, match.id);

    if (!_model.isNotRegisteredMatch) {
      if (!_isDisposed && mounted) {
        Navigator.pop(context);
        Warning00ErrorUtil.showDialogMessageError(
          context,
          "Falha ao se increver na partida",
          "Jogador já inscrito na partida.",
        );
      }
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

      if (result == true && !_isDisposed && mounted) {
        Navigator.pop(context);

        _safeSetState(() {
          _model.getUserInfoAndAccountInfoAsync(_safeSetState, context);
          _model.loadMatches(_safeSetState);
        });
      }
    }
  }

  String formatHour(DateTime? dateTime) {
    if (dateTime == null) return '';
    final hour = dateTime.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    return '${formattedHour}h$period';
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
    if (_isDisposed || !mounted) return;
    
    try {
      if (!_isDisposed && mounted) {
        Navigator.pop(context);
      }
      
      await _model.leaveMatchAsync(match.id);
      
      if (!_isDisposed && mounted) {
        _safeSetState(() {
          _model.getUserInfoAndAccountInfoAsync(_safeSetState, context);
          _model.loadMatches(_safeSetState);
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
      }
    } catch (e) {
      if (!_isDisposed && mounted) {
        Warning00ErrorUtil.showDialogMessageError(
          context,
          "Erro ao sair da partida",
          "Ocorreu um erro ao tentar sair da partida. Tente novamente.",
        );
      }
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
          if (!_isDisposed && mounted) {
            if (isRegistered) {
              await onLeave(match);
            } else {
              await onJoin(match);
            }
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