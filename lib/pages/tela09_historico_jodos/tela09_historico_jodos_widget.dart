import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:projeto_game_quiz/components/moda_menu_pagian_inicial_widget.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/core/models/responses/ranking_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_icon_button.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/pages/tela09_historico_jodos/tela09_historico_jodos_model.dart';

class Tela09HistoricoJodosWidget extends StatefulWidget {
  const Tela09HistoricoJodosWidget({super.key});
  static String routeName = 'Tela09HistoricoJodos';
  static String routePath = '/tela09HistoricoJodos';

  @override
  State<Tela09HistoricoJodosWidget> createState() =>
      _Tela09HistoricoJodosWidgetState();
}

class _Tela09HistoricoJodosWidgetState extends State<Tela09HistoricoJodosWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Tela09HistoricoJodosModel _model;
  bool _expandPremioInfo = false;
  late TabController _tabController;

  String _filterResult = 'all'; // 'all', 'winner', 'loser'
  String _filterStatus = 'all'; // 'all', 'pending', 'in_progress'
  DateTimeRange? _dateRange;
  DateTimeRange? _dateRangeRanking;
  int _currentIndex = 0;
  final List<String> _statusOptions = [
    'PENDING',
    'IN_PROGRESS',
    'WAITING_FOR_START',
    'CANCELLED'
  ];

  // Cores do tema premium alinhadas com sua app
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _primaryDark = Color(0xFFD17A0A);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);
  final Color _successColor = Color(0xFF10B981);
  final Color _errorColor = Color(0xFFEF4444);
  final Color _warningColor = Color(0xFFF59E0B);
  final Color _infoColor = Color(0xFF3B82F6);

  // Gradientes premium
  final LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela09HistoricoJodosModel());
    _tabController = TabController(length: 2, vsync: this);
    _model.load(setState);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _model.dispose();
    super.dispose();
  }

  List<RankingResponse> _getFilteredRankings(bool isCompleted) {
    List<RankingResponse> rankings = isCompleted
        ? _model.rankings.where((r) => r.isCompleted == true).toList()
        : _model.rankings.where((r) => r.isCompleted != true).toList();

    if (isCompleted) {
      if (_filterResult == 'winner') {
        return rankings.where((r) => r.isWinner == true).toList();
      } else if (_filterResult == 'loser') {
        return rankings.where((r) => r.isWinner == false).toList();
      }
    }
    return rankings;
  }

  List<MatchResponse> _getFilteredMatches() {
    List<MatchResponse> matches = _model.matches;

    if (_filterStatus != 'all') {
      matches = matches.where((m) => m.statusMatch == _filterStatus).toList();
    }

    if (_dateRange != null) {
      matches = matches.where((m) {
        return m.matchStartDate.isAfter(_dateRange!.start) &&
            m.matchStartDate.isBefore(_dateRange!.end);
      }).toList();
    }

    return matches;
  }

  Future<void> _selectDateRange(BuildContext context,
      {bool isRanking = false}) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    final DateTimeRange? picked;
    if (!isRanking) {
      picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        initialDateRange: _dateRange,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: Size(
                isMobile ? screenWidth - 32 : 600,
                500,
              ),
            ),
            child: child ?? SizedBox(),
          );
        },
      );
    } else {
      picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        initialDateRange: _dateRangeRanking,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: Size(
                isMobile ? screenWidth - 32 : 600,
                500,
              ),
            ),
            child: child ?? SizedBox(),
          );
        },
      );
    }

    if (picked != null) {
      setState(() {
        if (!isRanking) {
          _dateRange = picked;
          _model.param.endDate = _dateRange?.end;
          _model.param.startDate = _dateRange?.start;
        } else {
          _dateRangeRanking = picked;
          _model.param.endDate = _dateRangeRanking?.end;
          _model.param.startDate = _dateRangeRanking?.start;
        }
      });
      if (!isRanking)
        await _model.getMatchByUserIdAsync(setState);
      else
        await _model.getRankingByUserdAsync(setState);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final safePadding = MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _backgroundColor,
        body: Column(
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
                    horizontal: isMobile ? 16 : 32,
                    vertical: isMobile ? 12 : 16,
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
                              onPressed: () async {
                                context.safePop();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                                size: isMobile ? 18 : 22,
                              ),
                              splashRadius: isMobile ? 20 : 24,
                            ),
                          ),
                          SizedBox(width: isMobile ? 12 : 20),
                          Expanded(
                            child: Text(
                              'HISTÓRICO DE JOGOS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 18 : 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          // Ícone de histórico
                          Container(
                            width: isMobile ? 40 : 48,
                            height: isMobile ? 40 : 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.history_rounded,
                              color: Colors.white,
                              size: isMobile ? 20 : 24,
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

            // TabBar Premium
            Container(
              decoration: BoxDecoration(
                color: _surfaceColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 1200),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: _primaryColor,
                      unselectedLabelColor: _onSurfaceColor.withOpacity(0.6),
                      indicatorColor: _primaryColor,
                      indicatorWeight: 3,
                      indicatorPadding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8),
                      labelStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: isMobile ? 13 : 15,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: isMobile ? 13 : 15,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: [
                        Tab(text: 'Partidas Concluídas'),
                        Tab(text: 'Partidas Pendentes'),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 1200),
                  child: _model.isLoadingRanking || _model.isLoadingAllMach
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Color(0xFFEC8D0D)),
                          ),
                        )
                      : _model.rankings.isEmpty && _model.matches.isEmpty
                          ? Column(
                              children: [
                                if (_currentIndex == 0)
                                  _buildCompletedFilters(isMobile)
                                else
                                  _buildPendingFilters(isMobile),
                                SizedBox(height: isMobile ? 12 : 16),
                                Expanded(child: _buildEmptyState(isMobile: isMobile))
                              ],
                            )
                          : Column(
                              children: [
                                // Filtros
                                if (_currentIndex == 0)
                                  _buildCompletedFilters(isMobile)
                                else
                                  _buildPendingFilters(isMobile),

                                SizedBox(height: isMobile ? 12 : 16),

                                // Conteúdo das Tabs
                                Expanded(
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      _buildGamesList(true, isMobile),
                                      _buildMatchesList(isMobile),
                                    ],
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

  Widget _buildEmptyState({bool isMobile = false}) {
    return Center(
        child: Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isMobile ? 80 : 100,
            height: isMobile ? 80 : 100,
            decoration: BoxDecoration(
              color: _outlineColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.videogame_asset_outlined,
              color: _onSurfaceColor.withOpacity(0.4),
              size: isMobile ? 32 : 40,
            ),
          ),
          SizedBox(height: isMobile ? 16 : 24),
          Text(
            'Nenhum histórico de jogos encontrado',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: _onSurfaceColor.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 16 : 24),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
              child: InkWell(
                borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                onTap: () => _model.load(setState),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : 32, 
                    vertical: isMobile ? 12 : 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: _primaryGradient,
                    borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                        size: isMobile ? 20 : 22,
                      ),
                      SizedBox(width: isMobile ? 8 : 12),
                      Text(
                        'RECARREGAR',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildCompletedFilters(bool isMobile) {
    return Container(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        decoration: BoxDecoration(
          color: _surfaceColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    label: 'Todas',
                    selected: _filterResult == 'all',
                    onSelected: (selected) {
                      setState(() {
                        _filterResult = selected ? 'all' : _filterResult;
                      });
                    },
                    isMobile: isMobile,
                  ),
                  SizedBox(width: isMobile ? 8 : 12),
                  _buildFilterChip(
                    label: 'Vitórias',
                    selected: _filterResult == 'winner',
                    onSelected: (selected) {
                      setState(() {
                        _filterResult = selected ? 'winner' : _filterResult;
                      });
                    },
                    isMobile: isMobile,
                  ),
                  SizedBox(width: isMobile ? 8 : 12),
                  _buildFilterChip(
                    label: 'Derrotas',
                    selected: _filterResult == 'loser',
                    onSelected: (selected) {
                      setState(() {
                        _filterResult = selected ? 'loser' : _filterResult;
                      });
                    },
                    isMobile: isMobile,
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                        onTap: () => _selectDateRange(context, isRanking: true),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: isMobile ? 12 : 16, 
                              horizontal: isMobile ? 16 : 20,
                          ),
                          decoration: BoxDecoration(
                            color: _surfaceColor,
                            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                            border: Border.all(
                              color: _outlineColor,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: isMobile ? 16 : 18,
                                color: _primaryColor,
                              ),
                              SizedBox(width: isMobile ? 8 : 12),
                              Expanded(
                                child: Text(
                                  _dateRangeRanking == null
                                      ? 'Filtrar por data'
                                      : '${DateFormat('dd/MM/yyyy').format(_dateRangeRanking!.start)} - ${DateFormat('dd/MM/yyyy').format(_dateRangeRanking!.end)}',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: isMobile ? 14 : 15,
                                    fontWeight: FontWeight.w500,
                                    color: _onSurfaceColor,
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
                  ),
                ),
                if (_dateRangeRanking != null) ...[
                  SizedBox(width: isMobile ? 8 : 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                      boxShadow: [
                        BoxShadow(
                          color: _errorColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                        onTap: () {
                          setState(() {
                            _dateRange = null;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(isMobile ? 12 : 16),
                          decoration: BoxDecoration(
                            color: _surfaceColor,
                            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                            border: Border.all(
                              color: _errorColor,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.clear_rounded,
                            color: _errorColor,
                            size: isMobile ? 20 : 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ));
  }

  Widget _buildPendingFilters(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'Todas',
                  selected: _filterStatus == 'all',
                  onSelected: (selected) {
                    setState(() {
                      _filterStatus = selected ? 'all' : _filterStatus;
                    });
                  },
                  isMobile: isMobile,
                ),
                SizedBox(width: isMobile ? 8 : 12),
                ..._statusOptions.map((status) {
                  return Padding(
                    padding: EdgeInsets.only(right: isMobile ? 8.0 : 12.0),
                    child: _buildFilterChip(
                      label: _getStatusLabel(status),
                      selected: _filterStatus == status,
                      onSelected: (selected) {
                        setState(() {
                          _filterStatus = selected ? status : _filterStatus;
                        });
                      },
                      isMobile: isMobile,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                      onTap: () => _selectDateRange(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 12 : 16, 
                          horizontal: isMobile ? 16 : 20,
                        ),
                        decoration: BoxDecoration(
                          color: _surfaceColor,
                          borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                          border: Border.all(
                            color: _outlineColor,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: isMobile ? 16 : 18,
                              color: _primaryColor,
                            ),
                            SizedBox(width: isMobile ? 8 : 12),
                            Expanded(
                              child: Text(
                                _dateRange == null
                                    ? 'Filtrar por data'
                                    : '${DateFormat('dd/MM/yyyy').format(_dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_dateRange!.end)}',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: isMobile ? 14 : 15,
                                  fontWeight: FontWeight.w500,
                                  color: _onSurfaceColor,
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
                ),
              ),
              if (_dateRange != null) ...[
                SizedBox(width: isMobile ? 8 : 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                    boxShadow: [
                      BoxShadow(
                        color: _errorColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                      onTap: () {
                        setState(() {
                          _dateRange = null;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(isMobile ? 12 : 16),
                        decoration: BoxDecoration(
                          color: _surfaceColor,
                          borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                          border: Border.all(
                            color: _errorColor,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.clear_rounded,
                          color: _errorColor,
                          size: isMobile ? 20 : 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
    required bool isMobile,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isMobile ? 13 : 14,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : _onSurfaceColor,
          ),
        ),
        selected: selected,
        onSelected: onSelected,
        backgroundColor: _surfaceColor,
        selectedColor: _primaryColor,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
          side: BorderSide(
            color: selected ? _primaryColor : _outlineColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'PENDING':
        return 'Pendentes';
      case 'IN_PROGRESS':
        return 'Em Andamento';
      case 'CANCELLED':
        return 'Canceladas';
      case 'WAITING_FOR_START':
        return 'Aguardando Inicio';
      default:
        return status;
    }
  }

  Widget _buildGamesList(bool isCompleted, bool isMobile) {
    final filteredRankings = _getFilteredRankings(isCompleted);

    if (filteredRankings.isEmpty) {
      return _buildEmptyGamesList(isCompleted, isMobile);
    }

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          children: [
            // Cabeçalho da Tabela - APENAS PARA DESKTOP
            if (!isMobile)
              Container(
                padding: EdgeInsets.all(isMobile ? 16 : 20),
                decoration: BoxDecoration(
                  color: _surfaceColor,
                  borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(width: 48), // Espaço para o ícone de expansão
                    Expanded(
                      flex: 2,
                      child: Text(
                        'DATA',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 12 : 13,
                          color: _onSurfaceColor.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'RESULTADO',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 12 : 13,
                          color: _onSurfaceColor.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'TEMPO',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 12 : 13,
                          color: _onSurfaceColor.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'PONTOS',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 12 : 13,
                          color: _onSurfaceColor.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            if (!isMobile) SizedBox(height: isMobile ? 12 : 16),
            // Lista de Jogos
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredRankings.length,
              itemBuilder: (context, index) {
                final ranking = filteredRankings[index];
                return _buildGameCard(ranking, isMobile);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchesList(bool isMobile) {
    final filteredMatches = _getFilteredMatches();

    if (filteredMatches.isEmpty) {
      return _buildEmptyMatchesList(isMobile);
    }

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: _model.isLoadingAllMach
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEC8D0D)),
                ),
              )
            : Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredMatches.length,
                    itemBuilder: (context, index) {
                      final match = filteredMatches[index];
                      return _buildPendingMatchCard(match, isMobile);
                    },
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPendingMatchCard(MatchResponse match, bool isMobile) {
    final matchStartDate = match.matchStartDate ?? DateTime.now();

    return Container(
      margin: EdgeInsets.only(bottom: isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        child: Column(
          children: [
            // Header do Card com Ícone - SETA NO TOPO
            Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ícone de expandir no lado ESQUERDO (no topo)
                  Container(
                    width: isMobile ? 40 : 48,
                    height: isMobile ? 40 : 48,
                    decoration: BoxDecoration(
                      color: _backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          match.isExpanded = !(match.isExpanded ?? false);
                        });
                      },
                      icon: Icon(
                        match.isExpanded ?? false
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        color: _primaryColor,
                        size: isMobile ? 20 : 24,
                      ),
                      padding: EdgeInsets.zero,
                      splashRadius: isMobile ? 20 : 24,
                    ),
                  ),

                  SizedBox(width: isMobile ? 12 : 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: isMobile ? 32 : 40,
                              height: isMobile ? 32 : 40,
                              decoration: BoxDecoration(
                                color: _primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.sports_esports_rounded,
                                color: _primaryColor,
                                size: isMobile ? 16 : 20,
                              ),
                            ),
                            SizedBox(width: isMobile ? 12 : 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(matchStartDate),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      fontSize: isMobile ? 16 : 18,
                                      color: _onSurfaceColor,
                                    ),
                                  ),
                                  SizedBox(height: isMobile ? 2 : 4),
                                  Text(
                                    DateFormat('HH:mm').format(matchStartDate),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: _onSurfaceColor.withOpacity(0.6),
                                      fontSize: isMobile ? 14 : 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isMobile ? 12 : 16),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 12 : 16, 
                            vertical: isMobile ? 6 : 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(match.statusMatch)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
                            border: Border.all(
                              color: _getStatusColor(match.statusMatch)
                                  .withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            _getStatusLabel(match.statusMatch ?? 'PENDING'),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: _getStatusColor(match.statusMatch),
                              fontWeight: FontWeight.w600,
                              fontSize: isMobile ? 12 : 13,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Conteúdo expandido
            if (match.isExpanded ?? false) ...[
              Divider(height: 1, color: _outlineColor),
              Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 20),
                child: Column(
                  children: [
                    _buildMatchInfoRow(
                      icon: Icons.people_rounded,
                      label: 'Jogadores',
                      value:
                          '${match.matchPlayers?.length ?? 0}/${match.room?.roomConfiguration?.numberOfPlayers ?? 0}',
                      isMobile: isMobile,
                    ),
                    SizedBox(height: isMobile ? 12 : 16),
                    _buildMatchInfoRow(
                      icon: Icons.emoji_events_rounded,
                      label: 'Prêmio Total',
                      value:
                          '${match.matchPrize?.totalGain?.toStringAsFixed(2) ?? '0.00'} AOA',
                      isMobile: isMobile,
                    ),
                    if (match.matchPlayers != null &&
                        match.matchPlayers!.isNotEmpty) ...[
                      SizedBox(height: isMobile ? 20 : 24),
                      Text(
                        'Jogadores Participantes',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 16 : 18,
                          color: _onSurfaceColor,
                        ),
                      ),
                      SizedBox(height: isMobile ? 12 : 16),
                      ...match.matchPlayers!.map((player) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: isMobile ? 8.0 : 12.0),
                          child: _buildPlayerTile(player.userResponse,
                              currentUser: _model.currentUser, isMobile: isMobile),
                        );
                      }).toList(),
                    ],
                    if (match.statusMatch == 'PENDING') ...[
                      SizedBox(height: isMobile ? 20 : 24),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                          boxShadow: [
                            BoxShadow(
                              color: _errorColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                            onTap: () async {
                              await _model.leaveTheMatchAsync(
                                  setState, match.id);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: isMobile ? 16 : 20, 
                                horizontal: isMobile ? 24 : 32,
                              ),
                              decoration: BoxDecoration(
                                color: _errorColor,
                                borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                              ),
                              child: _model.isLoadingLeave
                                  ? Center(
                                      child: SizedBox(
                                        width: isMobile ? 20 : 24,
                                        height: isMobile ? 20 : 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.exit_to_app_rounded,
                                          color: Colors.white, 
                                          size: isMobile ? 20 : 22,
                                        ),
                                        SizedBox(width: isMobile ? 8 : 12),
                                        Text(
                                          'SAIR DA PARTIDA',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Colors.white,
                                            fontSize: isMobile ? 16 : 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMatchInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        border: Border.all(
          color: _outlineColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 40 : 48,
            height: isMobile ? 40 : 48,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: isMobile ? 20 : 24,
              color: _primaryColor,
            ),
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: _onSurfaceColor.withOpacity(0.6),
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    color: _onSurfaceColor,
                    fontSize: isMobile ? 16 : 18,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(RankingResponse ranking, bool isMobile) {
    final createdAt = ranking.createdAt ?? DateTime.now();
    final isWinner = ranking.isWinner ?? false;
    final totalScore = ranking.totalScore ?? 0;
    final totalResponseTime = ranking.totalResponseTime ?? 0;

    if (isMobile) {
      // Layout mobile otimizado
      return Container(
        margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
          child: Column(
            children: [
              // Header do Card - Layout vertical para mobile
              Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 20),
                child: Column(
                  children: [
                    // Linha 1: Data e Resultado - COM SETA NO TOPO
                    Row(
                      children: [
                        // Ícone de expandir NO LADO ESQUERDO
                        Container(
                          width: isMobile ? 40 : 48,
                          height: isMobile ? 40 : 48,
                          decoration: BoxDecoration(
                            color: _backgroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              setState(() {
                                ranking.isExpanded =
                                    !(ranking.isExpanded ?? false);
                              });
                              if (ranking.isExpanded ?? false) {
                                await _model.getHistoryUserdAsync(
                                    setState, ranking.matchId);
                              }
                            },
                            icon: Icon(
                              ranking.isExpanded ?? false
                                  ? Icons.expand_less_rounded
                                  : Icons.expand_more_rounded,
                              color: _primaryColor,
                              size: isMobile ? 20 : 24,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),

                        SizedBox(width: isMobile ? 12 : 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: isMobile ? 32 : 40,
                                    height: isMobile ? 32 : 40,
                                    decoration: BoxDecoration(
                                      color: _primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.calendar_today_rounded,
                                      color: _primaryColor,
                                      size: isMobile ? 16 : 20,
                                    ),
                                  ),
                                  SizedBox(width: isMobile ? 8 : 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(createdAt),
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: isMobile ? 14 : 16,
                                            color: _onSurfaceColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                        ),
                                        SizedBox(height: isMobile ? 2 : 4),
                                        Text(
                                          DateFormat('HH:mm').format(createdAt),
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: isMobile ? 12 : 14,
                                            color: _onSurfaceColor
                                                .withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isMobile ? 12 : 16),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 12 : 16, 
                                  vertical: isMobile ? 6 : 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isWinner
                                      ? _successColor.withOpacity(0.1)
                                      : _errorColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                                  border: Border.all(
                                    color: isWinner
                                        ? _successColor.withOpacity(0.3)
                                        : _errorColor.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isWinner
                                          ? Icons.emoji_events_rounded
                                          : Icons
                                              .sentiment_dissatisfied_rounded,
                                      color: isWinner
                                          ? _successColor
                                          : _errorColor,
                                      size: isMobile ? 16 : 18,
                                    ),
                                    SizedBox(width: isMobile ? 6 : 8),
                                    Text(
                                      isWinner ? 'Vitória' : 'Derrota',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: isWinner
                                            ? _successColor
                                            : _errorColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: isMobile ? 12 : 14,
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

                    SizedBox(height: isMobile ? 16 : 20),

                    // Linha 2: Tempo e Pontos
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isMobile ? 12 : 16, 
                        horizontal: isMobile ? 16 : 20,
                      ),
                      decoration: BoxDecoration(
                        color: _backgroundColor,
                        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer_rounded,
                                    color: _primaryColor,
                                    size: isMobile ? 14 : 16,
                                  ),
                                  SizedBox(width: isMobile ? 6 : 8),
                                  Text(
                                    'Tempo',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: isMobile ? 12 : 14,
                                      color: _onSurfaceColor.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isMobile ? 4 : 6),
                              Text(
                                '$totalResponseTime s',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: isMobile ? 14 : 16,
                                  color: _onSurfaceColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: isMobile ? 30 : 36,
                            color: _outlineColor,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: _primaryColor,
                                    size: isMobile ? 14 : 16,
                                  ),
                                  SizedBox(width: isMobile ? 6 : 8),
                                  Text(
                                    'Pontos',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: isMobile ? 12 : 14,
                                      color: _onSurfaceColor.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isMobile ? 4 : 6),
                              Text(
                                '$totalScore',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: isMobile ? 16 : 18,
                                  fontWeight: FontWeight.w700,
                                  color: _primaryColor,
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

              // Conteúdo Expandido
              if (ranking.isExpanded ?? false) ...[
                Divider(height: 1, color: _outlineColor),
                Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 20),
                  child: Column(
                    children: [
                      _buildPrizeInfoSection(ranking, isMobile),
                      SizedBox(height: isMobile ? 20 : 24),
                      Text(
                        'Detalhes das Perguntas',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 16 : 18,
                          color: _onSurfaceColor,
                        ),
                      ),
                      SizedBox(height: isMobile ? 16 : 20),
                      _buildQuestionsList(isMobile),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    } else {
      // Layout desktop com table-like
      return Container(
        margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
          child: Column(
            children: [
              // Header do Card - Layout horizontal para desktop
              Padding(
                padding: EdgeInsets.all(isMobile ? 20 : 24),
                child: Row(
                  children: [
                    // Ícone de expandir NO LADO ESQUERDO
                    Container(
                      width: isMobile ? 40 : 48,
                      height: isMobile ? 40 : 48,
                      decoration: BoxDecoration(
                        color: _backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            ranking.isExpanded = !(ranking.isExpanded ?? false);
                          });
                          if (ranking.isExpanded ?? false) {
                            _model.getHistoryUserdAsync(
                                setState, ranking.matchId);
                          }
                        },
                        icon: Icon(
                          ranking.isExpanded ?? false
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          color: _primaryColor,
                          size: isMobile ? 20 : 24,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),

                    SizedBox(width: isMobile ? 20 : 24),

                    // DATA
                    Container(
                      width: isMobile ? 150 : 180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy').format(createdAt),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: isMobile ? 14 : 16,
                              color: _onSurfaceColor,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                          ),
                          SizedBox(height: isMobile ? 2 : 4),
                          Text(
                            DateFormat('HH:mm').format(createdAt),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: isMobile ? 13 : 14,
                              color: _onSurfaceColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: isMobile ? 20 : 24),

                    // RESULTADO
                    Container(
                      width: isMobile ? 150 : 180,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 12 : 16, 
                          vertical: isMobile ? 8 : 12,
                        ),
                        decoration: BoxDecoration(
                          color: isWinner
                              ? _successColor.withOpacity(0.1)
                              : _errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                          border: Border.all(
                            color: isWinner
                                ? _successColor.withOpacity(0.3)
                                : _errorColor.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              isWinner
                                  ? Icons.emoji_events_rounded
                                  : Icons.sentiment_dissatisfied_rounded,
                              color: isWinner ? _successColor : _errorColor,
                              size: isMobile ? 16 : 20,
                            ),
                            SizedBox(height: isMobile ? 2 : 4),
                            Text(
                              isWinner ? 'Vitória' : 'Derrota',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: isWinner ? _successColor : _errorColor,
                                fontWeight: FontWeight.w600,
                                fontSize: isMobile ? 12 : 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: isMobile ? 20 : 24),

                    // TEMPO
                    Container(
                      width: isMobile ? 80 : 100,
                      child: Column(
                        children: [
                          Icon(
                            Icons.timer_rounded,
                            color: _primaryColor,
                            size: isMobile ? 16 : 20,
                          ),
                          SizedBox(height: isMobile ? 4 : 6),
                          Text(
                            '$totalResponseTime s',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: isMobile ? 14 : 16,
                              color: _onSurfaceColor,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: isMobile ? 20 : 24),

                    // PONTOS
                    Container(
                      width: isMobile ? 80 : 100,
                      child: Column(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: _primaryColor,
                            size: isMobile ? 16 : 20,
                          ),
                          SizedBox(height: isMobile ? 4 : 6),
                          Text(
                            '$totalScore',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.w700,
                              color: _primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Conteúdo Expandido
              if (ranking.isExpanded ?? false) ...[
                Divider(height: 1, color: _outlineColor),
                Padding(
                  padding: EdgeInsets.all(isMobile ? 20 : 24),
                  child: Column(
                    children: [
                      _buildPrizeInfoSection(ranking, isMobile),
                      SizedBox(height: isMobile ? 20 : 24),
                      Text(
                        'Detalhes das Perguntas',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 18 : 20,
                          color: _onSurfaceColor,
                        ),
                      ),
                      SizedBox(height: isMobile ? 16 : 20),
                      _buildQuestionsList(isMobile),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }
  }

  Widget _buildPrizeInfoSection(RankingResponse ranking, bool isMobile) {
    final isWinner = ranking.isWinner ?? false;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
            boxShadow: [
              BoxShadow(
                color: _infoColor.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
              onTap: () {
                setState(() {
                  _expandPremioInfo = !_expandPremioInfo;
                });
              },
              child: Container(
                padding: EdgeInsets.all(isMobile ? 16 : 20),
                decoration: BoxDecoration(
                  color: _infoColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                  border: Border.all(
                    color: _infoColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: isMobile ? 40 : 48,
                          height: isMobile ? 40 : 48,
                          decoration: BoxDecoration(
                            color: _infoColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.attach_money_rounded,
                            color: _infoColor,
                            size: isMobile ? 20 : 24,
                          ),
                        ),
                        SizedBox(width: isMobile ? 12 : 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detalhes do Prêmio',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                color: _infoColor,
                                fontSize: isMobile ? 16 : 18,
                              ),
                              maxLines: 1,
                            ),
                            SizedBox(height: isMobile ? 2 : 4),
                            Text(
                              isWinner
                                  ? 'Você venceu esta partida!'
                                  : 'Você não venceu esta partida',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: _onSurfaceColor.withOpacity(0.6),
                                fontSize: isMobile ? 12 : 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(
                      _expandPremioInfo
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: _infoColor,
                      size: isMobile ? 24 : 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_expandPremioInfo && _model.matchInfo != null) ...[
          SizedBox(height: isMobile ? 16 : 20),
          Container(
            padding: EdgeInsets.all(isMobile ? 20 : 24),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
              border: Border.all(
                color: _outlineColor,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildPrizeDetailRow(
                  'Valor do Prêmio',
                  '${_model.matchInfo!.matchPrize?.totalGain ?? 0} AOA',
                  Icons.celebration_rounded,
                  isMobile: isMobile,
                ),
                SizedBox(height: isMobile ? 12 : 16),
                _buildPrizeDetailRow(
                  'Taxa de Jogo',
                  '${(_model.matchInfo!.room?.roomConfiguration?.premiumRate ?? 0) * 100}%',
                  Icons.percent_rounded,
                  isMobile: isMobile,
                ),
                SizedBox(height: isMobile ? 12 : 16),
                _buildPrizeDetailRow(
                  'Ganho Líquido',
                  '${!isWinner ? 0 : _model.matchInfo!.matchPrize?.netPremium ?? 0} AOA',
                  Icons.account_balance_wallet_rounded,
                  isHighlighted: isWinner,
                  isMobile: isMobile,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPrizeDetailRow(String label, String value, IconData icon,
      {bool isHighlighted = false, required bool isMobile}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: isHighlighted ? _successColor.withOpacity(0.05) : _surfaceColor,
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        border: Border.all(
          color: isHighlighted ? _successColor.withOpacity(0.2) : _outlineColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 36 : 44,
            height: isMobile ? 36 : 44,
            decoration: BoxDecoration(
              color: isHighlighted
                  ? _successColor.withOpacity(0.1)
                  : _primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: isMobile ? 18 : 22,
              color: isHighlighted ? _successColor : _primaryColor,
            ),
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                color: _onSurfaceColor.withOpacity(0.7),
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              color: isHighlighted ? _successColor : _onSurfaceColor,
              fontSize: isMobile ? 16 : 18,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsList(bool isMobile) {
    if (_model.isLoadingHistory) {
      return Container(
        padding: EdgeInsets.all(isMobile ? 40 : 48),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
              ),
              SizedBox(height: isMobile ? 16 : 20),
              Text(
                'Carregando perguntas...',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: _onSurfaceColor.withOpacity(0.6),
                  fontSize: isMobile ? 14 : 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_model.historys.isEmpty) {
      return Container(
        padding: EdgeInsets.all(isMobile ? 32 : 40),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
          border: Border.all(
            color: _outlineColor,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.help_outline_rounded,
              size: isMobile ? 48 : 56,
              color: _onSurfaceColor.withOpacity(0.4),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Text(
              'Nenhuma pergunta encontrada',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: _onSurfaceColor.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isMobile ? 8 : 12),
            Text(
              'As perguntas desta partida não estão disponíveis',
              style: TextStyle(
                fontFamily: 'Inter',
                color: _onSurfaceColor.withOpacity(0.4),
                fontSize: isMobile ? 14 : 15,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: _model.historys.map((history) {
        return _buildQuestionItem(
          history.question?.utterance ?? 'Pergunta não disponível',
          history.optionAnswer?.textOption ?? 'Resposta não disponível',
          history.optionAnswer?.isCorrect ?? false,
          history.responseTimeInSecond ?? 0,
          isMobile: isMobile,
        );
      }).toList(),
    );
  }

  Widget _buildQuestionItem(
      String question, String answer, bool isCorrect, int time,
      {required bool isMobile}) {
    return Container(
        margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
        decoration: BoxDecoration(
          color: isCorrect
              ? _successColor.withOpacity(0.05)
              : _errorColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
          border: Border.all(
            color: isCorrect
                ? _successColor.withOpacity(0.2)
                : _errorColor.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
          child: ExpansionTile(
            leading: Container(
              width: isMobile ? 32 : 40,
              height: isMobile ? 32 : 40,
              decoration: BoxDecoration(
                color: isCorrect ? _successColor : _errorColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCorrect ? Icons.check_rounded : Icons.close_rounded,
                color: Colors.white,
                size: isMobile ? 18 : 22,
              ),
            ),
            title: Text(
              question.length > 80
                  ? '${question.substring(0, 80)}...'
                  : question,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 14 : 16,
                color: _onSurfaceColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 12, 
                vertical: isMobile ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: isCorrect
                    ? _successColor.withOpacity(0.1)
                    : _errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                border: Border.all(
                  color: isCorrect ? _successColor : _errorColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_rounded,
                    size: isMobile ? 12 : 14,
                    color: isCorrect ? _successColor : _errorColor,
                  ),
                  SizedBox(width: isMobile ? 4 : 6),
                  Text(
                    '$time s',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: isCorrect ? _successColor : _errorColor,
                      fontWeight: FontWeight.w600,
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                ],
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 16 : 20, 
                  0, 
                  isMobile ? 16 : 20, 
                  isMobile ? 16 : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isMobile ? 12 : 16),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? _successColor.withOpacity(0.05)
                            : _errorColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                        border: Border.all(
                          color: isCorrect
                              ? _successColor.withOpacity(0.2)
                              : _errorColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isCorrect
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            color: isCorrect ? _successColor : _errorColor,
                            size: isMobile ? 16 : 18,
                          ),
                          SizedBox(width: isMobile ? 8 : 12),
                          Expanded(
                            child: Text(
                              'Sua resposta: $answer',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: isCorrect ? _successColor : _errorColor,
                                fontWeight: FontWeight.w500,
                                fontSize: isMobile ? 14 : 16,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isMobile ? 8 : 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tempo de resposta: $time segundos',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: _onSurfaceColor.withOpacity(0.6),
                            fontSize: isMobile ? 13 : 14,
                          ),
                          maxLines: 1,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 8 : 12, 
                            vertical: isMobile ? 4 : 6,
                          ),
                          decoration: BoxDecoration(
                            color: _primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
                          ),
                          child: Text(
                            'Pontos: ${isCorrect ? (_model.matchInfo?.room?.roomConfiguration?.timeToRespond ?? 30) - time : 0}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              color: _primaryColor,
                              fontSize: isMobile ? 12 : 14,
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
        ));
  }

  Widget _buildHeaderItem(String text, {int flex = 1, required bool isMobile}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: isMobile ? 12 : 13,
          color: _onSurfaceColor.withOpacity(0.6),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPlayerTile(UserResponse? player,
      {required UserResponse? currentUser, required bool isMobile}) {
    final isCurrentUser = player?.id == currentUser?.id;
    final playerName = player?.name ?? 'Jogador sem nome';
    final playerEmail = player?.email ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: isMobile ? 8 : 12),
      decoration: BoxDecoration(
        color: isCurrentUser ? _primaryColor.withOpacity(0.05) : _surfaceColor,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        border: Border.all(
          color: isCurrentUser ? _primaryColor.withOpacity(0.2) : _outlineColor,
          width: 1.5,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 20, 
          vertical: isMobile ? 8 : 12,
        ),
        leading: Stack(
          children: [
            Container(
              width: isMobile ? 40 : 48,
              height: isMobile ? 40 : 48,
              decoration: BoxDecoration(
                color: isCurrentUser ? _primaryColor : _outlineColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  playerName.isNotEmpty ? playerName[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white : _onSurfaceColor,
                    fontWeight: FontWeight.w600,
                    fontSize: isMobile ? 16 : 18,
                  ),
                ),
              ),
            ),
            if (isCurrentUser)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: isMobile ? 12 : 14,
                  height: isMobile ? 12 : 14,
                  decoration: BoxDecoration(
                    color: _successColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _surfaceColor,
                      width: isMobile ? 2 : 3,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Text(
              playerName,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: isCurrentUser ? FontWeight.w700 : FontWeight.w500,
                color: _onSurfaceColor,
                fontSize: isMobile ? 14 : 16,
              ),
              maxLines: 1,
            ),
            if (isCurrentUser)
              Padding(
                padding: EdgeInsets.only(left: isMobile ? 6.0 : 8.0),
                child: Text(
                  '(você)',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: _onSurfaceColor.withOpacity(0.6),
                    fontSize: isMobile ? 12 : 13,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(
          playerEmail,
          style: TextStyle(
            fontFamily: 'Inter',
            color: _onSurfaceColor.withOpacity(0.6),
            fontSize: isMobile ? 12 : 13,
          ),
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buildEmptyGamesList(bool isCompleted, bool isMobile) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(isMobile ? 24 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isMobile ? 80 : 100,
              height: isMobile ? 80 : 100,
              decoration: BoxDecoration(
                color: _outlineColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted
                    ? Icons.emoji_events_rounded
                    : Icons.hourglass_empty_rounded,
                color: _onSurfaceColor.withOpacity(0.4),
                size: isMobile ? 32 : 40,
              ),
            ),
            SizedBox(height: isMobile ? 16 : 24),
            Text(
              isCompleted
                  ? 'Nenhuma partida concluída encontrada'
                  : 'Nenhuma partida pendente encontrada',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: _onSurfaceColor.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyMatchesList(bool isMobile) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(isMobile ? 24 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isMobile ? 80 : 100,
              height: isMobile ? 80 : 100,
              decoration: BoxDecoration(
                color: _outlineColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.hourglass_empty_rounded,
                color: _onSurfaceColor.withOpacity(0.4),
                size: isMobile ? 32 : 40,
              ),
            ),
            SizedBox(height: isMobile ? 16 : 24),
            Text(
              'Nenhuma partida encontrada com os filtros atuais',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: _onSurfaceColor.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isMobile ? 16 : 24),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                  onTap: () {
                    setState(() {
                      _filterStatus = 'all';
                      _dateRange = null;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 24 : 32, 
                      vertical: isMobile ? 12 : 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: _primaryGradient,
                      borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                    ),
                    child: Text(
                      'LIMPAR FILTROS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'PENDING':
        return _warningColor;
      case 'IN_PROGRESS':
        return _primaryColor;
      case 'CANCELLED':
        return _errorColor;
      case 'WAITING_FOR_START':
        return _infoColor;
      default:
        return _onSurfaceColor.withOpacity(0.4);
    }
  }
}