import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:projeto_game_quiz/components/moda_menu_pagian_inicial_widget.dart';
import 'package:projeto_game_quiz/core/models/common/error_response.dart';
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
    extends State<Tela17NotificacaoViewWidget> {
  late Tela17NotificacaoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final int _notificationsPerPage = 5;
  int _currentPage = 0;
  bool _isLoadingMore = false;
  bool _hasMoreNotifications = true;
  int? _loadingNotificationIndex;
  DetailErrorResponse? error;
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela17NotificacaoModel());
    _loadInitialData();
  }

  @override
  void dispose() {
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
      return DateFormat('dd/MM/yyyy').format(date);
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} dias atrás';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} horas atrás';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutos atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  IconData _getNotificationIcon(String? code) {
    switch (code) {
      case 'Desafio':
        return Icons.sports_esports;
      case 'Desqualificação':
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String? code, bool isNew) {
    if (isNew) {
      switch (code) {
        case 'Desafio':
          return Colors.blue.shade50;
        case 'Desqualificação':
          return Colors.orange.shade50;
        default:
          return Colors.deepPurple.shade50;
      }
    }
    return Colors.white;
  }

  Future<void> _loadInitialData() async {
    try {
      await _model.loadAsync(setState);
      _checkIfHasMoreNotifications();
    } catch (e) {
      debugPrint('Erro ao carregar notificações: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao carregar notificações'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
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
    await Future.delayed(
        const Duration(milliseconds: 800)); // Simula carregamento

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

  Color _getIconColor(String? code, bool isNew) {
    if (!isNew) return Colors.grey.shade600;

    switch (code) {
      case 'Desafio':
        return Colors.blue.shade600;
      case 'Desqualificação':
        return Colors.orange.shade800;
      case 'Erro ao inicio de super partida':
        return Colors.red.shade600;
      default:
        return Theme.of(context).primaryColor;
    }
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
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Tipo de notificação não suportado: ${item.code}'),
                backgroundColor: Colors.orange.shade600,
              ),
            );
          }
      }
    } catch (e) {
      debugPrint('Erro ao processar notificação: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao processar notificação'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
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
      title: _model.match!.room!.roomConfiguration!.isEvent!
          ? "Super partida"
          : "Desafio",
      currentUser: _model.currentUser,
      matchInfo: _model.match!,
      participants: _model.players,
      widget: _model.match!.statusMatch == "PENDING"
          ? null
          : _buildMatchEndedWidget(),
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

  Widget _buildMatchEndedWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            'Partida terminada...',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: const Color(0xFFEC8D0D),
                  fontSize: 14,
                  letterSpacing: 0,
                ),
          ),
          Text(
            'Partida já fechada',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisqualificationWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Icon(
            Icons.sentiment_very_dissatisfied,
            color: Colors.red.shade600,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            'Jogador desqualificado...',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: Colors.red.shade600,
                  fontSize: 18,
                  letterSpacing: 0,
                ),
          ),
          Text(
            'Jogador desqualificado por inatividade',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0,
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
          Icon(
            Icons.sentiment_very_dissatisfied,
            color: Colors.red.shade600,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            error?.detail?.message ?? 'Erro na partida',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: Colors.red.shade600,
                  fontSize: 18,
                  letterSpacing: 0,
                ),
          ),
          Text(
            error?.detail?.details ?? 'Ocorreu um erro inesperado',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0,
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
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(18.0, 0.0, 0.0, 0.0),
          child: FlutterFlowIconButton(
            borderRadius: 8.0,
            buttonSize: 45.0,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            icon: const FaIcon(
              FontAwesomeIcons.bars,
              color: Colors.black,
              size: 24.0,
            ),
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: const ModaMenuPagianInicialWidget(),
                    ),
                  );
                },
              ).then((value) => safeSetState(() {}));
            },
          ),
        ),
        title: Text(
          'NOTIFICAÇÕES',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                color: const Color(0xFFEC8D0D),
                letterSpacing: 0.0,
              ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (_model.pushNotifications.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  '${_model.pushNotifications.length}',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: const Color(0xFFEC8D0D),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
        ],
      ),
      body: _buildNotificationContent(),
    );
  }

  Widget _buildNotificationContent() {
    if (_model.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEC8D0D)),
            ),
            SizedBox(height: 16),
            Text(
              'Carregando notificações...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_model.pushNotifications.isEmpty) {
      return _buildEmptyState();
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
        color: const Color(0xFFEC8D0D),
        onRefresh: () async {
          _currentPage = 0;
          await _loadInitialData();
        },
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < _visibleNotifications.length) {
                    final item = _visibleNotifications[index];
                    final isNew = item.isNew ?? false;
                    final isLoading = _loadingNotificationIndex == index;

                    return _buildAnimatedNotificationItem(
                        item, isNew, isLoading, index);
                  }
                  return null;
                },
                childCount: _visibleNotifications.length,
              ),
            ),
            if (_isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFEC8D0D)),
                    ),
                  ),
                ),
              ),
            if (_hasMoreNotifications && !_isLoadingMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FFButtonWidget(
                    onPressed: _loadMoreNotifications,
                    text: 'Ver mais',
                    icon: const Icon(Icons.expand_more, size: 20),
                    options: FFButtonOptions(
                      width: 150,
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: const Color(0xFFEC8D0D),
                      textStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 0.0,
                              ),
                      elevation: 1,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedNotificationItem(
      dynamic item, bool isNew, bool isLoading, int index) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Dismissible(
        key: ValueKey(item.id ?? index),
        background: Container(
          color: Colors.red.shade100,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.red),
        ),
        secondaryBackground: Container(
          color: Colors.green.shade100,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(Icons.check, color: Colors.green),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // Marcar como lida
            //await _model.markAsRead(item.id);
            return true;
          } else {
            // Excluir notificação
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Excluir notificação'),
                content:
                    const Text('Deseja realmente excluir esta notificação?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Excluir',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          }
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notificação marcada como lida'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notificação removida'),
                backgroundColor: Colors.red,
              ),
            );
          }
          //_model.removeNotification(item.id);
        },
        child: _buildNotificationItem(item, isNew, isLoading, index),
      ),
    );
  }

  Widget _buildNotificationItem(
      dynamic item, bool isNew, bool isLoading, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: _getNotificationColor(item.code, isNew),
        border: Border(
          left: BorderSide(
            color: isNew ? _getIconColor(item.code, isNew) : Colors.transparent,
            width: 4,
          ),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _handleNotificationTap(index),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isLoading
                    ? _buildLoadingIndicator()
                    : _buildNotificationIcon(item.code, isNew),
              ),
              const SizedBox(width: 12),
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
                              fontWeight:
                                  isNew ? FontWeight.bold : FontWeight.normal,
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isNew && !isLoading) _buildNewNotificationBadge(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(item.createdAt ?? DateTime.now()),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
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

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 40,
      height: 40,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            const Color(0xFFEC8D0D),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String? code, bool isNew) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isNew
            ? _getIconColor(code, isNew).withOpacity(0.2)
            : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getNotificationIcon(code),
        color: _getIconColor(code, isNew),
        size: 20,
      ),
    );
  }

  Widget _buildNewNotificationBadge() {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(left: 4),
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/empty_notifications.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Text(
                'Nenhuma notificação encontrada',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Você será notificado quando houver novas atividades',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 24),
              FFButtonWidget(
                onPressed: _loadInitialData,
                text: 'Recarregar',
                icon: const Icon(Icons.refresh, size: 20),
                options: FFButtonOptions(
                  width: 150,
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: const Color(0xFFEC8D0D),
                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 0.0,
                      ),
                  elevation: 1,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
