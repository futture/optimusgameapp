import 'package:projeto_game_quiz/core/api/services/ranking_service.dart';
import 'package:projeto_game_quiz/core/enum/ranking.dart';
import 'package:projeto_game_quiz/core/models/responses/ranking_response.dart';

import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tela12_vitoria_view_model.dart';
export 'tela12_vitoria_view_model.dart';

class Tela12VitoriaViewWidget extends StatefulWidget {
  final dynamic gameResultInfo;
  const Tela12VitoriaViewWidget({super.key, this.gameResultInfo});

  static String routeName = 'Tela12VitoriaView';
  static String routePath = '/tela12VitoriaView';

  @override
  State<Tela12VitoriaViewWidget> createState() =>
      _Tela12VitoriaViewWidgetState();
}

class _Tela12VitoriaViewWidgetState extends State<Tela12VitoriaViewWidget>
    with TickerProviderStateMixin {
  late Tela12VitoriaViewModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // VARIÁVEIS SEPARADAS PARA CADA PERÍODO
  Map<RankingPeriod, List<RankingItem>> _rankingLists = {
    RankingPeriod.daily: [],
    RankingPeriod.weekly: [],
    RankingPeriod.monthly: [],
  };

  Map<RankingPeriod, bool> _isLoading = {
    RankingPeriod.daily: false,
    RankingPeriod.weekly: false,
    RankingPeriod.monthly: false,
  };

  Map<RankingPeriod, String> _firstPlaceNames = {
    RankingPeriod.daily: '',
    RankingPeriod.weekly: '',
    RankingPeriod.monthly: '',
  };

  Map<RankingPeriod, String> _firstPlacePoints = {
    RankingPeriod.daily: '',
    RankingPeriod.weekly: '',
    RankingPeriod.monthly: '',
  };

  Map<RankingPeriod, int> _firstPlacePositions = {
    RankingPeriod.daily: 0,
    RankingPeriod.weekly: 0,
    RankingPeriod.monthly: 0,
  };

  Map<RankingPeriod, String> _secondPlaceNames = {
    RankingPeriod.daily: '',
    RankingPeriod.weekly: '',
    RankingPeriod.monthly: '',
  };

  Map<RankingPeriod, String> _secondPlacePoints = {
    RankingPeriod.daily: '',
    RankingPeriod.weekly: '',
    RankingPeriod.monthly: '',
  };

  Map<RankingPeriod, int> _secondPlacePositions = {
    RankingPeriod.daily: 0,
    RankingPeriod.weekly: 0,
    RankingPeriod.monthly: 0,
  };

  Map<RankingPeriod, String> _thirdPlaceNames = {
    RankingPeriod.daily: '',
    RankingPeriod.weekly: '',
    RankingPeriod.monthly: '',
  };

  Map<RankingPeriod, String> _thirdPlacePoints = {
    RankingPeriod.daily: '',
    RankingPeriod.weekly: '',
    RankingPeriod.monthly: '',
  };

  Map<RankingPeriod, int> _thirdPlacePositions = {
    RankingPeriod.daily: 0,
    RankingPeriod.weekly: 0,
    RankingPeriod.monthly: 0,
  };

  // Cores do tema premium com laranja como primária
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _primaryDark = Color(0xFFD17A0A);
  final Color _primaryLight = Color(0xFFFFA726);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);

  // Gradientes premium
  final LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFEC8D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _silverGradient = LinearGradient(
    colors: [Color(0xFFC0C0C0), Color(0xFFE8E8E8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _bronzeGradient = LinearGradient(
    colors: [Color(0xFFCD7F32), Color(0xFFE8B886)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela12VitoriaViewModel());
    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
    _fetchRanking(RankingPeriod.daily);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  RankingPeriod getRankingPeriodFromString(String periodStr) {
    switch (periodStr.toLowerCase()) {
      case 'daily':
        return RankingPeriod.daily;
      case 'weekly':
        return RankingPeriod.weekly;
      case 'monthly':
        return RankingPeriod.monthly;
      default:
        throw Exception('Período desconhecido');
    }
  }

  Future<void> _fetchRanking(RankingPeriod period) async {
    if (_rankingLists[period]!.isNotEmpty || _isLoading[period] == true) {
      return;
    }

    setState(() {
      _isLoading[period] = true;
    });

    try {
      final service = RankingService();
      final response = await service.getRankingByPeriodAsync(period);

      if (response['isSuccess']) {
        final rankingResponse =
            response['data'] as RankingWithTopWinnersResponse;

        setState(() {
          final top3 = rankingResponse.top3 ?? [];

          // Limpa dados anteriores deste período
          _firstPlaceNames[period] = '';
          _firstPlacePoints[period] = '';
          _firstPlacePositions[period] = 0;
          _secondPlaceNames[period] = '';
          _secondPlacePoints[period] = '';
          _secondPlacePositions[period] = 0;
          _thirdPlaceNames[period] = '';
          _thirdPlacePoints[period] = '';
          _thirdPlacePositions[period] = 0;

          // CORREÇÃO: Acessar elementos apenas se existirem
          for (int i = 0; i < top3.length && i < 3; i++) {
            final item = top3[i];

            switch (i) {
              case 0:
                _firstPlaceNames[period] = item.user.name;
                _firstPlacePoints[period] = item.totalScore.toString();
                _firstPlacePositions[period] = item.position;
                break;
              case 1:
                _secondPlaceNames[period] = item.user.name;
                _secondPlacePoints[period] = item.totalScore.toString();
                _secondPlacePositions[period] = item.position;
                break;
              case 2:
                _thirdPlaceNames[period] = item.user.name;
                _thirdPlacePoints[period] = item.totalScore.toString();
                _thirdPlacePositions[period] = item.position;
                break;
            }
          }

          _rankingLists[period] = rankingResponse.allRankings ?? []
            ..sort((a, b) => b.totalScore.compareTo(a.totalScore));

          _isLoading[period] = false;
        });
      } else {
        setState(() {
          _isLoading[period] = false;
        });
      }
    } catch (e) {
      print('Erro ao buscar ranking para período $period: $e');
      setState(() {
        _isLoading[period] = false;
      });
    }
  }

  void _handleTabChange() {
    switch (_model.tabBarController?.index) {
      case 0:
        _fetchRanking(RankingPeriod.daily);
        break;
      case 1:
        _fetchRanking(RankingPeriod.weekly);
        break;
      case 2:
        _fetchRanking(RankingPeriod.monthly);
        break;
      default:
        _fetchRanking(RankingPeriod.daily);
    }
  }

  // Métodos para obter dados do período atual
  RankingPeriod get _currentPeriod {
    switch (_model.tabBarController?.index) {
      case 0:
        return RankingPeriod.daily;
      case 1:
        return RankingPeriod.weekly;
      case 2:
        return RankingPeriod.monthly;
      default:
        return RankingPeriod.daily;
    }
  }

  bool get _isCurrentLoading => _isLoading[_currentPeriod] ?? false;

  String get _currentFirstPlaceName => _firstPlaceNames[_currentPeriod] ?? '';
  String get _currentFirstPlacePoints =>
      _firstPlacePoints[_currentPeriod] ?? '';
  int get _currentFirstPlacePosition =>
      _firstPlacePositions[_currentPeriod] ?? 0;

  String get _currentSecondPlaceName => _secondPlaceNames[_currentPeriod] ?? '';
  String get _currentSecondPlacePoints =>
      _secondPlacePoints[_currentPeriod] ?? '';
  int get _currentSecondPlacePosition =>
      _secondPlacePositions[_currentPeriod] ?? 0;

  String get _currentThirdPlaceName => _thirdPlaceNames[_currentPeriod] ?? '';
  String get _currentThirdPlacePoints =>
      _thirdPlacePoints[_currentPeriod] ?? '';
  int get _currentThirdPlacePosition =>
      _thirdPlacePositions[_currentPeriod] ?? 0;

  List<RankingItem> get _currentRankingList =>
      _rankingLists[_currentPeriod] ?? [];

  LinearGradient _getPositionGradient(int position) {
    switch (position) {
      case 1:
        return _goldGradient;
      case 2:
        return _silverGradient;
      case 3:
        return _bronzeGradient;
      default:
        return LinearGradient(
          colors: [_primaryColor.withOpacity(0.8), _primaryColor],
        );
    }
  }

  Color _getPositionTextColor(int position) {
    switch (position) {
      case 1:
        return Color(0xFF996515);
      case 2:
        return Color(0xFF6B6B6B);
      case 3:
        return Color(0xFF8B4513);
      default:
        return Colors.white;
    }
  }

  Widget _buildPodiumUser({
    required int position,
    required String name,
    required String points,
    required String avatarUrl,
    required double height,
    bool isFirst = false,
    required BuildContext context,
    required bool isSmallScreen,
    required bool isVerySmallScreen,
  }) {
    double cardWidth = isVerySmallScreen
        ? 75
        : isSmallScreen
            ? 85
            : 110;
    double avatarSize = isVerySmallScreen
        ? 36
        : isSmallScreen
            ? 40
            : (isFirst ? 60 : 50);
    double fontSize = isVerySmallScreen
        ? 9
        : isSmallScreen
            ? 10
            : (isFirst ? 13 : 12);
    double pointsFontSize = isVerySmallScreen
        ? 9
        : isSmallScreen
            ? 10
            : (isFirst ? 14 : 12);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isFirst)
          Container(
            padding: EdgeInsets.all(isVerySmallScreen
                ? 6
                : isSmallScreen
                    ? 8
                    : 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _goldGradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ],
            ),
            child: FaIcon(
              FontAwesomeIcons.crown,
              color: Colors.white,
              size: isVerySmallScreen
                  ? 16
                  : isSmallScreen
                      ? 20
                      : 26,
            ),
          ),
        SizedBox(
            height: isVerySmallScreen
                ? 6
                : isSmallScreen
                    ? 8
                    : 12),
        Container(
          width: cardWidth,
          height: height,
          margin: EdgeInsets.symmetric(
              horizontal: isVerySmallScreen
                  ? 2
                  : isSmallScreen
                      ? 3
                      : 6),
          decoration: BoxDecoration(
            gradient: _getPositionGradient(position),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Stack(
            children: [
              // Badge de posição
              Positioned(
                top: isVerySmallScreen
                    ? 6
                    : isSmallScreen
                        ? 8
                        : 12,
                left: 0,
                right: 0,
                child: Container(
                  width: isVerySmallScreen
                      ? 24
                      : isSmallScreen
                          ? 26
                          : 32,
                  height: isVerySmallScreen
                      ? 24
                      : isSmallScreen
                          ? 26
                          : 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      position.toString(),
                      style: TextStyle(
                        color: _getPositionTextColor(position),
                        fontWeight: FontWeight.w800,
                        fontSize: isVerySmallScreen
                            ? 10
                            : isSmallScreen
                                ? 11
                                : 14,
                      ),
                    ),
                  ),
                ),
              ),
              // Conteúdo principal
              Padding(
                padding: EdgeInsets.all(isVerySmallScreen
                    ? 8
                    : isSmallScreen
                        ? 10
                        : 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Avatar
                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: isVerySmallScreen
                              ? 1.5
                              : isSmallScreen
                                  ? 2
                                  : 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(avatarSize / 2),
                        child: Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: isVerySmallScreen
                                    ? 14
                                    : isSmallScreen
                                        ? 16
                                        : (isFirst ? 24 : 20),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                        height: isVerySmallScreen
                            ? 4
                            : isSmallScreen
                                ? 6
                                : 12),
                    // Nome
                    Flexible(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                        height: isVerySmallScreen
                            ? 2
                            : isSmallScreen
                                ? 4
                                : 6),
                    // Pontuação
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isVerySmallScreen
                            ? 4
                            : isSmallScreen
                                ? 5
                                : 8,
                        vertical: isVerySmallScreen
                            ? 2
                            : isSmallScreen
                                ? 3
                                : 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        points,
                        style: TextStyle(
                          fontSize: pointsFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRankingList(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    if (_isCurrentLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Carregando ranking...',
              style: TextStyle(
                color: _onSurfaceColor.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_currentRankingList.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.leaderboard_outlined,
                size: 48,
                color: _primaryColor.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Nenhum jogador além do Top 3',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _onSurfaceColor.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Participe de mais partidas para subir no ranking!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _onSurfaceColor.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _currentRankingList.length,
      itemBuilder: (context, index) {
        // VERIFICAÇÃO ADICIONAL DE SEGURANÇA
        if (index >= _currentRankingList.length) {
          return SizedBox.shrink();
        }

        final ranking = _currentRankingList[index];
        if (ranking == null) {
          return SizedBox.shrink();
        }

        final isTop3 = ranking.position <= 3;

        // Formata a pontuação com 2 casas decimais
        String formattedScore;
        try {
          // Tenta converter para double e formatar
          final score = ranking.totalScore is double
              ? ranking.totalScore as double
              : double.tryParse(ranking.totalScore.toString()) ?? 0.0;
          formattedScore = score.toStringAsFixed(2);

          // Remove zeros desnecessários após a vírgula (opcional)
          if (formattedScore.endsWith('.00')) {
            formattedScore =
                formattedScore.substring(0, formattedScore.length - 3);
          } else if (formattedScore.endsWith('0')) {
            formattedScore =
                formattedScore.substring(0, formattedScore.length - 1);
          }
        } catch (e) {
          // Se houver erro, mostra o valor original
          formattedScore = ranking.totalScore.toString();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                // Ação ao tocar no item
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: _outlineColor,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  child: Row(
                    children: [
                      // Posição
                      Container(
                        width: isSmallScreen ? 36 : 44,
                        height: isSmallScreen ? 36 : 44,
                        decoration: BoxDecoration(
                          gradient: isTop3
                              ? _getPositionGradient(ranking.position)
                              : LinearGradient(
                                  colors: [
                                    _primaryColor.withOpacity(0.1),
                                    _primaryColor.withOpacity(0.05)
                                  ],
                                ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isTop3
                                ? Colors.transparent
                                : _primaryColor.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            ranking.position.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: isTop3
                                  ? _getPositionTextColor(ranking.position)
                                  : _primaryColor,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 12 : 16),
                      // Informações do jogador
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ranking.user.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _onSurfaceColor,
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Jogador ${isTop3 ? 'Premium' : 'Ativo'}',
                              style: TextStyle(
                                color: _onSurfaceColor.withOpacity(0.6),
                                fontSize: isSmallScreen ? 11 : 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Pontuação formatada
                      Container(
                        constraints: BoxConstraints(
                          minWidth: isSmallScreen ? 60 : 70,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 12 : 16,
                          vertical: isSmallScreen ? 6 : 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: _primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          formattedScore,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                          textAlign: TextAlign.center,
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _backgroundColor,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isSmallScreen = screenWidth < 400;
            final isVerySmallScreen = screenWidth < 350;

            return Column(
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
                        horizontal: isVerySmallScreen
                            ? 12
                            : isSmallScreen
                                ? 16
                                : 20,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Botão Voltar Premium
                              Container(
                                width: isVerySmallScreen
                                    ? 36
                                    : isSmallScreen
                                        ? 40
                                        : 44,
                                height: isVerySmallScreen
                                    ? 36
                                    : isSmallScreen
                                        ? 40
                                        : 44,
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
                                    size: isVerySmallScreen
                                        ? 16
                                        : isSmallScreen
                                            ? 18
                                            : 20,
                                  ),
                                  splashRadius: 20,
                                ),
                              ),
                              SizedBox(
                                  width: isVerySmallScreen
                                      ? 8
                                      : isSmallScreen
                                          ? 12
                                          : 16),
                              Expanded(
                                child: Text(
                                  'Ranking de Jogadores',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isVerySmallScreen
                                        ? 18
                                        : isSmallScreen
                                            ? 20
                                            : 24,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              // Ícone de troféu
                              Container(
                                width: isVerySmallScreen
                                    ? 36
                                    : isSmallScreen
                                        ? 40
                                        : 44,
                                height: isVerySmallScreen
                                    ? 36
                                    : isSmallScreen
                                        ? 40
                                        : 44,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.emoji_events_rounded,
                                  color: Colors.white,
                                  size: isVerySmallScreen
                                      ? 18
                                      : isSmallScreen
                                          ? 20
                                          : 22,
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
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 1000 : double.infinity,
                    ),
                    child: Column(
                      children: [
                        // Tabs Modernas
                        Padding(
                          padding: EdgeInsets.all(isVerySmallScreen
                              ? 12
                              : isSmallScreen
                                  ? 16
                                  : 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _surfaceColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: FlutterFlowButtonTabBar(
                              useToggleButtonStyle: true,
                              labelStyle: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: isVerySmallScreen
                                    ? 12.0
                                    : isSmallScreen
                                        ? 13.0
                                        : 14.0,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.0,
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: isVerySmallScreen
                                    ? 12.0
                                    : isSmallScreen
                                        ? 13.0
                                        : 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: _primaryColor,
                              backgroundColor: _primaryColor,
                              unselectedBackgroundColor: _surfaceColor,
                              borderColor: Colors.transparent,
                              unselectedBorderColor: _outlineColor,
                              borderWidth: 1,
                              borderRadius: 12.0,
                              elevation: 0,
                              buttonMargin: EdgeInsets.all(isVerySmallScreen
                                  ? 2
                                  : isSmallScreen
                                      ? 3
                                      : 4),
                              padding: EdgeInsets.all(isVerySmallScreen
                                  ? 4
                                  : isSmallScreen
                                      ? 6
                                      : 8),
                              tabs: [
                                Tab(
                                  text: 'Hoje',
                                  icon: Icon(
                                    Icons.today_rounded,
                                    size: isVerySmallScreen
                                        ? 14
                                        : isSmallScreen
                                            ? 16
                                            : 18,
                                  ),
                                ),
                                Tab(
                                  text: 'Semana',
                                  icon: Icon(
                                    Icons.date_range_rounded,
                                    size: isVerySmallScreen
                                        ? 14
                                        : isSmallScreen
                                            ? 16
                                            : 18,
                                  ),
                                ),
                                Tab(
                                  text: 'Mês',
                                  icon: Icon(
                                    Icons.calendar_month_rounded,
                                    size: isVerySmallScreen
                                        ? 14
                                        : isSmallScreen
                                            ? 16
                                            : 18,
                                  ),
                                ),
                              ],
                              controller: _model.tabBarController,
                              onTap: (i) {
                                _handleTabChange();
                              },
                            ),
                          ),
                        ),

                        // Pódio
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isVerySmallScreen
                                    ? 12
                                    : isSmallScreen
                                        ? 16
                                        : 20),
                            child: Container(
                              height: isVerySmallScreen
                                  ? 220
                                  : isSmallScreen
                                      ? 240
                                      : 280,
                              decoration: BoxDecoration(
                                color: _surfaceColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Fundo gradiente
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            _primaryColor.withOpacity(0.03),
                                            _primaryColor.withOpacity(0.01),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),

                                  // Conteúdo do pódio
                                  if (_currentFirstPlaceName.isEmpty &&
                                      _currentSecondPlaceName.isEmpty &&
                                      _currentThirdPlaceName.isEmpty)
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.emoji_events_outlined,
                                            size: isVerySmallScreen
                                                ? 36
                                                : isSmallScreen
                                                    ? 40
                                                    : 48,
                                            color:
                                                _primaryColor.withOpacity(0.3),
                                          ),
                                          SizedBox(
                                              height: isVerySmallScreen
                                                  ? 8
                                                  : isSmallScreen
                                                      ? 12
                                                      : 16),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: isVerySmallScreen
                                                    ? 12
                                                    : isSmallScreen
                                                        ? 16
                                                        : 24),
                                            child: Text(
                                              'Nenhum classificado',
                                              style: TextStyle(
                                                fontSize: isVerySmallScreen
                                                    ? 13
                                                    : isSmallScreen
                                                        ? 14
                                                        : 16,
                                                fontWeight: FontWeight.w600,
                                                color: _onSurfaceColor
                                                    .withOpacity(0.5),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  if (_currentFirstPlaceName.isNotEmpty ||
                                      _currentSecondPlaceName.isNotEmpty ||
                                      _currentThirdPlaceName.isNotEmpty)
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: isVerySmallScreen
                                          ? AlwaysScrollableScrollPhysics()
                                          : NeverScrollableScrollPhysics(),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isVerySmallScreen
                                              ? 10
                                              : isSmallScreen
                                                  ? 15
                                                  : 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            // Segundo lugar
                                            if (_currentSecondPlaceName
                                                    .isNotEmpty &&
                                                _currentSecondPlacePosition > 0)
                                              _buildPodiumUser(
                                                position:
                                                    _currentSecondPlacePosition,
                                                name: _currentSecondPlaceName,
                                                points: (double.tryParse(
                                                            _currentSecondPlacePoints) ??
                                                        0)
                                                    .toStringAsFixed(2),
                                                avatarUrl:
                                                    'https://images.unsplash.com/photo-1507502707541-f369a3b18502',
                                                height: isVerySmallScreen
                                                    ? 120
                                                    : isSmallScreen
                                                        ? 140
                                                        : 160,
                                                isFirst: false,
                                                context: context,
                                                isSmallScreen: isSmallScreen,
                                                isVerySmallScreen:
                                                    isVerySmallScreen,
                                              ),

                                            // Primeiro lugar
                                            if (_currentFirstPlaceName
                                                    .isNotEmpty &&
                                                _currentFirstPlacePosition > 0)
                                              _buildPodiumUser(
                                                position:
                                                    _currentFirstPlacePosition,
                                                name: _currentFirstPlaceName,
                                                points: (double.tryParse(
                                                            _currentFirstPlacePoints) ??
                                                        0)
                                                    .toStringAsFixed(2),
                                                avatarUrl:
                                                    'https://images.unsplash.com/photo-1507502707541-f369a3b18502',
                                                height: isVerySmallScreen
                                                    ? 150
                                                    : isSmallScreen
                                                        ? 170
                                                        : 190,
                                                isFirst: true,
                                                context: context,
                                                isSmallScreen: isSmallScreen,
                                                isVerySmallScreen:
                                                    isVerySmallScreen,
                                              ),

                                            // Terceiro lugar
                                            if (_currentThirdPlaceName
                                                    .isNotEmpty &&
                                                _currentThirdPlacePosition > 0)
                                              _buildPodiumUser(
                                                position:
                                                    _currentThirdPlacePosition,
                                                name: _currentThirdPlaceName,
                                                points: (double.tryParse(
                                                            _currentThirdPlacePoints) ??
                                                        0)
                                                    .toStringAsFixed(2),
                                                avatarUrl:
                                                    'https://images.unsplash.com/photo-1507502707541-f369a3b18502',
                                                height: isVerySmallScreen
                                                    ? 110
                                                    : isSmallScreen
                                                        ? 130
                                                        : 150,
                                                isFirst: false,
                                                context: context,
                                                isSmallScreen: isSmallScreen,
                                                isVerySmallScreen:
                                                    isVerySmallScreen,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  // Loading overlay
                                  if (_isCurrentLoading)
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Container(
                                            padding:
                                                EdgeInsets.all(isVerySmallScreen
                                                    ? 12
                                                    : isSmallScreen
                                                        ? 16
                                                        : 20),
                                            decoration: BoxDecoration(
                                              color: _surfaceColor,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: SizedBox(
                                              width: isVerySmallScreen
                                                  ? 24
                                                  : isSmallScreen
                                                      ? 28
                                                      : 32,
                                              height: isVerySmallScreen
                                                  ? 24
                                                  : isSmallScreen
                                                      ? 28
                                                      : 32,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(_primaryColor),
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

                        // Lista de Ranking
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.all(isVerySmallScreen
                                ? 12
                                : isSmallScreen
                                    ? 16
                                    : 20),
                            decoration: BoxDecoration(
                              color: _surfaceColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Header da lista
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isVerySmallScreen
                                        ? 12
                                        : isSmallScreen
                                            ? 16
                                            : 24,
                                    vertical: isVerySmallScreen
                                        ? 10
                                        : isSmallScreen
                                            ? 12
                                            : 16,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        _primaryColor.withOpacity(0.1),
                                        _primaryColor.withOpacity(0.05),
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.leaderboard_rounded,
                                        size: isVerySmallScreen
                                            ? 18
                                            : isSmallScreen
                                                ? 20
                                                : 22,
                                        color: _primaryColor,
                                      ),
                                      SizedBox(
                                          width: isVerySmallScreen
                                              ? 6
                                              : isSmallScreen
                                                  ? 8
                                                  : 12),
                                      Flexible(
                                        child: Text(
                                          'CLASSIFICAÇÃO COMPLETA',
                                          style: TextStyle(
                                            fontSize: isVerySmallScreen
                                                ? 12
                                                : isSmallScreen
                                                    ? 13
                                                    : 14,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                            color: _primaryColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Conteúdo das tabs
                                Expanded(
                                  child: TabBarView(
                                    controller: _model.tabBarController,
                                    children: [
                                      _buildRankingList(context),
                                      _buildRankingList(context),
                                      _buildRankingList(context),
                                    ],
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
              ],
            );
          },
        ),
      ),
    );
  }
}
