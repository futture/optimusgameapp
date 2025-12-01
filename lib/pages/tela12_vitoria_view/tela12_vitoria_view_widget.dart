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
  dynamic rankingData;
  RankingPeriod _selectedPeriod = RankingPeriod.daily;
  List<RankingItem> fullRankingList = [];
  bool isLoading = false;
  String firstPlaceName = '';
  String firstPlacePoints = '';
  int firstPlacePosition = 0;
  String firstPlaceAvatarUrl = '';

  String secondPlaceName = '';
  String secondPlacePoints = '';
  int secondPlacePosition = 0;
  String secondPlaceAvatarUrl = '';

  String thirdPlaceName = '';
  String thirdPlacePoints = '';
  int thirdPlacePosition = 0;
  String thirdPlaceAvatarUrl = '';

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
    )..addListener(() => safeSetState(() {
          _handleTabChange();
        }));
    _fetchRanking(_selectedPeriod);
    print(rankingData);
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
    setState(() {
      isLoading = true;
      rankingData = 'Carregando...';
    });

    final service = RankingService();
    final response = await service.getRankingByPeriodAsync(period);
    if (response['isSuccess']) {
      final rankingResponse = response['data'] as RankingWithTopWinnersResponse;
      setState(() {
        final top3 = rankingResponse.top3;
        if (top3.isNotEmpty) {
          if (top3.length > 0) {
            firstPlaceName = top3[0].user.name;
            firstPlacePoints = top3[0].totalScore.toString();
            firstPlacePosition = top3[0].position;
          }

          if (top3.length > 1) {
            secondPlaceName = top3[1].user.name;
            secondPlacePoints = top3[1].totalScore.toString();
            secondPlacePosition = top3[1].position;
          }

          if (top3.length > 2) {
            thirdPlaceName = top3[2].user.name;
            thirdPlacePoints = top3[2].totalScore.toString();
            thirdPlacePosition = top3[2].position;
          }
        }
        fullRankingList = rankingResponse.allRankings
          ..sort((a, b) => b.totalScore.compareTo(a.totalScore));
        rankingData = fullRankingList
            .map((e) =>
                'ID: ${e.id}, Nome: ${e.user.name}, Posição: ${e.position}, Pontuação: ${e.totalScore}')
            .join('\n');

        isLoading = false;
      });
    } else {
      setState(() {
        rankingData = 'Erro ao buscar ranking';
        isLoading = false;
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
  }) {
    const double cardWidth = 110.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isFirst)
          Container(
            padding: const EdgeInsets.all(12),
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
            child: const FaIcon(
              FontAwesomeIcons.crown,
              color: Colors.white,
              size: 26,
            ),
          ),
        const SizedBox(height: 12),
        Container(
          width: cardWidth,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 6),
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
                top: 12,
                left: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
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
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              // Conteúdo principal
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Avatar
                    Container(
                      width: isFirst ? 60 : 50,
                      height: isFirst ? 60 : 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
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
                        borderRadius: BorderRadius.circular(30),
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
                                size: isFirst ? 24 : 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Nome
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: isFirst ? 13 : 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    // Pontuação
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        points,
                        style: TextStyle(
                          fontSize: isFirst ? 14 : 12,
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

  Widget _buildRankingList() {
    if (isLoading) {
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
    if (fullRankingList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
      padding: const EdgeInsets.all(16),
      itemCount: fullRankingList.length,
      itemBuilder: (context, index) {
        final ranking = fullRankingList[index];
        final isTop3 = ranking.position <= 3;
        
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
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Posição
                      Container(
                        width: 44,
                        height: 44,
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
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
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
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Jogador ${isTop3 ? 'Premium' : 'Ativo'}',
                              style: TextStyle(
                                color: _onSurfaceColor.withOpacity(0.6),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Pontuação
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                          ranking.totalScore.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
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
                              'Ranking de Jogadores',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          // Ícone de troféu
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.emoji_events_rounded,
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
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 1000 : double.infinity,
                ),
                child: Column(
                  children: [
                    // Tabs Modernas
                    Padding(
                      padding: const EdgeInsets.all(20),
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
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.0,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
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
                          buttonMargin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(8),
                          tabs: const [
                            Tab(
                              text: 'Hoje',
                              icon: Icon(Icons.today_rounded, size: 18),
                            ),
                            Tab(
                              text: 'Semana',
                              icon: Icon(Icons.date_range_rounded, size: 18),
                            ),
                            Tab(
                              text: 'Mês',
                              icon: Icon(Icons.calendar_month_rounded, size: 18),
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Stack(
                          children: [
                            // Container do pódio
                            Container(
                              height: 280,
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
                                  if (firstPlaceName.isEmpty &&
                                      secondPlaceName.isEmpty &&
                                      thirdPlaceName.isEmpty)
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.emoji_events_outlined,
                                            size: 48,
                                            color: _primaryColor.withOpacity(0.3),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Nenhum classificado',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: _onSurfaceColor.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Posições do pódio
                                  if (secondPlaceName.isNotEmpty)
                                    Positioned(
                                      left: 30,
                                      bottom: 40,
                                      child: _buildPodiumUser(
                                        position: secondPlacePosition,
                                        name: secondPlaceName,
                                        points: (double.tryParse(secondPlacePoints) ?? 0).toStringAsFixed(2),
                                        avatarUrl: 'https://images.unsplash.com/photo-1507502707541-f369a3b18502',
                                        height: 160,
                                      ),
                                    ),

                                  if (firstPlaceName.isNotEmpty)
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 30),
                                        child: _buildPodiumUser(
                                          position: firstPlacePosition,
                                          name: firstPlaceName,
                                          points: (double.tryParse(firstPlacePoints) ?? 0).toStringAsFixed(2),
                                          avatarUrl: 'https://images.unsplash.com/photo-1507502707541-f369a3b18502',
                                          height: 190,
                                          isFirst: true,
                                        ),
                                      ),
                                    ),

                                  if (thirdPlaceName.isNotEmpty)
                                    Positioned(
                                      right: 30,
                                      bottom: 30,
                                      child: _buildPodiumUser(
                                        position: thirdPlacePosition,
                                        name: thirdPlaceName,
                                        points: (double.tryParse(thirdPlacePoints) ?? 0).toStringAsFixed(2),
                                        avatarUrl: 'https://images.unsplash.com/photo-1507502707541-f369a3b18502',
                                        height: 150,
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Loading overlay
                            if (isLoading)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: _surfaceColor,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
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

                    // Lista de Ranking
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.all(20),
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
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                                    size: 22,
                                    color: _primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'CLASSIFICAÇÃO COMPLETA',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      color: _primaryColor,
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
                                  _buildRankingList(),
                                  _buildRankingList(),
                                  _buildRankingList(),
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
        ),
      ),
    );
  }
}