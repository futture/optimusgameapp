import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/account_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/responses/account_response.dart';
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
  final AccountService accountService = AccountService();
  bool isLoading = true;
  bool isLoadingWithdrawals = true;
  String _selectedFilter = 'TODOS';
  List<String> _filterOptions = [
    'TODOS',
    'PENDENTE',
    'PROCESSANDO',
    'CONCLUIDO',
    'CANCELADO'
  ];

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted &&
          (_model.textController1?.text.isEmpty == true ||
              _model.textController2?.text.isEmpty == true)) {
        //await _showEmptyFieldWarning();
      }
    });

    // Carregar dados do usuário
    _loadUserData();

    // Inicializar TabController
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));

    // Inicializar controladores de texto
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
                'operacao': tx.type == 'credit' ? 'Depósito' : 'Saque',
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

  // Método auxiliar para obter padding responsivo
  EdgeInsetsGeometry _getResponsivePadding() {
    if (_isWeb) {
      return EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      );
    }
    return EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 12.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header - OCUPA TODA A LARGURA
              _buildHeader(),

              // Conteúdo centralizado
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: _maxContentWidth,
                    ),
                    child: Column(
                      children: [
                        // Card de Saldo
                        _buildBalanceCard(),

                        // TabBar
                        _buildTabBar(),

                        // Conteúdo das Tabs
                        Expanded(
                          child: Padding(
                            padding: _getResponsivePadding(),
                            child: TabBarView(
                              controller: _model.tabBarController,
                              children: [
                                _buildHistoricoTab(),
                                _buildSolicitacoesTab(),
                              ],
                            ),
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
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity, // Ocupa toda a largura
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
                fontSize: _isWeb ? 16 : 14,
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
                horizontal: _isWeb ? 32 : 24,
                vertical: _isWeb ? 16 : 14,
              ),
              buttonMargin: EdgeInsets.all(6),
              tabs: [
                Tab(text: 'Histórico'),
                Tab(text: 'Solicitações'),
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

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: _webCardMaxWidth,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 16),
          child: ListView.separated(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: depositHistory.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: _outlineColor.withOpacity(0.3),
              indent: 16,
              endIndent: 16,
            ),
            padding: EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              final item = depositHistory[index];
              final isDeposit = item['operacao'] == 'Depósito';
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
                      padding: _isWeb
                          ? EdgeInsets.all(16)
                          : EdgeInsets.all(14),
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

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: _webCardMaxWidth,
        ),
        child: Column(
          children: [
            // Filtros
            _buildFiltersSectionEnhanced(),
            SizedBox(height: _isWeb ? 20 : 16),

            // Estatísticas - SÓ SE HOUVER SOLICITAÇÕES
            if (filteredWithdrawals.isNotEmpty)
              Column(
                children: [
                  _buildStatsCardEnhanced(filteredWithdrawals),
                  SizedBox(height: _isWeb ? 20 : 16),
                ],
              ),

            // Lista de solicitações
            Expanded(
              child: isLoadingWithdrawals
                  ? _buildLoadingState()
                  : filteredWithdrawals.isEmpty
                      ? _buildEmptyStateEnhanced(
                          icon: Icons.request_quote_rounded,
                          title: 'Nenhuma solicitação encontrada',
                          subtitle: _selectedFilter == 'TODOS'
                              ? 'Você ainda não fez nenhuma solicitação de saque'
                              : 'Nenhuma solicitação com o estado "${_getStatusLabel(_selectedFilter)}"',
                        )
                      : _buildWithdrawalsListEnhanced(filteredWithdrawals),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSectionEnhanced() {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth > _webCardMaxWidth
        ? _webCardMaxWidth - 48 // Considerando padding
        : screenWidth - 48;

    // Para web, mostramos todos os filtros em linha se houver espaço
    final crossAxisCount = _isWeb && availableWidth > 600
        ? _filterOptions.length
        : 3; // Para mobile e web estreita

    final buttonWidth = availableWidth / crossAxisCount - 8;

    return Container(
      padding: EdgeInsets.all(_isWeb ? 20 : 16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
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
                'FILTROS',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: _isWeb ? 15 : 13,
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
                        horizontal: _isWeb ? 12 : 10,
                        vertical: _isWeb ? 7 : 5),
                    decoration: BoxDecoration(
                      color: _outlineColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.clear_all_rounded,
                            size: _isWeb ? 14 : 12),
                        SizedBox(width: 4),
                        Text(
                          'Limpar',
                          style: TextStyle(
                            fontSize: _isWeb ? 13 : 11,
                            fontWeight: FontWeight.w600,
                            color: _onSurfaceColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: _isWeb ? 16 : 12),
          // Grid de filtros responsivo
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: _isWeb && availableWidth > 600 ? 3.0 : 2.5,
            children: _filterOptions.map((filter) {
              final isActive = _selectedFilter == filter;
              final statusColor = _getStatusColor(filter);

              return _buildFilterButtonResponsive(
                label: filter == 'TODOS' ? 'Todos' : _getStatusLabel(filter),
                isActive: isActive,
                color: statusColor,
                onTap: () => setState(() => _selectedFilter = filter),
                icon: _getStatusIcon(filter),
                width: buttonWidth,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtonResponsive({
    required String label,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
    required IconData icon,
    required double width,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(
            horizontal: _isWeb ? 12 : 8,
            vertical: _isWeb ? 10 : 8,
          ),
          decoration: BoxDecoration(
            color: isActive ? color : color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive ? color : color.withOpacity(0.3),
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : color,
                size: _isWeb ? 16 : 14,
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: _isWeb ? 13 : 11,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCardEnhanced(List<TransactionResponse> withdrawals) {
    final total = _getFilteredTotal();
    final count = withdrawals.length;

    return Container(
      padding: EdgeInsets.all(_isWeb ? 20 : 16),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildStatItemResponsive(
                  icon: Icons.list_alt_rounded,
                  label: 'Solicitações',
                  value: '$count',
                  color: _primaryColor,
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: _outlineColor,
              ),
              Expanded(
                child: _buildStatItemResponsive(
                  icon: Icons.monetization_on_rounded,
                  label: 'Valor Total',
                  value: '${total.toStringAsFixed(2).replaceAll('.', ',')} Kz',
                  color: _successColor,
                ),
              ),
            ],
          ),
          if (_selectedFilter != 'TODOS') ...[
            SizedBox(height: _isWeb ? 16 : 12),
            Container(
              padding: EdgeInsets.all(_isWeb ? 12 : 10),
              decoration: BoxDecoration(
                color: _getStatusColor(_selectedFilter).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(_selectedFilter),
                    color: _getStatusColor(_selectedFilter),
                    size: _isWeb ? 18 : 16,
                  ),
                  SizedBox(width: _isWeb ? 8 : 6),
                  Expanded(
                    child: Text(
                      'Filtro: "${_getStatusLabel(_selectedFilter)}"',
                      style: TextStyle(
                        fontSize: _isWeb ? 14 : 12,
                        color: _onSurfaceColor.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItemResponsive({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: _isWeb ? 18 : 16),
            SizedBox(width: _isWeb ? 6 : 4),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: _isWeb ? 20 : 18,
                  fontWeight: FontWeight.w800,
                  color: _onSurfaceColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: _isWeb ? 6 : 4),
        Text(
          label,
          style: TextStyle(
            fontSize: _isWeb ? 13 : 11,
            color: _onSurfaceColor.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWithdrawalsListEnhanced(List<TransactionResponse> withdrawals) {
    return RefreshIndicator(
      color: _primaryColor,
      backgroundColor: _surfaceColor,
      onRefresh: loadWithdrawalHistory,
      child: ListView.separated(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 8, bottom: 30),
        itemCount: withdrawals.length,
        separatorBuilder: (_, __) => SizedBox(height: _isWeb ? 16 : 12),
        itemBuilder: (context, index) {
          final withdrawal = withdrawals[index];
          final statusColor = _getStatusColor(withdrawal.status);
          final dateTime = _parseDateTime(withdrawal.createdAt);
          final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
          final formattedTime = DateFormat('HH:mm').format(dateTime);
          final amount =
              '${withdrawal.amount.toStringAsFixed(2).replaceAll('.', ',')} Kz';
          final shortId = withdrawal.id?.substring(0, 6).toUpperCase() ?? 'N/A';

          return _buildWithdrawalCardResponsive(
            withdrawal: withdrawal,
            statusColor: statusColor,
            shortId: shortId,
            amount: amount,
            formattedDate: formattedDate,
            formattedTime: formattedTime,
          );
        },
      ),
    );
  }

  Widget _buildWithdrawalCardResponsive({
    required TransactionResponse withdrawal,
    required Color statusColor,
    required String shortId,
    required String amount,
    required String formattedDate,
    required String formattedTime,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _showWithdrawalDetails(withdrawal),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: _outlineColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Cabeçalho do card
                Container(
                  padding: EdgeInsets.all(_isWeb ? 16 : 12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.05),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Badge de status
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: _isWeb ? 12 : 10,
                              vertical: _isWeb ? 7 : 5),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: statusColor.withOpacity(0.3),
                              width: 1,
                            ),
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
                              SizedBox(width: _isWeb ? 8 : 6),
                              Flexible(
                                child: Text(
                                  _getStatusLabel(withdrawal.status),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: _isWeb ? 14 : 12,
                                    color: statusColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        '#$shortId',
                        style: TextStyle(
                          fontSize: _isWeb ? 13 : 11,
                          color: _onSurfaceColor.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),

                // Conteúdo principal
                Padding(
                  padding: EdgeInsets.all(_isWeb ? 16 : 12),
                  child: Row(
                    children: [
                      // Ícone
                      Container(
                        width: _isWeb ? 56 : 48,
                        height: _isWeb ? 56 : 48,
                        decoration: BoxDecoration(
                          gradient: _primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.money_off_csred_rounded,
                          color: Colors.white,
                          size: _isWeb ? 28 : 24,
                        ),
                      ),
                      SizedBox(width: _isWeb ? 16 : 12),

                      // Detalhes
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saque',
                              style: TextStyle(
                                fontSize: _isWeb ? 17 : 15,
                                fontWeight: FontWeight.w800,
                                color: _onSurfaceColor,
                              ),
                            ),
                            SizedBox(height: _isWeb ? 6 : 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: _isWeb ? 14 : 12,
                                  color: _onSurfaceColor.withOpacity(0.5),
                                ),
                                SizedBox(width: _isWeb ? 6 : 4),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    fontSize: _isWeb ? 13 : 12,
                                    color: _onSurfaceColor.withOpacity(0.6),
                                  ),
                                ),
                                SizedBox(width: _isWeb ? 12 : 8),
                                Icon(
                                  Icons.access_time_rounded,
                                  size: _isWeb ? 14 : 12,
                                  color: _onSurfaceColor.withOpacity(0.5),
                                ),
                                SizedBox(width: _isWeb ? 6 : 4),
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                    fontSize: _isWeb ? 13 : 12,
                                    color: _onSurfaceColor.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Valor
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Valor',
                            style: TextStyle(
                              fontSize: _isWeb ? 13 : 11,
                              color: _onSurfaceColor.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: _isWeb ? 6 : 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              amount,
                              style: TextStyle(
                                fontSize: _isWeb ? 20 : 18,
                                fontWeight: FontWeight.w800,
                                color: _primaryColor,
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
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: _isWeb ? 48 : 40,
            height: _isWeb ? 48 : 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: _primaryColor,
            ),
          ),
          SizedBox(height: _isWeb ? 16 : 12),
          Text(
            'Carregando...',
            style: TextStyle(
              fontSize: _isWeb ? 16 : 14,
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
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(_isWeb ? 32 : 24),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _webCardMaxWidth * 0.8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: _isWeb ? 90 : 70,
                  height: _isWeb ? 90 : 70,
                  decoration: BoxDecoration(
                    color: _outlineColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: _onSurfaceColor.withOpacity(0.4),
                    size: _isWeb ? 40 : 36,
                  ),
                ),
                SizedBox(height: _isWeb ? 24 : 20),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: _isWeb ? 18 : 16,
                    fontWeight: FontWeight.w700,
                    color: _onSurfaceColor.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: _isWeb ? 12 : 8),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _isWeb ? 40 : 20),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _isWeb ? 15 : 13,
                      color: _onSurfaceColor.withOpacity(0.5),
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

  Widget _buildEmptyStateEnhanced({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(_isWeb ? 32 : 24),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _webCardMaxWidth * 0.8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: _isWeb ? 100 : 80,
                  height: _isWeb ? 100 : 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _outlineColor.withOpacity(0.1),
                        _outlineColor.withOpacity(0.05),
                    ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: _onSurfaceColor.withOpacity(0.3),
                    size: _isWeb ? 48 : 40,
                  ),
                ),
                SizedBox(height: _isWeb ? 24 : 20),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: _isWeb ? 20 : 18,
                    fontWeight: FontWeight.w800,
                    color: _onSurfaceColor.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: _isWeb ? 16 : 12),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: _isWeb ? 20 : 16,
                      vertical: _isWeb ? 12 : 10),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _isWeb ? 15 : 13,
                      color: _onSurfaceColor.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (_selectedFilter != 'TODOS') ...[
                  SizedBox(height: _isWeb ? 24 : 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _selectedFilter = 'TODOS');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: _isWeb ? 24 : 20,
                          vertical: _isWeb ? 12 : 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Mostrar todas',
                      style: TextStyle(
                          fontSize: _isWeb ? 15 : 14),
                    ),
                  ),
                ],
              ],
            ),
          ),
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
            isDeposit ? 'Depósito' : 'Saque',
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
                            value: 'Saque',
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
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: _isWeb ? 20 : 16,
          color: _onSurfaceColor.withOpacity(0.6),
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
}