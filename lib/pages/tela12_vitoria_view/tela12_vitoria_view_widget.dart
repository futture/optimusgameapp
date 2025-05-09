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
  RankingWithTopWinnersResponse? _rankingResponse;
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

    // Verificando se a resposta foi bem-sucedida
    if (response['isSuccess']) {
      final rankingResponse = response['data'] as RankingWithTopWinnersResponse;

      // Exibir os dados no formato esperado
      print('Top 3:');
      rankingResponse.top3.forEach((item) {
        print(
            'Top 3 - Nome: ${item.user.name}, Posição: ${item.position}, Pontuação: ${item.totalScore}');
      });

      print('Todos os rankings:');
      rankingResponse.allRankings.forEach((item) {
        print(
            'Ranking - Nome: ${item.user.name}, Posição: ${item.position}, Pontuação: ${item.totalScore}');
      });

      // Preencher as variáveis globais com os dados do top 3
      setState(() {
        // Top 1
        firstPlaceName = rankingResponse.top3[0].user.name;
        firstPlacePoints = rankingResponse.top3[0].totalScore.toString();
        firstPlacePosition = rankingResponse.top3[0].position;

        // Top 2
        secondPlaceName = rankingResponse.top3[1].user.name;
        secondPlacePosition = rankingResponse.top3[1].position;
        secondPlacePoints = rankingResponse.top3[1].totalScore.toString();

        // Top 3
        thirdPlaceName = rankingResponse.top3[2].user.name;
        thirdPlacePosition = rankingResponse.top3[2].position;
        thirdPlacePoints = rankingResponse.top3[2].totalScore.toString();
        print(thirdPlaceName);
        // Atualizar o estado com os dados do ranking
        rankingData = rankingResponse.allRankings
            .map((e) =>
                'ID: ${e.id}, Nome: ${e.user.name}, Posição: ${e.position}, Pontuação: ${e.totalScore}')
            .join('\n'); // Exemplo de formatação para exibição
        isLoading = false;
      });
    } else {
      setState(() {
        rankingData = 'Erro ao buscar ranking'; // Caso ocorra erro
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

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return const Color(0xFFFFD700); // Ouro
      case 2:
        return const Color(0xFFC0C0C0); // Prata
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return const Color(0xFFEC8D0D);
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isFirst)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFD700),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ],
            ),
            child: const FaIcon(
              FontAwesomeIcons.crown,
              color: Colors.white,
              size: 24,
            ),
          ),
        const SizedBox(height: 8),
        Container(
          width: 90,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
            border: Border.all(
              color: _getPositionColor(position),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Número da posição
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _getPositionColor(position),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    position.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Avatar
              Container(
                decoration: isFirst
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFFD700),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            spreadRadius: 1,
                          )
                        ],
                      )
                    : null,
                child: CircleAvatar(
                  radius: isFirst ? 32 : 28,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
              const SizedBox(height: 10),
              // Nome
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isFirst ? const Color(0xFFEC8D0D) : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              // Pontos
              Text(
                points,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFEC8D0D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRankingList() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(10, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFEC8D0D),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (index + 4).toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEC8D0D),
                        ),
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(
                            'https://picsum.photos/seed/${index + 100}/600'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Usuário ${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEC8D0D), Color(0xFFF5B041)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(10000 - index * 1000)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
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
              icon: Icon(
                Icons.arrow_back,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
          ),
          title: Text(
            'RANKINGS',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'Inter Tight',
                  color: const Color(0xFFEC8D0D),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              // TabBar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: FlutterFlowButtonTabBar(
                    useToggleButtonStyle: true,
                    labelStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Inter Tight',
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.0,
                            ),
                    unselectedLabelStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Inter Tight',
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                            ),
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFFEC8D0D),
                    backgroundColor: const Color(0xFFEC8D0D),
                    unselectedBackgroundColor: Colors.white,
                    borderColor: Colors.transparent,
                    unselectedBorderColor: Colors.transparent,
                    borderWidth: 0,
                    borderRadius: 8.0,
                    elevation: 0,
                    buttonMargin: const EdgeInsetsDirectional.fromSTEB(
                        4.0, 0.0, 4.0, 0.0),
                    padding: const EdgeInsets.all(8.0),
                    tabs: const [
                      Tab(
                        text: 'Hoje',
                        icon: Icon(Icons.today, size: 18),
                      ),
                      Tab(
                        text: 'Semana',
                        icon: Icon(Icons.date_range, size: 18),
                      ),
                      Tab(
                        text: 'Mês',
                        icon: Icon(Icons.calendar_month, size: 18),
                      ),
                    ],
                    controller: _model.tabBarController,
                    onTap: (i) {
                      _handleTabChange(); // Chama a função que lida com a mudança de aba
                    },
                  ),
                ),
              ),

              // Pódio de vencedores
              Stack(
                children: [
                  // Seu container de pódio
                  Container(
                    height: 260,
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Base do pódio
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEC8D0D).withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                          ),
                        ),

                        // Posição 2 (esquerda)
                        Positioned(
                          left: 20,
                          bottom: 50,
                          child: _buildPodiumUser(
                            position: secondPlacePosition,
                            name: secondPlaceName,
                            points: secondPlacePoints,
                            avatarUrl: 'https://picsum.photos/seed/380/600',
                            height: 150,
                          ),
                        ),

                        // Posição 1 (centro)
                        Positioned(
                          left: MediaQuery.of(context).size.width / 2 - 60,
                          bottom: 30,
                          child: _buildPodiumUser(
                            position: firstPlacePosition,
                            name: firstPlaceName,
                            points: firstPlacePoints,
                            avatarUrl:
                                'https://images.unsplash.com/photo-1507502707541-f369a3b18502',
                            height: 177,
                            isFirst: true,
                          ),
                        ),

                        // Posição 3 (direita)
                        Positioned(
                          right: 20,
                          bottom: 40,
                          child: _buildPodiumUser(
                            position: thirdPlacePosition,
                            name: thirdPlaceName,
                            points: thirdPlacePoints,
                            avatarUrl:
                                'https://images.unsplash.com/photo-1507502707541-f369a3b18502',
                            height: 140,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Loading sobreposto
                  if (isLoading)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEC8D0D).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.1), width: 1),
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFEC8D0D)),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Lista de rankings
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: TabBarView(
                    controller: _model.tabBarController,
                    children: [
                      _buildRankingList(),
                      _buildRankingList(),
                      _buildRankingList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
