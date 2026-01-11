import 'package:flutter/services.dart';
import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/account_service.dart';
import 'package:projeto_game_quiz/core/api/services/ranking_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/enum/ranking.dart';
import 'package:projeto_game_quiz/core/models/responses/account_response.dart';
import 'package:projeto_game_quiz/core/models/responses/ranking_period_response.dart';
import 'package:projeto_game_quiz/core/models/responses/transaction_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'tela08_carteira_model.dart';
export 'tela08_carteira_model.dart';

class Tela08CarteiraWidget extends StatefulWidget {
  const Tela08CarteiraWidget({super.key});

  static String routeName = 'Tela08Carteira';
  static String routePath = '/tela08Carteira';

  @override
  State<Tela08CarteiraWidget> createState() => _Tela08CarteiraWidgetState();
}

class _Tela08CarteiraWidgetState extends State<Tela08CarteiraWidget>
    with TickerProviderStateMixin {
  late Tela08CarteiraModel _model;
  AccountResponse? userAccountInfo;
  UserResponse? user;
  List<Map<String, dynamic>> depositHistory = [];
  List<TransactionResponse> withdrawalHistory = [];
  List<TransactionResponse> allTransactions = [];
  final AccountService accountService = AccountService();
  bool isLoading = true;
  bool isLoadingWithdrawals = true;
  bool isLoadingTransactions = true;
  String _selectedFilter = 'TODOS';
  // Adicione estas variáveis
  final RankingService rankingService = RankingService();
  RankingDetailResponse? rankingPeriodData;
  bool isLoadingRankings = false;
  List<RankingDetailResponse> earningsLossesHistory = [];

  // Mapear os períodos do frontend para o backend
  Map<String, String> _periodMapping = {
    'HOJE': 'daily',
    'SEMANAL': 'weekly',
    'MENSAL': 'monthly',
    'DATA': 'date',
  };
  List<String> _filterOptions = [
    'TODOS',
    'PENDENTE',
    'PROCESSANDO',
    'CONCLUIDO',
    'CANCELADO'
  ];

  // Novas variáveis para Ganhos/Perdas
  String _selectedPeriodFilter = 'HOJE';
  List<String> _periodOptions = ['HOJE', 'SEMANAL', 'MENSAL', 'DATA'];
  Map<String, double> earningsLossesData = {
    'ganhos': 0.0,
    'perdas': 0.0,
    'total': 0.0
  };

  // Variáveis para filtro por data
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Cores do tema premium
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);
  final Color _successColor = Color(0xFF10B981);
  final Color _errorColor = Color(0xFFEF4444);
  final Color _warningColor = Color(0xFFF59E0B);
  final Color _infoColor = Color(0xFF3B82F6);

  final LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Constantes responsivas
  static const double _webMaxWidth = 1200.0;
  static const double _webCardMaxWidth = 800.0;
  static const double _mobileBreakpoint = 768.0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela08CarteiraModel());
    _loadEarningsLossesData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted &&
          (_model.textController1?.text.isEmpty == true ||
              _model.textController2?.text.isEmpty == true)) {
        //await _showEmptyFieldWarning();
      }
    });

    // Carregar dados do usuário
    _loadUserData();

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => setState(() {}));

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadEarningsLossesData() async {
    if (user?.id == null) return;

    setState(() => isLoadingRankings = true);

    try {
      String backendPeriod = _periodMapping[_selectedPeriodFilter] ?? 'daily';

      final result = await rankingService.getEarningsLossesByPeriodAsync(
        userId: user!.id,
        periodType: backendPeriod,
        specificDate: _selectedDate,
      );

      if (result['isSuccess'] && mounted) {
        final data = result['data'] as Map<String, dynamic>;

        setState(() {
          earningsLossesData = {
            'ganhos': data['total_cash_wins'] ?? 0.0,
            'perdas': data['total_cash_losses'] ?? 0.0,
            'total': data['total_cash_balance'] ?? 0.0,
          };

          earningsLossesHistory = (data['rankings'] as List<dynamic>?)
                  ?.map((item) => RankingDetailResponse.fromJson(item))
                  .toList() ??
              [];

          isLoadingRankings = false;
        });
      } else {
        if (mounted) setState(() => isLoadingRankings = false);
      }
    } catch (e) {
      if (mounted) setState(() => isLoadingRankings = false);
      print('Erro ao carregar ganhos/perdas: $e');
    }
  }

  void _calculateEarningsLosses() {
    _loadEarningsLossesData();
  }

  Future<void> _showEmptyFieldWarning() async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment: AlignmentDirectional.center,
          child: GestureDetector(
            onTap: () => FocusScope.of(dialogContext).unfocus(),
            child: Warning00CampoVazioWidget(titulo: "", detalhe: ""),
          ),
        );
      },
    );
  }

  Future<void> _loadUserData() async {
    await getUserInfoAndAccountInfoAsync();
    if (mounted) {
      await loadDepositHistory();
      await loadWithdrawalHistory();
      await loadAllTransactions();
    }
  }

  Future<void> getUserInfoAndAccountInfoAsync() async {
    await getUserInfo();
    await getUserAccountInfo();
  }

  Future<void> getUserInfo() async {
    final _user = await UserUtil.getUserInfo();
    if (mounted) {
      setState(() => user = _user);
    }
  }

  Future<void> getUserAccountInfo() async {
    if (user?.id == null) return;

    final result = await accountService.getAccountByUserIdAsync(user!.id);
    if (result["isSuccess"] && mounted) {
      setState(() => userAccountInfo = result["data"]);
    }
  }

  Future<void> loadDepositHistory() async {
    if (user?.id == null) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    try {
      final accountResult =
          await accountService.getAccountByUserIdAsync(user!.id);
      if (accountResult['isSuccess'] && accountResult['data']?.id != null) {
        final transactionsResult = await accountService
            .listDepositTransactionsAsync(accountResult['data']!.id!);

        if (transactionsResult['isSuccess'] && mounted) {
          final List<TransactionResponse> transactions =
              List<TransactionResponse>.from(transactionsResult['data'] ?? []);

          setState(() {
            depositHistory = transactions.map((tx) {
              return {
                'operacao': tx.type == 'credit' ? 'DEPÓSITO' : 'LEVANTAMENTO',
                'montante':
                    '${double.tryParse(tx.amount.toString())?.toStringAsFixed(2).replaceAll('.', ',') ?? '0,00'} Kz',
                'dataHora': DateFormat('dd/MM/yyyy HH:mm')
                    .format(_parseDateTime(tx.createdAt)),
                'status': tx.status,
                'raw': tx,
              };
            }).toList();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> loadWithdrawalHistory() async {
    if (userAccountInfo?.id == null) {
      if (mounted) setState(() => isLoadingWithdrawals = false);
      return;
    }

    try {
      final result = await accountService.listDebitTransactionsAsync(
          userAccountInfo!.id!, 'debit');

      if (result['isSuccess'] && mounted) {
        final List<TransactionResponse> transactions =
            List<TransactionResponse>.from(result['data'] ?? []);

        setState(() {
          withdrawalHistory = transactions;
          isLoadingWithdrawals = false;
        });
      } else if (mounted) {
        setState(() => isLoadingWithdrawals = false);
      }
    } catch (e) {
      if (mounted) setState(() => isLoadingWithdrawals = false);
    }
  }

  // NOVO MÉTODO: Carregar todas as transações para Ganhos/Perdas
  Future<void> loadAllTransactions() async {
    if (userAccountInfo?.id == null) {
      if (mounted) setState(() => isLoadingTransactions = false);
      return;
    }

    try {
      // Carregar depósitos (créditos)
      final depositsResult = await accountService
          .listDepositTransactionsAsync(userAccountInfo!.id!);

      // Carregar saques (débitos)
      final withdrawalsResult = await accountService.listDebitTransactionsAsync(
          userAccountInfo!.id!, 'debit');

      if ((depositsResult['isSuccess'] || withdrawalsResult['isSuccess']) &&
          mounted) {
        final List<TransactionResponse> deposits = depositsResult['isSuccess']
            ? List<TransactionResponse>.from(depositsResult['data'] ?? [])
            : [];

        final List<TransactionResponse> withdrawals = withdrawalsResult[
                'isSuccess']
            ? List<TransactionResponse>.from(withdrawalsResult['data'] ?? [])
            : [];

        // Combinar todas as transações
        List<TransactionResponse> all = [...deposits, ...withdrawals];

        // Ordenar por data (mais recente primeiro)
        all.sort((a, b) =>
            _parseDateTime(b.createdAt).compareTo(_parseDateTime(a.createdAt)));

        setState(() {
          allTransactions = all;
          isLoadingTransactions = false;
          _calculateEarningsLosses(); // Calcular ganhos e perdas
        });
      } else if (mounted) {
        setState(() => isLoadingTransactions = false);
      }
    } catch (e) {
      if (mounted) setState(() => isLoadingTransactions = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime referenceDate = DateTime.now();
    final DateTime firstDate = DateTime(referenceDate.year - 100, 1, 1);
    final DateTime lastDate = DateTime(referenceDate.year + 10, 12, 31);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? referenceDate,
      firstDate: firstDate,
      lastDate: lastDate,
      currentDate: referenceDate,
      locale: const Locale('pt', 'BR'),
      helpText: 'SELECIONAR DATA',
      cancelText: 'CANCELAR',
      confirmText: 'CONFIRMAR',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: _surfaceColor,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedPeriodFilter = 'DATA';
      });
      _loadEarningsLossesData();
    }
  }

  DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDENTE':
        return _warningColor;
      case 'PROCESSANDO':
        return _infoColor;
      case 'CONCLUIDO':
      case 'REALIZADO':
        return _successColor;
      case 'CANCELADO':
        return _errorColor;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDENTE':
        return 'Pendente';
      case 'PROCESSANDO':
        return 'Processando';
      case 'CONCLUIDO':
      case 'REALIZADO':
        return 'Concluído';
      case 'CANCELADO':
        return 'Cancelado';
      default:
        return status;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'PENDENTE':
        return Icons.pending_rounded;
      case 'PROCESSANDO':
        return Icons.autorenew_rounded;
      case 'CONCLUIDO':
      case 'REALIZADO':
        return Icons.check_circle_rounded;
      case 'CANCELADO':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  List<TransactionResponse> _getFilteredWithdrawals() {
    if (_selectedFilter == 'TODOS') return withdrawalHistory;

    return withdrawalHistory.where((withdrawal) {
      return withdrawal.status.toUpperCase() == _selectedFilter;
    }).toList();
  }

  double _getFilteredTotal() {
    return _getFilteredWithdrawals()
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // Método auxiliar para determinar se é web
  bool get _isWeb => MediaQuery.of(context).size.width > _mobileBreakpoint;

  // Método auxiliar para obter o tamanho máximo do conteúdo
  double get _maxContentWidth {
    final screenWidth = MediaQuery.of(context).size.width;
    return _isWeb ? _webMaxWidth : screenWidth;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _backgroundColor,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header fixo - SEMPRE OCUPA LARGURA TOTAL
              _buildHeader(),

              // TUDO ABAIXO DO HEADER TEM SCROLL E É CENTRALIZADO NA WEB
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: _maxContentWidth,
                      ),
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Card de Saldo - CENTRALIZADO
                              _buildBalanceCard(),

                              // TabBar - CENTRALIZADO
                              _buildTabBar(),

                              // Conteúdo das Tabs - ALTURA FLEXÍVEL
                              Container(
                                width: double.infinity,
                                padding: _isWeb
                                    ? EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 16)
                                    : EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                constraints: BoxConstraints(
                                  minHeight:
                                      MediaQuery.of(context).size.height * 0.5,
                                ),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: TabBarView(
                                    controller: _model.tabBarController,
                                    children: [
                                      _buildHistoricoTab(),
                                      _buildSolicitacoesTab(),
                                      _buildProfitLossTab(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: _primaryGradient,
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: _isWeb
          ? EdgeInsets.symmetric(horizontal: 40, vertical: 24)
          : EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _maxContentWidth,
          ),
          child: Row(
            children: [
              _buildBackButton(),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  'CARTEIRA DIGITAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _isWeb ? 24 : 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              _buildWalletIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => context.safePop(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: _isWeb ? 48 : 44,
          height: _isWeb ? 48 : 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: _isWeb ? 20 : 18,
          ),
        ),
      ),
    );
  }

  Widget _buildWalletIcon() {
    return Container(
      width: _isWeb ? 48 : 44,
      height: _isWeb ? 48 : 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.account_balance_wallet_rounded,
        color: Colors.white,
        size: _isWeb ? 24 : 20,
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Padding(
      padding: _isWeb
          ? EdgeInsets.all(24)
          : EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _webCardMaxWidth,
          ),
          child: Container(
            width: double.infinity,
            padding: _isWeb ? EdgeInsets.all(32) : EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1E293B),
                  Color(0xFF0F172A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: _isWeb ? 24 : 22,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Saldo Disponível',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: _isWeb ? 16 : 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: _isWeb ? 14 : 13,
                            ),
                          ),
                          SizedBox(height: 6),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${(userAccountInfo?.availableBalance ?? 0.00).toStringAsFixed(2)} Kz',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: _isWeb ? 40 : 32,
                                fontWeight: FontWeight.w800,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Conta',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: _isWeb ? 14 : 13,
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                userAccountInfo?.accountNumber.toString() ??
                                    'N/A',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _isWeb ? 14 : 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
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
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: _isWeb
          ? EdgeInsets.symmetric(horizontal: 40)
          : EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _webCardMaxWidth,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: FlutterFlowButtonTabBar(
              useToggleButtonStyle: true,
              labelStyle: TextStyle(
                fontSize: _isWeb ? 16 : 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: _isWeb ? 16 : 14,
                fontWeight: FontWeight.w500,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: _onSurfaceColor.withOpacity(0.6),
              backgroundColor: _primaryColor,
              unselectedBackgroundColor: _surfaceColor,
              borderColor: _primaryColor,
              unselectedBorderColor: _outlineColor,
              borderWidth: 2,
              borderRadius: 12,
              elevation: 0,
              labelPadding: EdgeInsets.symmetric(
                horizontal: _isWeb ? 20 : 14, // Ajustado para 3 tabs
                vertical: _isWeb ? 14 : 12,
              ),
              buttonMargin: EdgeInsets.all(4),
              tabs: [
                Tab(text: 'Histórico'),
                Tab(text: 'Solicitações'),
                Tab(text: 'Ganhos e Perdas'), // NOVA TAB
              ],
              controller: _model.tabBarController,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoricoTab() {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (depositHistory.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history_rounded,
        title: 'Nenhuma transação',
        subtitle: 'Seu histórico de transações aparecerá aqui',
      );
    }

    return Container(
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _webCardMaxWidth,
          ),
          child: ListView.separated(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: depositHistory.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: _outlineColor.withOpacity(0.3),
              indent: 16,
              endIndent: 16,
            ),
            padding: EdgeInsets.only(top: 8, bottom: 20),
            itemBuilder: (context, index) {
              final item = depositHistory[index];
              final isDeposit = item['operacao'] == 'DEPÓSITO';
              final statusColor = _getStatusColor(item['status']);

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showTransactionDetails(
                        item['raw'] as TransactionResponse),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: _isWeb ? EdgeInsets.all(16) : EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Ícone
                          Container(
                            width: _isWeb ? 52 : 44,
                            height: _isWeb ? 52 : 44,
                            decoration: BoxDecoration(
                              color: (isDeposit ? _successColor : _primaryColor)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isDeposit
                                  ? Icons.arrow_downward_rounded
                                  : Icons.arrow_upward_rounded,
                              color: isDeposit ? _successColor : _primaryColor,
                              size: _isWeb ? 24 : 22,
                            ),
                          ),
                          SizedBox(width: _isWeb ? 16 : 12),

                          // Detalhes
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['operacao'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: _isWeb ? 16 : 15,
                                    color: _onSurfaceColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  item['dataHora'],
                                  style: TextStyle(
                                    fontSize: _isWeb ? 13 : 12,
                                    color: _onSurfaceColor.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: _isWeb ? 16 : 8),

                          // Montante e Status
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  item['montante'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: _isWeb ? 16 : 15,
                                    color: _onSurfaceColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: statusColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        _getStatusLabel(item['status']),
                                        style: TextStyle(
                                          fontSize: _isWeb ? 12 : 11,
                                          fontWeight: FontWeight.w600,
                                          color: statusColor,
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
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSolicitacoesTab() {
    final filteredWithdrawals = _getFilteredWithdrawals();

    return Container(
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _webCardMaxWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filtros - AGORA VISÍVEIS NO TOPO
              _buildFiltersSection(),
              SizedBox(height: _isWeb ? 16 : 12),

              // Estatísticas - VISÍVEIS APÓS OS FILTROS
              if (filteredWithdrawals.isNotEmpty)
                Column(
                  children: [
                    _buildStatsCard(filteredWithdrawals),
                    SizedBox(height: _isWeb ? 16 : 12),
                  ],
                ),

              // Lista de solicitações - COM SCROLL PRÓPRIO
              Expanded(
                child: isLoadingWithdrawals
                    ? _buildLoadingState()
                    : filteredWithdrawals.isEmpty
                        ? _buildEmptyState(
                            icon: Icons.request_quote_rounded,
                            title: 'Nenhuma solicitação encontrada',
                            subtitle: _selectedFilter == 'TODOS'
                                ? 'Você ainda não fez nenhuma solicitação de saque'
                                : 'Nenhuma solicitação com o estado "${_getStatusLabel(_selectedFilter)}"',
                          )
                        : RefreshIndicator(
                            color: _primaryColor,
                            backgroundColor: _surfaceColor,
                            onRefresh: loadWithdrawalHistory,
                            child: ListView.separated(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.only(top: 8, bottom: 20),
                              itemCount: filteredWithdrawals.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: _isWeb ? 12 : 8),
                              itemBuilder: (context, index) {
                                final withdrawal = filteredWithdrawals[index];
                                final statusColor =
                                    _getStatusColor(withdrawal.status);
                                final dateTime =
                                    _parseDateTime(withdrawal.createdAt);
                                final formattedDate =
                                    DateFormat('dd/MM/yyyy').format(dateTime);
                                final formattedTime =
                                    DateFormat('HH:mm').format(dateTime);
                                final amount =
                                    '${withdrawal.amount.toStringAsFixed(2).replaceAll('.', ',')} Kz';
                                final shortId = withdrawal.id
                                        ?.substring(0, 6)
                                        .toUpperCase() ??
                                    'N/A';

                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      onTap: () =>
                                          _showWithdrawalDetails(withdrawal),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: _isWeb
                                            ? EdgeInsets.all(16)
                                            : EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: _surfaceColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.03),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            // Status indicator
                                            Container(
                                              width: 8,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: statusColor,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            SizedBox(width: _isWeb ? 16 : 12),

                                            // Detalhes
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'LEVANTAMENTO',
                                                        style: TextStyle(
                                                          fontSize:
                                                              _isWeb ? 16 : 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              _onSurfaceColor,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        '#$shortId',
                                                        style: TextStyle(
                                                          fontSize:
                                                              _isWeb ? 12 : 10,
                                                          color: _onSurfaceColor
                                                              .withOpacity(0.5),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              'monospace',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: _isWeb ? 8 : 6),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .calendar_today_rounded,
                                                        size: _isWeb ? 14 : 12,
                                                        color: _onSurfaceColor
                                                            .withOpacity(0.5),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              _isWeb ? 6 : 4),
                                                      Text(
                                                        formattedDate,
                                                        style: TextStyle(
                                                          fontSize:
                                                              _isWeb ? 13 : 11,
                                                          color: _onSurfaceColor
                                                              .withOpacity(0.6),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              _isWeb ? 12 : 8),
                                                      Icon(
                                                        Icons
                                                            .access_time_rounded,
                                                        size: _isWeb ? 14 : 12,
                                                        color: _onSurfaceColor
                                                            .withOpacity(0.5),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              _isWeb ? 6 : 4),
                                                      Text(
                                                        formattedTime,
                                                        style: TextStyle(
                                                          fontSize:
                                                              _isWeb ? 13 : 11,
                                                          color: _onSurfaceColor
                                                              .withOpacity(0.6),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(width: _isWeb ? 16 : 12),

                                            // Valor e Status
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  amount,
                                                  style: TextStyle(
                                                    fontSize: _isWeb ? 16 : 14,
                                                    fontWeight: FontWeight.w800,
                                                    color: _primaryColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: _isWeb ? 8 : 6),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          _isWeb ? 10 : 8,
                                                      vertical: _isWeb ? 4 : 3),
                                                  decoration: BoxDecoration(
                                                    color: statusColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text(
                                                    _getStatusLabel(
                                                        withdrawal.status),
                                                    style: TextStyle(
                                                      fontSize:
                                                          _isWeb ? 12 : 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: statusColor,
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
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NOVO WIDGET: Tab de Ganhos & Perdas
  Widget _buildProfitLossTab() {
    return Container(
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _webCardMaxWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPeriodFilterSection(),
              SizedBox(height: _isWeb ? 24 : 16),
              _buildEarningsLossesCards(),
              SizedBox(height: _isWeb ? 24 : 16),
              Expanded(
                child: isLoadingRankings
                    ? _buildLoadingState()
                    : earningsLossesHistory.isEmpty
                        ? _buildEmptyState(
                            icon: Icons.bar_chart_rounded,
                            title: 'Nenhum jogo neste período',
                            subtitle: _selectedPeriodFilter == 'DATA' &&
                                    _selectedDate != null
                                ? 'Não há jogos registrados na data ${_dateFormat.format(_selectedDate!)}'
                                : 'Suas vitórias e derrotas aparecerão aqui',
                          )
                        : RefreshIndicator(
                            color: _primaryColor,
                            backgroundColor: _surfaceColor,
                            onRefresh: _loadEarningsLossesData,
                            child: _buildRankingList(),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NOVO WIDGET: Filtro de período para Ganhos/Perdas
  Widget _buildPeriodFilterSection() {
    return Container(
      padding: EdgeInsets.all(_isWeb ? 16 : 12),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: _primaryColor,
                size: _isWeb ? 20 : 18,
              ),
              SizedBox(width: _isWeb ? 8 : 6),
              Text(
                'Período',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: _isWeb ? 15 : 14,
                  color: _onSurfaceColor,
                ),
              ),
            ],
          ),
          SizedBox(height: _isWeb ? 12 : 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _periodOptions.map((period) {
              final isActive = _selectedPeriodFilter == period;
              final periodColor = _getPeriodColor(period);

              return _buildPeriodFilterButton(
                label: period,
                isActive: isActive,
                color: periodColor,
                onTap: () {
                  if (period == 'DATA') {
                    _selectDate(context);
                  } else {
                    setState(() {
                      _selectedPeriodFilter = period;
                      _selectedDate = null;
                      _calculateEarningsLosses();
                    });
                  }
                },
                icon: _getPeriodIcon(period),
              );
            }).toList(),
          ),
          if (_selectedDate != null && _selectedPeriodFilter == 'DATA')
            Padding(
              padding: EdgeInsets.only(top: _isWeb ? 16 : 12),
              child: Container(
                padding: EdgeInsets.all(_isWeb ? 12 : 10),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.date_range_rounded,
                          color: _primaryColor,
                          size: _isWeb ? 18 : 16,
                        ),
                        SizedBox(width: _isWeb ? 8 : 6),
                        Text(
                          'Data selecionada:',
                          style: TextStyle(
                            fontSize: _isWeb ? 14 : 12,
                            fontWeight: FontWeight.w600,
                            color: _onSurfaceColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(_selectedDate!),
                          style: TextStyle(
                            fontSize: _isWeb ? 14 : 12,
                            fontWeight: FontWeight.w700,
                            color: _primaryColor,
                          ),
                        ),
                        SizedBox(width: _isWeb ? 12 : 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = null;
                              _selectedPeriodFilter = 'HOJE';
                              _calculateEarningsLosses();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(_isWeb ? 6 : 4),
                            decoration: BoxDecoration(
                              color: _errorColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: _errorColor,
                              size: _isWeb ? 16 : 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // NOVO WIDGET: Botão de filtro de período
  Widget _buildPeriodFilterButton({
    required String label,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _isWeb ? 16 : 12,
            vertical: _isWeb ? 10 : 8,
          ),
          decoration: BoxDecoration(
            color: isActive ? color : color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? color : color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : color,
                size: _isWeb ? 16 : 14,
              ),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: _isWeb ? 13 : 11,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NOVO WIDGET: Cards de Ganhos e Perdas
  Widget _buildEarningsLossesCards() {
    return Row(
      children: [
        // Card de Ganhos
        Expanded(
          child: _buildEarningsLossesCard(
            title: 'GANHO',
            amount: earningsLossesData['ganhos']!,
            color: _successColor,
            icon: Icons.arrow_upward_rounded,
            prefix: '+',
          ),
        ),
        SizedBox(width: _isWeb ? 16 : 12),

        // Card de Perdas
        Expanded(
          child: _buildEarningsLossesCard(
            title: 'PERDA',
            amount: earningsLossesData['perdas']!,
            color: _errorColor,
            icon: Icons.arrow_downward_rounded,
            prefix: '-',
          ),
        ),
        SizedBox(width: _isWeb ? 16 : 12),

        // Card de Total
        Expanded(
          child: _buildEarningsLossesCard(
            title: 'TOTAL',
            amount: earningsLossesData['total']!,
            color:
                earningsLossesData['total']! >= 0 ? _primaryColor : _errorColor,
            icon: earningsLossesData['total']! >= 0
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            prefix: earningsLossesData['total']! >= 0 ? '+' : '',
          ),
        ),
      ],
    );
  }

  // NOVO WIDGET: Card individual de Ganho/Perda
  Widget _buildEarningsLossesCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
    required String prefix,
  }) {
    return Container(
      padding: _isWeb ? EdgeInsets.all(20) : EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: _isWeb ? 36 : 32,
                height: _isWeb ? 36 : 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: _isWeb ? 18 : 16,
                ),
              ),
              SizedBox(width: _isWeb ? 12 : 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: _isWeb ? 13 : 11,
                    fontWeight: FontWeight.w600,
                    color: _onSurfaceColor.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: _isWeb ? 16 : 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$prefix${amount.toStringAsFixed(2).replaceAll('.', ',')} Kz',
              style: TextStyle(
                fontSize: _isWeb ? 20 : 18,
                fontWeight: FontWeight.w800,
                color: color,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NOVO WIDGET: Lista de transações para Ganhos/Perdas
  Widget _buildTransactionList() {
    final now = DateTime.now();
    List<TransactionResponse> filteredTransactions = [];

    // Definir quais transações considerar baseado no período selecionado
    switch (_selectedPeriodFilter) {
      case 'HOJE':
        final startDate = DateTime(now.year, now.month, now.day);
        final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        filteredTransactions = allTransactions.where((tx) {
          final txDate = _parseDateTime(tx.createdAt);
          return txDate
                  .isAfter(startDate.subtract(Duration(milliseconds: 1))) &&
              txDate.isBefore(endDate.add(Duration(milliseconds: 1)));
        }).toList();
        break;
      case 'SEMANAL':
        final startDate = now.subtract(Duration(days: 7));
        final endDate = now;
        filteredTransactions = allTransactions.where((tx) {
          final txDate = _parseDateTime(tx.createdAt);
          return txDate
                  .isAfter(startDate.subtract(Duration(milliseconds: 1))) &&
              txDate.isBefore(endDate.add(Duration(milliseconds: 1)));
        }).toList();
        break;
      case 'MENSAL':
        final startDate = DateTime(now.year, now.month - 1, now.day);
        final endDate = now;
        filteredTransactions = allTransactions.where((tx) {
          final txDate = _parseDateTime(tx.createdAt);
          return txDate
                  .isAfter(startDate.subtract(Duration(milliseconds: 1))) &&
              txDate.isBefore(endDate.add(Duration(milliseconds: 1)));
        }).toList();
        break;
      case 'DATA':
        // Filtrar por data específica selecionada
        if (_selectedDate != null) {
          final startOfDay = DateTime(
              _selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
          final endOfDay = DateTime(_selectedDate!.year, _selectedDate!.month,
              _selectedDate!.day, 23, 59, 59);

          filteredTransactions = allTransactions.where((tx) {
            final txDate = _parseDateTime(tx.createdAt);
            return txDate
                    .isAfter(startOfDay.subtract(Duration(milliseconds: 1))) &&
                txDate.isBefore(endOfDay.add(Duration(milliseconds: 1)));
          }).toList();
        } else {
          filteredTransactions = allTransactions;
        }
        break;
      default:
        final startDate = DateTime(now.year, now.month, now.day);
        final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        filteredTransactions = allTransactions.where((tx) {
          final txDate = _parseDateTime(tx.createdAt);
          return txDate
                  .isAfter(startDate.subtract(Duration(milliseconds: 1))) &&
              txDate.isBefore(endDate.add(Duration(milliseconds: 1)));
        }).toList();
    }

    if (filteredTransactions.isEmpty) {
      String subtitle = 'Não há transações para o período selecionado';
      if (_selectedPeriodFilter == 'DATA' && _selectedDate != null) {
        subtitle =
            'Não há transações na data ${_dateFormat.format(_selectedDate!)}';
      }

      return _buildEmptyState(
        icon: Icons.bar_chart_rounded,
        title: 'Nenhuma transação no período',
        subtitle: subtitle,
      );
    }

    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 8, bottom: 20),
      itemCount: filteredTransactions.length,
      separatorBuilder: (_, __) => SizedBox(height: _isWeb ? 12 : 8),
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];
        final isCredit = transaction.type == 'credit';
        final statusColor = _getStatusColor(transaction.status);
        final dateTime = _parseDateTime(transaction.createdAt);
        final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
        final formattedTime = DateFormat('HH:mm').format(dateTime);
        final amount =
            '${isCredit ? '+' : '-'}${transaction.amount.toStringAsFixed(2).replaceAll('.', ',')} Kz';
        final title = isCredit ? 'DEPÓSITO' : 'LEVANTAMENTO';

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => _showTransactionDetails(transaction),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: _isWeb ? EdgeInsets.all(16) : EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _outlineColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Ícone
                    Container(
                      width: _isWeb ? 48 : 40,
                      height: _isWeb ? 48 : 40,
                      decoration: BoxDecoration(
                        color: (isCredit ? _successColor : _errorColor)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isCredit
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: isCredit ? _successColor : _errorColor,
                        size: _isWeb ? 20 : 18,
                      ),
                    ),
                    SizedBox(width: _isWeb ? 16 : 12),

                    // Detalhes
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: _isWeb ? 16 : 14,
                              fontWeight: FontWeight.w700,
                              color: _onSurfaceColor,
                            ),
                          ),
                          SizedBox(height: _isWeb ? 6 : 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: _isWeb ? 12 : 10,
                                color: _onSurfaceColor.withOpacity(0.5),
                              ),
                              SizedBox(width: _isWeb ? 4 : 3),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: _isWeb ? 12 : 10,
                                  color: _onSurfaceColor.withOpacity(0.6),
                                ),
                              ),
                              SizedBox(width: _isWeb ? 12 : 8),
                              Icon(
                                Icons.access_time_rounded,
                                size: _isWeb ? 12 : 10,
                                color: _onSurfaceColor.withOpacity(0.5),
                              ),
                              SizedBox(width: _isWeb ? 4 : 3),
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  fontSize: _isWeb ? 12 : 10,
                                  color: _onSurfaceColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: _isWeb ? 16 : 12),

                    // Valor e Status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          amount,
                          style: TextStyle(
                            fontSize: _isWeb ? 16 : 14,
                            fontWeight: FontWeight.w800,
                            color: isCredit ? _successColor : _errorColor,
                          ),
                        ),
                        SizedBox(height: _isWeb ? 8 : 6),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: _isWeb ? 10 : 8,
                              vertical: _isWeb ? 4 : 3),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _getStatusLabel(transaction.status),
                            style: TextStyle(
                              fontSize: _isWeb ? 11 : 9,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
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
        );
      },
    );
  }

  // NOVO MÉTODO: Obter cor baseada no período
  Color _getPeriodColor(String period) {
    switch (period) {
      case 'HOJE':
        return _primaryColor;
      case 'SEMANAL':
        return _infoColor;
      case 'MENSAL':
        return _successColor;
      case 'DATA':
        return _warningColor;
      default:
        return _primaryColor;
    }
  }

  // NOVO MÉTODO: Obter ícone baseado no período
  IconData _getPeriodIcon(String period) {
    switch (period) {
      case 'HOJE':
        return Icons.today_rounded;
      case 'SEMANAL':
        return Icons.date_range_rounded;
      case 'MENSAL':
        return Icons.calendar_month_rounded;
      case 'DATA':
        return Icons.calendar_today_rounded;
      default:
        return Icons.today_rounded;
    }
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: EdgeInsets.all(_isWeb ? 16 : 12),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_list_rounded,
                color: _primaryColor,
                size: _isWeb ? 20 : 18,
              ),
              SizedBox(width: _isWeb ? 8 : 6),
              Text(
                'Filtrar por status',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: _isWeb ? 15 : 14,
                  color: _onSurfaceColor,
                ),
              ),
              Spacer(),
              if (_selectedFilter != 'TODOS')
                GestureDetector(
                  onTap: () {
                    setState(() => _selectedFilter = 'TODOS');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: _isWeb ? 12 : 10, vertical: _isWeb ? 6 : 4),
                    decoration: BoxDecoration(
                      color: _outlineColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.clear_all_rounded, size: _isWeb ? 14 : 12),
                        SizedBox(width: 4),
                        Text(
                          'Limpar',
                          style: TextStyle(
                            fontSize: _isWeb ? 13 : 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: _isWeb ? 12 : 8),
          // Filtros em linha simples
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _filterOptions.map((filter) {
              final isActive = _selectedFilter == filter;
              final statusColor = _getStatusColor(filter);

              return _buildFilterButton(
                label: filter == 'TODOS' ? 'Todos' : _getStatusLabel(filter),
                isActive: isActive,
                color: statusColor,
                onTap: () => setState(() => _selectedFilter = filter),
                icon: _getStatusIcon(filter),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _isWeb ? 12 : 10,
            vertical: _isWeb ? 8 : 6,
          ),
          decoration: BoxDecoration(
            color: isActive ? color : color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? color : color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : color,
                size: _isWeb ? 16 : 14,
              ),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: _isWeb ? 13 : 11,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(List<TransactionResponse> withdrawals) {
    final total = _getFilteredTotal();
    final count = withdrawals.length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(_isWeb ? 16 : 12),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Solicitações
          Column(
            children: [
              Row(
                children: [
                  Icon(Icons.list_alt_rounded,
                      color: _primaryColor, size: _isWeb ? 18 : 16),
                  SizedBox(width: _isWeb ? 6 : 4),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: _isWeb ? 20 : 18,
                      fontWeight: FontWeight.w800,
                      color: _onSurfaceColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: _isWeb ? 4 : 2),
              Text(
                'Solicitações',
                style: TextStyle(
                  fontSize: _isWeb ? 12 : 10,
                  color: _onSurfaceColor.withOpacity(0.6),
                ),
              ),
            ],
          ),

          // Divisor
          Container(
            width: 1,
            height: 40,
            color: _outlineColor,
          ),

          // Valor Total
          Column(
            children: [
              Row(
                children: [
                  Icon(Icons.monetization_on_rounded,
                      color: _successColor, size: _isWeb ? 18 : 16),
                  SizedBox(width: _isWeb ? 6 : 4),
                  Text(
                    '${total.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(
                      fontSize: _isWeb ? 20 : 18,
                      fontWeight: FontWeight.w800,
                      color: _onSurfaceColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: _isWeb ? 4 : 2),
              Text(
                'Valor Total',
                style: TextStyle(
                  fontSize: _isWeb ? 12 : 10,
                  color: _onSurfaceColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: _isWeb ? 40 : 32,
            height: _isWeb ? 40 : 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: _primaryColor,
            ),
          ),
          SizedBox(height: _isWeb ? 12 : 8),
          Text(
            'Carregando...',
            style: TextStyle(
              fontSize: _isWeb ? 14 : 12,
              color: _onSurfaceColor.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_isWeb ? 32 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: _isWeb ? 80 : 60,
              height: _isWeb ? 80 : 60,
              decoration: BoxDecoration(
                color: _outlineColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: _onSurfaceColor.withOpacity(0.4),
                size: _isWeb ? 36 : 28,
              ),
            ),
            SizedBox(height: _isWeb ? 20 : 16),
            Text(
              title,
              style: TextStyle(
                fontSize: _isWeb ? 16 : 14,
                fontWeight: FontWeight.w700,
                color: _onSurfaceColor.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _isWeb ? 8 : 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _isWeb ? 14 : 12,
                color: _onSurfaceColor.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetails(TransactionResponse transaction) {
    showDialog(
      context: context,
      builder: (context) => _buildTransactionDialog(transaction),
    );
  }

  void _showWithdrawalDetails(TransactionResponse withdrawal) {
    showDialog(
      context: context,
      builder: (context) => _buildWithdrawalDialog(withdrawal),
    );
  }

  AlertDialog _buildTransactionDialog(TransactionResponse transaction) {
    final dateTime = _parseDateTime(transaction.createdAt);
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    final isDeposit = transaction.type == 'credit';
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            isDeposit
                ? Icons.arrow_downward_rounded
                : Icons.arrow_upward_rounded,
            color: isDeposit ? _successColor : _primaryColor,
            size: _isWeb ? 28 : 24,
          ),
          SizedBox(width: 12),
          Text(
            isDeposit ? 'DEPÓSITO' : 'LEVANTAMENTO',
            style: TextStyle(
              fontSize: _isWeb ? 20 : 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      content: Container(
        width: _isWeb ? 400 : 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDetailItem(
                'Valor:', '${transaction.amount.toStringAsFixed(2)} Kz'),
            SizedBox(height: 8),
            _buildDetailItem('Data:', formattedDate),
            SizedBox(height: 8),
            _buildDetailItem('Estado:', _getStatusLabel(transaction.status)),
            if (transaction.reference != null) ...[
              SizedBox(height: 8),
              _buildDetailItem('Referência:', transaction.reference! as String),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'FECHAR',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildWithdrawalDialog(TransactionResponse withdrawal) {
    final dateTime = _parseDateTime(withdrawal.createdAt);
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    final statusColor = _getStatusColor(withdrawal.status);
    final amount =
        '${withdrawal.amount.toStringAsFixed(2).replaceAll('.', ',')} Kz';
    final shortId = withdrawal.id?.substring(0, 8).toUpperCase() ?? 'N/A';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: _isWeb ? 100 : 20,
        vertical: _isWeb ? 40 : 32,
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _isWeb ? 500 : 400,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cabeçalho
                Container(
                  padding: EdgeInsets.all(_isWeb ? 24 : 20),
                  decoration: BoxDecoration(
                    gradient: _primaryGradient,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: _isWeb ? 56 : 44,
                        height: _isWeb ? 56 : 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.money_off_csred_rounded,
                          color: Colors.white,
                          size: _isWeb ? 28 : 24,
                        ),
                      ),
                      SizedBox(width: _isWeb ? 16 : 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DETALHES',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: _isWeb ? 18 : 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '#$shortId',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: _isWeb ? 13 : 11,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Status badge
                Padding(
                  padding: EdgeInsets.only(
                      top: _isWeb ? 20 : 16,
                      left: _isWeb ? 24 : 20,
                      right: _isWeb ? 24 : 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: _isWeb ? 20 : 16,
                        vertical: _isWeb ? 10 : 8),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: _isWeb ? 28 : 24,
                          height: _isWeb ? 28 : 24,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getStatusIcon(withdrawal.status),
                            color: Colors.white,
                            size: _isWeb ? 14 : 12,
                          ),
                        ),
                        SizedBox(width: _isWeb ? 12 : 8),
                        Text(
                          _getStatusLabel(withdrawal.status),
                          style: TextStyle(
                            fontSize: _isWeb ? 16 : 14,
                            fontWeight: FontWeight.w800,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Conteúdo
                Padding(
                  padding: EdgeInsets.all(_isWeb ? 24 : 20),
                  child: Column(
                    children: [
                      // Valor
                      Container(
                        padding: EdgeInsets.all(_isWeb ? 20 : 16),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _primaryColor.withOpacity(0.1),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'VALOR SOLICITADO',
                              style: TextStyle(
                                fontSize: _isWeb ? 13 : 11,
                                color: _onSurfaceColor.withOpacity(0.6),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: _isWeb ? 12 : 8),
                            Text(
                              amount,
                              style: TextStyle(
                                fontSize: _isWeb ? 32 : 28,
                                fontWeight: FontWeight.w800,
                                color: _primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: _isWeb ? 24 : 20),

                      // Informações
                      Column(
                        children: [
                          _buildDetailRow(
                            icon: Icons.calendar_today_rounded,
                            label: 'Data',
                            value: DateFormat('dd/MM/yyyy').format(dateTime),
                          ),
                          SizedBox(height: _isWeb ? 16 : 12),
                          _buildDetailRow(
                            icon: Icons.access_time_rounded,
                            label: 'Hora',
                            value: DateFormat('HH:mm').format(dateTime),
                          ),
                          SizedBox(height: _isWeb ? 16 : 12),
                          _buildDetailRow(
                            icon: Icons.receipt_long_rounded,
                            label: 'Tipo',
                            value: 'LEVANTAMENTO',
                          ),
                        ],
                      ),

                      // Referência
                      if (withdrawal.reference != null) ...[
                        SizedBox(height: _isWeb ? 24 : 20),
                        Container(
                          padding: EdgeInsets.all(_isWeb ? 16 : 12),
                          decoration: BoxDecoration(
                            color: _outlineColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.receipt_rounded,
                                    size: _isWeb ? 18 : 16,
                                    color: _onSurfaceColor.withOpacity(0.6),
                                  ),
                                  SizedBox(width: _isWeb ? 8 : 6),
                                  Text(
                                    'Referência',
                                    style: TextStyle(
                                      fontSize: _isWeb ? 15 : 13,
                                      fontWeight: FontWeight.w600,
                                      color: _onSurfaceColor.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: _isWeb ? 8 : 6),
                              Container(
                                padding: EdgeInsets.all(_isWeb ? 12 : 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _outlineColor,
                                    width: 1,
                                  ),
                                ),
                                child: SelectableText(
                                  withdrawal.reference! as String,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: _isWeb ? 14 : 12,
                                    color: _onSurfaceColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Botão de fechar
                Container(
                  padding: EdgeInsets.all(_isWeb ? 24 : 20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: _outlineColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, _isWeb ? 56 : 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'FECHAR',
                      style: TextStyle(
                        fontSize: _isWeb ? 16 : 15,
                        fontWeight: FontWeight.w700,
                      ),
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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor, // Adiciona parâmetro opcional
  }) {
    final color = iconColor ??
        _onSurfaceColor.withOpacity(0.6); // Usa padrão se não fornecido

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: _isWeb ? 20 : 16,
            color: color,
          ),
          SizedBox(width: _isWeb ? 12 : 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: _isWeb ? 15 : 13,
                color: _onSurfaceColor.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: _isWeb ? 16 : 14,
                  fontWeight: FontWeight.w700,
                  color: _onSurfaceColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _isWeb ? 120 : 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: _isWeb ? 15 : 14,
                color: _onSurfaceColor.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: _isWeb ? 15 : 14,
                color: _onSurfaceColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingList() {
    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 8, bottom: 20),
      itemCount: earningsLossesHistory.length,
      separatorBuilder: (_, __) => SizedBox(height: _isWeb ? 12 : 8),
      itemBuilder: (context, index) {
        final ranking = earningsLossesHistory[index];
        final isVitoria = ranking.is_winner;
        final dateTime = ranking.match_end_date ?? DateTime.now();
        final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
        final formattedTime = DateFormat('HH:mm').format(dateTime);
        final amount = ranking.score_display;
        final title = isVitoria ? 'GANHO' : 'PERDA';

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => _showRankingDetails(ranking),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: _isWeb ? EdgeInsets.all(16) : EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _outlineColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Ícone
                    Container(
                      width: _isWeb ? 48 : 40,
                      height: _isWeb ? 48 : 40,
                      decoration: BoxDecoration(
                        color: (isVitoria ? _successColor : _errorColor)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isVitoria
                            ? Icons.emoji_events_rounded
                            : Icons.sentiment_dissatisfied_rounded,
                        color: isVitoria ? _successColor : _errorColor,
                        size: _isWeb ? 20 : 18,
                      ),
                    ),
                    SizedBox(width: _isWeb ? 16 : 12),

                    // Detalhes
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: _isWeb ? 16 : 14,
                              fontWeight: FontWeight.w700,
                              color: _onSurfaceColor,
                            ),
                          ),
                          SizedBox(height: _isWeb ? 6 : 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: _isWeb ? 12 : 10,
                                color: _onSurfaceColor.withOpacity(0.5),
                              ),
                              SizedBox(width: _isWeb ? 4 : 3),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: _isWeb ? 12 : 10,
                                  color: _onSurfaceColor.withOpacity(0.6),
                                ),
                              ),
                              SizedBox(width: _isWeb ? 12 : 8),
                              Icon(
                                Icons.access_time_rounded,
                                size: _isWeb ? 12 : 10,
                                color: _onSurfaceColor.withOpacity(0.5),
                              ),
                              SizedBox(width: _isWeb ? 4 : 3),
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  fontSize: _isWeb ? 12 : 10,
                                  color: _onSurfaceColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: _isWeb ? 16 : 12),

                    // Valor
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          amount,
                          style: TextStyle(
                            fontSize: _isWeb ? 16 : 14,
                            fontWeight: FontWeight.w800,
                            color: isVitoria ? _successColor : _errorColor,
                          ),
                        ),
                        SizedBox(height: _isWeb ? 8 : 6),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: _isWeb ? 10 : 8,
                              vertical: _isWeb ? 4 : 3),
                          decoration: BoxDecoration(
                            color: (isVitoria ? _successColor : _errorColor)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isVitoria ? 'GANHOU' : 'PERDEU',
                            style: TextStyle(
                              fontSize: _isWeb ? 11 : 9,
                              fontWeight: FontWeight.w600,
                              color: isVitoria ? _successColor : _errorColor,
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
        );
      },
    );
  }

  void _showRankingDetails(RankingDetailResponse ranking) {
    final isVitoria = ranking.result_type == RankingResultTypeEnum.VITORIA;
    final dateTime = ranking.match_end_date ?? DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    final formattedTime = DateFormat('HH:mm').format(dateTime);
    final statusColor = isVitoria ? _successColor : _errorColor;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: _isWeb ? 100 : 20,
          vertical: _isWeb ? 40 : 32,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _isWeb ? 500 : 400,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cabeçalho com gradient
                  Container(
                    padding: EdgeInsets.all(_isWeb ? 24 : 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isVitoria
                            ? [Color(0xFF10B981), Color(0xFF34D399)] // Verde
                            : [
                                Color(0xFFEF4444),
                                Color(0xFFF87171)
                              ], // Vermelho
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: _isWeb ? 56 : 44,
                          height: _isWeb ? 56 : 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            isVitoria
                                ? Icons.emoji_events_rounded
                                : Icons.sentiment_dissatisfied_rounded,
                            color: Colors.white,
                            size: _isWeb ? 28 : 24,
                          ),
                        ),
                        SizedBox(width: _isWeb ? 16 : 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isVitoria ? 'VITÓRIA' : 'DERROTA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _isWeb ? 20 : 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Detalhes do Jogo',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: _isWeb ? 14 : 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Badge de status
                  Padding(
                    padding: EdgeInsets.only(
                      top: _isWeb ? 20 : 16,
                      left: _isWeb ? 24 : 20,
                      right: _isWeb ? 24 : 20,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: _isWeb ? 20 : 16,
                        vertical: _isWeb ? 10 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: _isWeb ? 28 : 24,
                            height: _isWeb ? 28 : 24,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isVitoria
                                  ? Icons.check_rounded
                                  : Icons.close_rounded,
                              color: Colors.white,
                              size: _isWeb ? 14 : 12,
                            ),
                          ),
                          SizedBox(width: _isWeb ? 12 : 8),
                          Text(
                            isVitoria ? 'GANHOU' : 'PERDEU',
                            style: TextStyle(
                              fontSize: _isWeb ? 16 : 14,
                              fontWeight: FontWeight.w800,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Conteúdo principal
                  Padding(
                    padding: EdgeInsets.all(_isWeb ? 24 : 20),
                    child: Column(
                      children: [
                        // Card de resultado
                        Container(
                          padding: EdgeInsets.all(_isWeb ? 20 : 16),
                          decoration: BoxDecoration(
                            color: _primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _primaryColor.withOpacity(0.1),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [ 
                              SizedBox(height: _isWeb ? 12 : 8),
                              Text(
                                ranking.score_display,
                                style: TextStyle(
                                  fontSize: _isWeb ? 32 : 28,
                                  fontWeight: FontWeight.w800,
                                  color:
                                      isVitoria ? _successColor : _errorColor,
                                ),
                              ),
                              if (ranking.prize_amount > 0 && isVitoria) ...[
                                SizedBox(height: _isWeb ? 12 : 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: _isWeb ? 16 : 12,
                                    vertical: _isWeb ? 8 : 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _successColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ), 
                                ),
                              ],
                            ],
                          ),
                        ),

                        SizedBox(height: _isWeb ? 24 : 20), 
                        Column(
                          children: [
                            _buildDetailRow(
                              icon: Icons.calendar_today_rounded,
                              label: 'Data da Partida',
                              value: formattedDate,
                              iconColor: _primaryColor,
                            ),
                            SizedBox(height: _isWeb ? 16 : 12),
                            _buildDetailRow(
                              icon: Icons.access_time_rounded,
                              label: 'Hora da Partida',
                              value: formattedTime,
                              iconColor: _primaryColor,
                            ),
                            if (ranking.entry_fee > 0) ...[
                              SizedBox(height: _isWeb ? 16 : 12),
                              _buildDetailRow(
                                icon: Icons.price_change_rounded,
                                label: 'Taxa de Entrada',
                                value:
                                    '${ranking.entry_fee.toStringAsFixed(2)} Kz',
                                iconColor: _warningColor,
                              ),
                            ],
                            if (ranking.match_status != null) ...[
                              SizedBox(height: _isWeb ? 16 : 12),
                              _buildDetailRow(
                                icon: Icons.videogame_asset_rounded,
                                label: 'Estado da Partida',
                                value: ranking.match_status.toString(),
                                iconColor: _infoColor,
                              ),
                            ],
                          ],
                        ), 
                      ],
                    ),
                  ), 
                  Container(
                    padding: EdgeInsets.all(_isWeb ? 24 : 20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: _outlineColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, _isWeb ? 56 : 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: _isWeb ? 32 : 24,
                          vertical: _isWeb ? 16 : 14,
                        ),
                      ),
                      child: Text(
                        'FECHAR DETALHES',
                        style: TextStyle(
                          fontSize: _isWeb ? 16 : 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
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
  }
}
