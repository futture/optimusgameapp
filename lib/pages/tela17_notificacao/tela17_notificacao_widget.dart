import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:projeto_game_quiz/components/moda_menu_pagian_inicial_widget.dart';
import 'package:projeto_game_quiz/core/models/common/error_response.dart';
import 'package:projeto_game_quiz/core/models/requests/match_request.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_icon_button.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_widgets.dart';
import 'package:projeto_game_quiz/pages/tela13_dados_de_partida/tela13_dados_de_partida_widget.dart';
import 'package:projeto_game_quiz/pages/tela17_notificacao/tela17_notificacao_model.dart';

class Tela17NotificacaoViewWidget extends StatefulWidget {
  const Tela17NotificacaoViewWidget({super.key});

  static String routeName = 'Tela17Notificacao';
  static String routePath = '/tela17Notificacao';

  @override
  State<Tela17NotificacaoViewWidget> createState() =>
      _Tela17NotificacaoViewWidgetState();
}

class _Tela17NotificacaoViewWidgetState
    extends State<Tela17NotificacaoViewWidget> with TickerProviderStateMixin {
  late Tela17NotificacaoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final int _notificationsPerPage = 8;
  int _currentPage = 0;
  bool _isLoadingMore = false;
  bool _hasMoreNotifications = true;
  int? _loadingNotificationIndex;
  DetailErrorResponse? error;
  final List<StreamSubscription> _subscriptions = [];
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Sistema de cores da aplicação (laranja/dourado)
  final Color _primaryColor = Color(0xFFEC8D0D); // Laranja principal
  final Color _primaryDarkColor = Color(0xFFD87C00); // Laranja escuro
  final Color _backgroundColor = Color(0xFFF8FAFC); // Fundo claro
  final Color _surfaceColor = Colors.white; // Superfície
  final Color _onSurfaceColor = Color(0xFF1E293B); // Texto escuro
  final Color _outlineColor = Color(0xFFE2E8F0); // Bordas
  final Color _successColor = Color(0xFF10B981); // Verde
  final Color _warningColor = Color(0xFFF59E0B); // Laranja de aviso
  final Color _errorColor = Color(0xFFEF4444); // Vermelho
  final Color _infoColor = Color(0xFF3B82F6); // Azul

  // Gradientes premium com cores da aplicação
  final LinearGradient _premiumGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)], // Laranja
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _accentGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD87C00)], // Laranja mais escuro
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)], // Verde
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _errorGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)], // Vermelho
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela17NotificacaoModel());
    
    // Configuração das animações
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    
    _loadInitialData();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _model.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('dd/MM/yyyy • HH:mm').format(date);
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} dias atrás';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h atrás';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}min atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  IconData _getNotificationIcon(String? code) {
    switch (code) {
      case 'Desafio':
        return Icons.bolt_rounded;
      case 'Desqualificação':
        return Icons.gpp_maybe_rounded;
      case 'Erro ao inicio de super partida':
        return Icons.error_outline_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  Color _getNotificationColor(String? code, bool isNew) {
    if (isNew) {
      switch (code) {
        case 'Desafio':
          return Color(0xFFFFF7ED); // Fundo laranja claro para desafio
        case 'Desqualificação':
          return Color(0xFFFFFBEB); // Fundo amarelo claro para desqualificação
        case 'Erro ao inicio de super partida':
          return Color(0xFFFEF2F2); // Fundo vermelho claro para erro
        default:
          return Color(0xFFFEFCE8); // Fundo amarelo muito claro padrão
      }
    }
    return _surfaceColor;
  }

  LinearGradient _getIconGradient(String? code, bool isNew) {
    if (isNew) {
      switch (code) {
        case 'Desafio':
          return LinearGradient(
            colors: [Color(0xFFEC8D0D), Color(0xFFD87C00)], // Laranja
          );
        case 'Desqualificação':
          return LinearGradient(
            colors: [Color(0xFFF59E0B), Color(0xFFD97706)], // Laranja escuro
          );
        case 'Erro ao inicio de super partida':
          return LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFFDC2626)], // Vermelho
          );
        default:
          return _premiumGradient; // Laranja principal
      }
    }
    return LinearGradient(
      colors: [Color(0xFF94A3B8), Color(0xFF64748B)], // Cinza para não lidas
    );
  }

  Widget _buildStatusBadge(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.9), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 14,
          ),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ));
  }

  Future<void> _loadInitialData() async {
    try {
      await _model.loadAsync(setState);
      _checkIfHasMoreNotifications();
    } catch (e) {
      debugPrint('Erro ao carregar notificações: $e');
      if (mounted) {
        _showSnackBar(
          'Erro ao carregar notificações',
          _errorColor,
          Icons.error_outline_rounded,
        );
      }
    }
  }

  void _showSnackBar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _checkIfHasMoreNotifications() {
    if (mounted) {
      setState(() {
        _hasMoreNotifications = _model.pushNotifications.length >
            (_currentPage + 1) * _notificationsPerPage;
      });
    }
  }

  Future<void> _loadMoreNotifications() async {
    if (_isLoadingMore || !_hasMoreNotifications) return;

    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _currentPage++;
        _checkIfHasMoreNotifications();
        _isLoadingMore = false;
      });
    }
  }

  List<dynamic> get _visibleNotifications {
    final endIndex = (_currentPage + 1) * _notificationsPerPage;
    return _model.pushNotifications.length > endIndex
        ? _model.pushNotifications.sublist(0, endIndex)
        : _model.pushNotifications;
  }

  Future<void> _handleNotificationTap(int index) async {
    if (_loadingNotificationIndex != null) return;

    setState(() => _loadingNotificationIndex = index);
    final item = _model.pushNotifications[index];

    try {
      switch (item.code) {
        case "Desafio":
          await _handleChallengeNotification(item);
          break;
        case "Desqualificação":
          await _handleDisqualificationNotification(item);
          break;
        case "Erro ao inicio de super partida":
          await _handleErrorNotification(item);
          break;
        default:
          _showSnackBar(
            'Tipo de notificação não suportado: ${item.code}',
            _warningColor,
            Icons.warning_rounded,
          );
      }
    } catch (e) {
      debugPrint('Erro ao processar notificação: $e');
      _showSnackBar(
        'Erro ao processar notificação',
        _errorColor,
        Icons.error_outline_rounded,
      );
    } finally {
      if (mounted) {
        setState(() => _loadingNotificationIndex = null);
      }
    }
  }

  Future<void> _handleChallengeNotification(dynamic item) async {
    await _model.getPlayerByMatchIdAsync(setState, item.metaData!);
    await _model.getMatchByMatchIdAsync(setState, item.metaData!);

    if (!mounted) return;

    DadosDaPartidaUtils.showMatchParticipantsDialog(
      ctx: context,
      title: _model.match!.room!.roomType == RoomType.EVENT.label
          ? "Super partida"
          : "Desafio",
      currentUser: _model.currentUser,
      matchInfo: _model.match!,
      participants: _model.players,
      widget: _buildMatchStatusWidget(_model.match!.statusMatch),
    );
  }

  Future<void> _handleDisqualificationNotification(dynamic item) async {
    await _model.getPlayerByMatchIdAsync(setState, item.metaData!);
    await _model.getMatchByMatchIdAsync(setState, item.metaData!);

    if (!mounted) return;

    DadosDaPartidaUtils.showMatchParticipantsDialog(
      ctx: context,
      isError: true,
      title: "Desqualificação",
      currentUser: _model.currentUser,
      matchInfo: _model.match!,
      participants: _model.players,
      widget: _buildDisqualificationWidget(),
    );
  }

  Future<void> _handleErrorNotification(dynamic item) async {
    String matchId = "";
    try {
      if (item.metaData != null && item.metaData!.isNotEmpty) {
        final decoded = jsonDecode(item.metaData!);
        if (decoded is Map<String, dynamic>) {
          matchId = decoded["matchId"];
          final decodedError = jsonDecode(decoded["error"]);
          error = DetailErrorResponse.fromJson(decodedError);
        }
      }
    } catch (e) {
      debugPrint('Erro ao decodificar metaData: $e');
      error = DetailErrorResponse(
        detail: ErrorResponse(
          message: "Erro ao processar notificação",
          details: "Não foi possível ler os detalhes do erro",
        ),
      );
    }

    await _model.getPlayerByMatchIdAsync(setState, matchId);
    await _model.getMatchByMatchIdAsync(setState, matchId);

    if (!mounted) return;

    DadosDaPartidaUtils.showMatchParticipantsDialog(
      ctx: context,
      isError: true,
      title: "Erro na partida",
      currentUser: _model.currentUser,
      matchInfo: _model.match!,
      participants: _model.players,
      widget: _buildErrorWidget(),
    );
  }

  Widget _buildMatchStatusWidget(String? status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [ 
          const SizedBox(height: 12),
          _buildStatusDescription(status),
        ],
      ),
    );
  }

  Widget _buildStatusDescription(String? status) {
    switch (status?.toUpperCase()) {
      case 'PENDING':
        return Text(
          'Partida aguardando início dos jogadores',
          style: TextStyle(
            color: _onSurfaceColor.withOpacity(0.7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        );
      case 'IN_PROGRESS':
        return Text(
          'Partida em andamento - jogadores ativos',
          style: TextStyle(
            color: _onSurfaceColor.withOpacity(0.7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        );
      case 'COMPLETED':
        return Text(
          'Partida concluída com sucesso',
          style: TextStyle(
            color: _onSurfaceColor.withOpacity(0.7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        );
      case 'CANCELLED':
        return Text(
          'Partida cancelada pelos participantes',
          style: TextStyle(
            color: Colors.orange.withOpacity(0.7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        );
      case 'TERMINATED':
        return Text(
          'Partida terminada pelo sistema',
          style: TextStyle(
            color: _onSurfaceColor.withOpacity(0.7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        );
      default:
        return Text(
          'Status da partida: ${status ?? "Desconhecido"}',
          style: TextStyle(
            color: _onSurfaceColor.withOpacity(0.7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        );
    }
  }

  Widget _buildDisqualificationWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: _errorGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _errorColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.gpp_maybe_rounded, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  'DESQUALIFICADO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Jogador desqualificado por inatividade',
            style: TextStyle(
              color: _onSurfaceColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: _errorGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _errorColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  'ERRO NA PARTIDA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            error?.detail?.message ?? 'Erro na partida',
            style: TextStyle(
              color: _errorColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error?.detail?.details ?? 'Ocorreu um erro inesperado',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _onSurfaceColor.withOpacity(0.7),
              fontSize: 14,
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
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: Offset(0, (1 - _fadeAnimation.value) * 20),
              child: child,
            ),
          );
        },
        child: Column(
          children: [
            // Header Personalizado (ocupa toda largura)
            _buildCustomHeader(context, isMobile),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? double.infinity : 800, // Limitado a 800px na web
                  ),
                  child: _buildNotificationContent(context, isMobile),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: _premiumGradient, // Gradiente laranja
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
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 1200, // Header ocupa toda largura
          ),
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
                    // Botão Voltar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notificações',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 24 : 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          if (_model.pushNotifications.isNotEmpty)
                            Text(
                              '${_model.pushNotifications.length} notificaç${_model.pushNotifications.length == 1 ? 'ão' : 'ões'}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: isMobile ? 14 : 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Ícone de notificação
                    Container(
                      width: isMobile ? 44 : 52,
                      height: isMobile ? 44 : 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_active_rounded,
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
                    color: Colors.white.withOpacity(0.6), // Branco translúcido
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationContent(BuildContext context, bool isMobile) {
    if (_model.isLoading) {
      return _buildLoadingState(context, isMobile);
    }

    if (_model.pushNotifications.isEmpty) {
      return _buildEmptyState(context, isMobile);
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent &&
            !_isLoadingMore &&
            _hasMoreNotifications) {
          _loadMoreNotifications();
        }
        return false;
      },
      child: RefreshIndicator(
        color: _primaryColor, // Laranja principal
        backgroundColor: _surfaceColor,
        displacement: 40,
        onRefresh: () async {
          _currentPage = 0;
          await _loadInitialData();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 24,
                vertical: 20,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < _visibleNotifications.length) {
                      final item = _visibleNotifications[index];
                      final isNew = item.isNew ?? false;
                      final isLoading = _loadingNotificationIndex == index;

                      return Padding(
                        padding: EdgeInsets.only(bottom: isMobile ? 16 : 20),
                        child: _buildAnimatedNotificationItem(
                            item, isNew, isLoading, index, context, isMobile),
                      );
                    }
                    return null;
                  },
                  childCount: _visibleNotifications.length,
                ),
              ),
            ),
            if (_isLoadingMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 24.0 : 32.0),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 16 : 20),
                      decoration: BoxDecoration(
                        color: _surfaceColor,
                        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: isMobile ? 20 : 24,
                        height: isMobile ? 20 : 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (_hasMoreNotifications && !_isLoadingMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20.0 : 24.0,
                    vertical: 20.0,
                  ),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _loadMoreNotifications,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _surfaceColor,
                          foregroundColor: _primaryColor, // Texto laranja
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 32 : 40,
                            vertical: isMobile ? 16 : 20,
                          ),
                          shadowColor: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Carregar Mais',
                              style: TextStyle(
                                fontSize: isMobile ? 15 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: isMobile ? 12 : 16),
                            Icon(
                              Icons.expand_more_rounded,
                              size: isMobile ? 20 : 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedNotificationItem(
      dynamic item, bool isNew, bool isLoading, int index, BuildContext context, bool isMobile) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Dismissible(
        key: ValueKey(item.id ?? index),
        background: _buildDismissibleBackground(
            Icons.check_circle_rounded, _successColor, Alignment.centerLeft, isMobile),
        secondaryBackground: _buildDismissibleBackground(
            Icons.delete_forever_rounded, _errorColor, Alignment.centerRight, isMobile),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            //await _model.markAsRead(item.id);
            return true;
          } else {
            return await _showDeleteConfirmationDialog(context, isMobile);
          }
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            _showSnackBar(
              'Notificação marcada como lida',
              _successColor,
              Icons.check_circle_rounded,
            );
          } else {
            _showSnackBar(
              'Notificação removida',
              _errorColor,
              Icons.delete_rounded,
            );
          }
          //_model.removeNotification(item.id);
        },
        child: _buildNotificationItem(item, isNew, isLoading, index, context, isMobile),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context, bool isMobile) async {
    return await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _surfaceColor,
        surfaceTintColor: _surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 500, // Limitado na web
          ),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 24 : 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: isMobile ? 60 : 72,
                  height: isMobile ? 60 : 72,
                  decoration: BoxDecoration(
                    color: _errorColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_forever_rounded,
                    color: _errorColor,
                    size: isMobile ? 30 : 36,
                  ),
                ),
                SizedBox(height: isMobile ? 16 : 20),
                Text(
                  'Excluir Notificação?',
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.w800,
                    color: _onSurfaceColor,
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 12),
                Text(
                  'Esta ação não pode ser desfeita.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _onSurfaceColor.withOpacity(0.6),
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
                SizedBox(height: isMobile ? 24 : 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _onSurfaceColor,
                          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                          ),
                          side: BorderSide(color: _outlineColor),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? 14 : 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isMobile ? 12 : 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _errorColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                          ),
                        ),
                        child: Text(
                          'Excluir',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: isMobile ? 14 : 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ) ?? false;
  }

  Widget _buildDismissibleBackground(
      IconData icon, Color color, Alignment alignment, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 32),
      child: Icon(icon, color: color, size: isMobile ? 28 : 32),
    );
  }

  Widget _buildNotificationItem(
      dynamic item, bool isNew, bool isLoading, int index, BuildContext context, bool isMobile) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        onTap: () => _handleNotificationTap(index),
        child: Container(
          decoration: BoxDecoration(
            color: _getNotificationColor(item.code, isNew),
            borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
            border: Border.all(
              color: isNew ? _primaryColor.withOpacity(0.1) : _outlineColor,
              width: isNew ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(isMobile ? 20 : 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isLoading
                    ? _buildLoadingIndicator(isMobile)
                    : _buildNotificationIcon(item.code, isNew, isMobile),
              ),
              SizedBox(width: isMobile ? 16 : 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.subject ?? 'Sem assunto',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: _onSurfaceColor,
                                        fontSize: isMobile ? 16 : 18,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isNew && !isLoading) 
                                    _buildNewNotificationBadge(isMobile),
                                ],
                              ),
                              SizedBox(height: isMobile ? 8 : 12),
                              Text(
                                item.message ?? '',
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 16,
                                  color: _onSurfaceColor.withOpacity(0.8),
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isMobile ? 12 : 16),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: isMobile ? 14 : 16,
                          color: _onSurfaceColor.withOpacity(0.5),
                        ),
                        SizedBox(width: isMobile ? 6 : 8),
                        Text(
                          _formatDate(item.createdAt ?? DateTime.now()),
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 14,
                            color: _onSurfaceColor.withOpacity(0.5),
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Spacer(), 
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

  Widget _buildLoadingIndicator(bool isMobile) {
    return Container(
      width: isMobile ? 52 : 64,
      height: isMobile ? 52 : 64,
      decoration: BoxDecoration(
        color: _surfaceColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: isMobile ? 22 : 26,
          height: isMobile ? 22 : 26,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String? code, bool isNew, bool isMobile) {
    return Container(
      width: isMobile ? 52 : 64,
      height: isMobile ? 52 : 64,
      decoration: BoxDecoration(
        gradient: _getIconGradient(code, isNew),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _getIconGradient(code, isNew).colors[0].withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        _getNotificationIcon(code),
        color: Colors.white,
        size: isMobile ? 22 : 26,
      ),
    );
  }

  Widget _buildNewNotificationBadge(bool isMobile) {
    return Container(
      width: isMobile ? 10 : 12,
      height: isMobile ? 10 : 12,
      margin: EdgeInsets.only(left: isMobile ? 8 : 12, top: isMobile ? 6 : 8),
      decoration: BoxDecoration(
        gradient: _accentGradient, // Gradiente laranja
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.4),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, bool isMobile) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 800),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isMobile ? 100 : 120,
              height: isMobile ? 100 : 120,
              decoration: BoxDecoration(
                gradient: _premiumGradient, // Gradiente laranja
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.2),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: SizedBox(
                  width: isMobile ? 40 : 48,
                  height: isMobile ? 40 : 48,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: isMobile ? 32 : 40),
            Text(
              'Carregando Notificações',
              style: TextStyle(
                fontSize: isMobile ? 18 : 22,
                color: _onSurfaceColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: isMobile ? 8 : 12),
            Text(
              'Preparando sua central de notificações...',
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: _onSurfaceColor.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isMobile) {
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 800),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 40.0 : 48.0,
              vertical: isMobile ? 40.0 : 48.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: isMobile ? 180 : 200,
                  height: isMobile ? 180 : 200,
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.notifications_off_rounded,
                    size: isMobile ? 80 : 96,
                    color: _onSurfaceColor.withOpacity(0.3),
                  ),
                ),
                SizedBox(height: isMobile ? 40 : 48),
                Text(
                  'Nenhuma Notificação',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    color: _onSurfaceColor,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: isMobile ? 16 : 20),
                Text(
                  'Você está atualizado! Novas notificações\naparecerão aqui automaticamente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    color: _onSurfaceColor.withOpacity(0.6),
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: isMobile ? 40 : 48),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.2),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _loadInitialData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor, // Laranja
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 32 : 40,
                        vertical: isMobile ? 18 : 20,
                      ),
                      shadowColor: Colors.transparent,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: isMobile ? 20 : 22,
                        ),
                        SizedBox(width: isMobile ? 12 : 16),
                        Text(
                          'Atualizar',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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
}