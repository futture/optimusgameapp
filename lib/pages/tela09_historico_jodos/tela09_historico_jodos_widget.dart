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
  int _currentIndex = 0;
  final List<String> _statusOptions = [
    'PENDING',
    'IN_PROGRESS',
    'WAITING_FOR_START',
    'CANCELLED'
  ];

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

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
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
                      child: ModaMenuPagianInicialWidget(),
                    ),
                  );
                },
              ).then((value) => safeSetState(() {}));
            },
          ),
        ),
        title: Text(
          'GAME QUIZ',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                color: const Color(0xFFEC8D0D),
                letterSpacing: 0.0,
              ),
        ),
        centerTitle: true,
        elevation: 4.0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Partidas Concluídas'),
            Tab(text: 'Partidas Pendentes'),
          ],
          labelColor: FlutterFlowTheme.of(context).primaryText,
          unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
          indicatorColor: FlutterFlowTheme.of(context).primary,
        ),
      ),
      body: _model.isLoadingRanking
          ? const Center(child: CircularProgressIndicator())
          : _model.rankings.isEmpty && _model.matches.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.videogame_asset_outlined,
                          size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Nenhum histórico de jogos encontrado',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => _model.load(setState),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (_currentIndex == 0) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FilterChip(
                              label: const Text('Todas'),
                              selected: _filterResult == 'all',
                              onSelected: (bool selected) {
                                setState(() {
                                  _filterResult =
                                      selected ? 'all' : _filterResult;
                                });
                              },
                            ),
                            FilterChip(
                              label: const Text('Vitórias'),
                              selected: _filterResult == 'winner',
                              onSelected: (bool selected) {
                                setState(() {
                                  _filterResult =
                                      selected ? 'winner' : _filterResult;
                                });
                              },
                            ),
                            FilterChip(
                              label: const Text('Derrotas'),
                              selected: _filterResult == 'loser',
                              onSelected: (bool selected) {
                                setState(() {
                                  _filterResult =
                                      selected ? 'loser' : _filterResult;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  FilterChip(
                                    label: const Text('Todas'),
                                    selected: _filterStatus == 'all',
                                    onSelected: (bool selected) {
                                      setState(() {
                                        _filterStatus =
                                            selected ? 'all' : _filterStatus;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  ..._statusOptions.map((status) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: FilterChip(
                                        label: Text(_getStatusLabel(status)),
                                        selected: _filterStatus == status,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            _filterStatus = selected
                                                ? status
                                                : _filterStatus;
                                          });
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.calendar_today,
                                        size: 16),
                                    label: Text(
                                      _dateRange == null
                                          ? 'Filtrar por data'
                                          : '${DateFormat('dd/MM/yyyy').format(_dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_dateRange!.end)}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEC8D0D),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                    onPressed: () => _selectDateRange(context),
                                  ),
                                ),
                                if (_dateRange != null)
                                  IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _dateRange = null;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildGamesList(true),
                          _buildMatchesList(),
                        ],
                      ),
                    ),
                  ],
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

  Widget _buildGamesList(bool isCompleted) {
    final filteredRankings = _getFilteredRankings(isCompleted);

    if (filteredRankings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.emoji_events : Icons.hourglass_empty,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isCompleted
                  ? 'Nenhuma partida concluída encontrada'
                  : 'Nenhuma partida pendente encontrada',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildHeaderItem('DATA', flex: 1),
                    _buildHeaderItem('RESULTADO', flex: 2),
                    _buildHeaderItem('TEMPO', flex: 0),
                    _buildHeaderItem('PONTO', flex: 1),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredRankings.length,
              itemBuilder: (context, index) {
                final ranking = filteredRankings[index];
                return _buildGameCard(ranking);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchesList() {
    final filteredMatches = _getFilteredMatches();

    if (filteredMatches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Nenhuma partida encontrada com os filtros atuais',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _filterStatus = 'all';
                  _dateRange = null;
                });
              },
              child: const Text('Limpar filtros'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredMatches.length,
              itemBuilder: (context, index) {
                final match = filteredMatches[index];
                return _buildPendingMatchCard(match);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingMatchCard(MatchResponse match) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            match.isExpanded = !(match.isExpanded ?? false);
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(match.matchStartDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('HH:mm').format(match.matchStartDate),
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          _getStatusColor(match.statusMatch).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusLabel(match.statusMatch),
                      style: TextStyle(
                        color: _getStatusColor(match.statusMatch),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildMatchInfoRow(
                icon: Icons.people,
                label: 'Jogadores',
                value:
                    '${match.matchPlayers?.length ?? 0}/${match.room?.roomConfiguration?.numberOfPlayers ?? 0}',
              ),
              const SizedBox(height: 8),
              _buildMatchInfoRow(
                icon: Icons.emoji_events,
                label: 'Prêmio',
                value:
                    '${match.matchPrize?.totalGain?.toStringAsFixed(2) ?? '0.00'} AOA',
              ),
              if (match.isExpanded ?? false) ...[
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                if (match.matchPlayers != null &&
                    match.matchPlayers!.isNotEmpty) ...[
                  const Text(
                    'Jogadores:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...match.matchPlayers!.map((player) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _buildPlayerTile(player.userResponse,
                          currentUser: _model.currentUser!),
                    );
                  }).toList(),
                ],
                if (match.statusMatch == 'PENDING') ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await _model.leaveTheMatchAsync(setState, match.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEC8D0D),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _model.isLoadingLeave
                        ? CircularProgressIndicator()
                        : const Text(
                            'Sair da Partida',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ],
              Align(
                alignment: Alignment.center,
                child: Icon(
                  match.isExpanded ?? false
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGameCard(RankingResponse ranking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    ranking.createdAt != null
                        ? DateFormat('dd/MM HH:mm').format(ranking.createdAt!)
                        : '--/-- --:--',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ranking.isWinner!
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ranking.isWinner! ? 'Vitória' : 'Derrota',
                      style: TextStyle(
                        color: ranking.isWinner! ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${ranking.totalResponseTime ?? 0} s',
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${ranking.totalScore ?? 0}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              ranking.isExpanded ?? false
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
            onTap: () {
              setState(() {
                ranking.isExpanded = !(ranking.isExpanded ?? false);
              });
              if (ranking.isExpanded ?? false) {
                _model.getHistoryUserdAsync(setState, ranking.matchId);
              }
            },
          ),
          if (ranking.isExpanded ?? false) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildPrizeInfoSection(ranking),
                  const SizedBox(height: 16),
                  const Text(
                    'Detalhes das Perguntas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildQuestionsList(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrizeInfoSection(RankingResponse ranking) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _expandPremioInfo = !_expandPremioInfo;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Detalhes do Prêmio',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Icon(
                  _expandPremioInfo ? Icons.expand_less : Icons.expand_more,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
        if (_expandPremioInfo && _model.matchInfo != null) ...[
          const SizedBox(height: 12),
          _buildDetailRow(
            'Valor do Prêmio',
            '${!ranking.isWinner! ? 0 : _model.matchInfo!.matchPrize?.totalGain ?? 0} AOA',
          ),
          _buildDetailRow(
            'Taxa de Jogo',
            '${(!ranking.isWinner! ? 0 : _model.matchInfo!.room?.roomConfiguration?.premiumRate ?? 0) * 100}%',
          ),
          //  _buildDetailRow(
          //     'Imposto aplicado',
          //     '${(!ranking.isWinner! ? 0 : ranking.) * 100}%',
          //   ),
          _buildDetailRow(
            'Ganho Líquido',
            '${!ranking.isWinner! ? 0 : _model.matchInfo!.matchPrize?.netPremium ?? 0} AOA',
          ),
        ],
      ],
    );
  }

  Widget _buildQuestionsList() {
    if (_model.isLoadingHistory) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_model.historys.isEmpty) {
      return const Center(
        child: Text('Nenhuma pergunta encontrada'),
      );
    }

    return Column(
      children: _model.historys.map((history) {
        return _buildQuestionItem(
          history.question?.utterance ?? 'Pergunta não disponível',
          history.optionAnswer?.textOption ?? 'Resposta não disponível',
          history.optionAnswer?.isCorrect ?? false,
          history.responseTimeInSecond ?? 0,
        );
      }).toList(),
    );
  }

  Widget _buildHeaderItem(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionItem(
      String question, String answer, bool isCorrect, int time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: isCorrect
          ? Colors.green.withOpacity(0.1)
          : Colors.red.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isCorrect ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontSize: 14),
        ),
        trailing: Text(
          '$time s',
          style: TextStyle(
            color: isCorrect ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sua resposta: $answer',
                  style: TextStyle(
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tempo de resposta: $time segundos',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pontos: ${isCorrect ? (_model.matchInfo!.room!.roomConfiguration!.timeToRespond - time) : 0}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerTile(UserResponse? player,
      {required UserResponse currentUser}) {
    final isCurrentUser = player?.id == currentUser.id;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor:
                isCurrentUser ? Colors.grey[600] : Colors.grey[200],
            child: Text(
              player?.name != null && player!.name.isNotEmpty
                  ? player.name[0].toUpperCase()
                  : '?',
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.grey[800],
              ),
            ),
          ),
          if (isCurrentUser)
            const Positioned(
              right: 0,
              bottom: 0,
              child: Icon(
                Icons.circle,
                size: 14,
                color: Colors.green,
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Text(
            player?.name ?? 'Jogador sem nome',
            style: TextStyle(
                fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                color: isCurrentUser
                    ? Colors.grey[800]
                    : FlutterFlowTheme.of(context).primaryText),
          ),
          if (isCurrentUser)
            Padding(
              padding: EdgeInsets.only(left: 6.0),
              child: Text(
                '(você)',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      subtitle: Text(
        player?.email ?? '',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      tileColor: isCurrentUser ? Colors.grey[100] : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isCurrentUser ? Colors.grey[300]! : Colors.transparent,
          width: 1,
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'IN_PROGRESS':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
