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

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(isMobile),

              // Card de Saldo
              _buildBalanceCard(isMobile),

              // TabBar
              _buildTabBar(isMobile),

              // Conteúdo das Tabs
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                  child: TabBarView(
                    controller: _model.tabBarController,
                    children: [
                      _buildHistoricoTab(isMobile),
                      _buildSolicitacoesTab(isMobile),
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

  Widget _buildHeader(bool isMobile) {
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
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 32,
        vertical: isMobile ? 16 : 20,
      ),
      child: Row(
        children: [
          _buildBackButton(isMobile),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'CARTEIRA DIGITAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
          _buildWalletIcon(isMobile),
        ],
      ),
    );
  }

  Widget _buildBackButton(bool isMobile) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => context.safePop(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildWalletIcon(bool isMobile) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.account_balance_wallet_rounded,
        color: Colors.white,
        size: 22,
      ),
    );
  }

  Widget _buildBalanceCard(bool isMobile) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 24 : 32),
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
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Saldo Disponível',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${(userAccountInfo?.availableBalance ?? 0.00).toStringAsFixed(2)} Kz',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 32 : 40,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Conta',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        userAccountInfo?.accountNumber.toString() ?? 'Número não encontrado',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Divider(color: Colors.white.withOpacity(0.1), height: 20),
            //Row(
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //  children: [
            //    _buildInfoItem('Limite Diário', '100.000,00 Kz'),
            //    _buildInfoItem('Última Atualização',
            //        DateFormat('dd/MM/yyyy').format(DateTime.now())),
            //  ],
            //),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 24),
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
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: isMobile ? 14 : 16,
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
            horizontal: isMobile ? 24 : 32,
            vertical: isMobile ? 14 : 16,
          ),
          buttonMargin: EdgeInsets.all(6),
          tabs: [
            Tab(text: 'Histórico'),
            Tab(text: 'Solicitações'),
          ],
          controller: _model.tabBarController,
        ),
      ),
    );
  }

  Widget _buildHistoricoTab(bool isMobile) {
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

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListView.separated(
        itemCount: depositHistory.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: _outlineColor.withOpacity(0.3)),
        itemBuilder: (context, index) {
          final item = depositHistory[index];
          final isDeposit = item['operacao'] == 'Depósito';
          final statusColor = _getStatusColor(item['status']);

          return Material(
            color: Colors.transparent,
            child: InkWell(
              //onTap: () => _showTransactionDetails(item['raw']),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Ícone
                    Container(
                      width: 48,
                      height: 48,
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
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),

                    // Detalhes
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['operacao'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: _onSurfaceColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            item['dataHora'],
                            style: TextStyle(
                              fontSize: 13,
                              color: _onSurfaceColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Montante e Status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item['montante'],
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: _onSurfaceColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                _getStatusLabel(item['status']),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
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
          );
        },
      ),
    );
  }

  Widget _buildSolicitacoesTab(bool isMobile) {
    final filteredWithdrawals = _getFilteredWithdrawals();

    return Column(
      children: [
        // Filtros
        _buildFiltersSection(isMobile),
        SizedBox(height: 20),

        // Estatísticas
        if (filteredWithdrawals.isNotEmpty)
          _buildStatsCard(filteredWithdrawals, isMobile),

        SizedBox(height: 20),

        // Lista
        Expanded(
          child: isLoadingWithdrawals
              ? _buildLoadingState()
              : filteredWithdrawals.isEmpty
                  ? _buildEmptyState(
                      icon: Icons.request_quote_rounded,
                      title: 'Nenhuma solicitação',
                      subtitle: _selectedFilter == 'TODOS'
                          ? 'Você ainda não fez nenhum saque'
                          : 'Nenhuma solicitação com este filtro',
                    )
                  : _buildWithdrawalsList(filteredWithdrawals, isMobile),
        ),
      ],
    );
  }

  Widget _buildFiltersSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(16),
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
          Text(
            'Filtrar por estado',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: _onSurfaceColor,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _filterOptions.map((filter) {
              final isActive = _selectedFilter == filter;
              final statusColor = _getStatusColor(filter);

              return ChoiceChip(
                label: Text(
                  filter == 'TODOS' ? 'Todos' : _getStatusLabel(filter),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : statusColor,
                  ),
                ),
                selected: isActive,
                selectedColor: statusColor,
                backgroundColor: statusColor.withOpacity(0.1),
                side: BorderSide(
                  color: statusColor.withOpacity(0.3),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedFilter = filter);
                  }
                },
                avatar: isActive
                    ? null
                    : Icon(
                        _getStatusIcon(filter),
                        size: 16,
                        color: statusColor,
                      ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(List<TransactionResponse> withdrawals, bool isMobile) {
    final total = _getFilteredTotal();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: _primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.analytics_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumo do Filtro',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${withdrawals.length} solicitações',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Valor Total',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${total.toStringAsFixed(2).replaceAll('.', ',')} Kz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawalsList(
      List<TransactionResponse> withdrawals, bool isMobile) {
    return ListView.separated(
      itemCount: withdrawals.length,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final withdrawal = withdrawals[index];
        final statusColor = _getStatusColor(withdrawal.status);
        final dateTime = _parseDateTime(withdrawal.createdAt);
        final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
        final formattedTime = DateFormat('HH:mm').format(dateTime);
        final amount =
            '${withdrawal.amount.toStringAsFixed(2).replaceAll('.', ',')} Kz';

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => _showWithdrawalDetails(withdrawal),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.all(16),
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
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Ícone de status
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getStatusIcon(withdrawal.status),
                          color: statusColor,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),

                      // Informações principais
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saque #${withdrawal.id?.substring(0, 8) ?? '---'}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: _onSurfaceColor,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '$formattedDate às $formattedTime',
                              style: TextStyle(
                                fontSize: 13,
                                color: _onSurfaceColor.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Valor
                      Text(
                        amount,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: _primaryColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        Text(
                          _getStatusLabel(withdrawal.status),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: _primaryColor,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Carregando...',
            style: TextStyle(
              fontSize: 16,
              color: _onSurfaceColor.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _outlineColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: _onSurfaceColor.withOpacity(0.4),
                size: 40,
              ),
            ),
            SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _onSurfaceColor.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
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
          ),
          SizedBox(width: 12),
          Text(isDeposit ? 'Depósito' : 'Saque'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDetailItem(
              'Valor:', '${transaction.amount.toStringAsFixed(2)} Kz'),
          _buildDetailItem('Data:', formattedDate),
          _buildDetailItem('Estado:', _getStatusLabel(transaction.status)),
          if (transaction.reference != null)
            _buildDetailItem('Referência:', transaction.reference! as String),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('FECHAR'),
        ),
      ],
    );
  }

  AlertDialog _buildWithdrawalDialog(TransactionResponse withdrawal) {
    final dateTime = _parseDateTime(withdrawal.createdAt);
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    final statusColor = _getStatusColor(withdrawal.status);

    // Cores do tema premium
    final Color _primaryColor = Color(0xFFEC8D0D);
    final Color _backgroundColor = Colors.white;
    final Color _surfaceColor = Colors.white;
    final Color _onSurfaceColor = Color(0xFF1E293B);
    final Color _onSurfaceLight = Color(0xFF64748B);
    final Color _borderColor = Color(0xFFE2E8F0);

    // Gradiente premium
    final LinearGradient _primaryGradient = LinearGradient(
      colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return AlertDialog(
      backgroundColor: _backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: _borderColor,
          width: 1.5,
        ),
      ),
      elevation: 0,
      titlePadding: EdgeInsets.all(24),
      title: Container(
        padding: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _borderColor,
              width: 1.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: _primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.currency_exchange_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'DETALHES DO SAQUE',
                style: TextStyle(
                  color: _onSurfaceColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status card premium
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: statusColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: statusColor.withOpacity(0.25),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    _getStatusIcon(withdrawal.status),
                    color: statusColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getStatusLabel(withdrawal.status),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Valor destacado
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _primaryColor.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Valor Solicitado',
                  style: TextStyle(
                    color: _onSurfaceLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${withdrawal.amount.toStringAsFixed(2)} Kz',
                  style: TextStyle(
                    color: _onSurfaceColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Detalhes
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _borderColor,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                _buildDetailItem('Data:', formattedDate),
                SizedBox(height: 12),
                _buildDetailItem('ID:', withdrawal.id ?? '---'),
                if (withdrawal.reference != null) ...[
                  SizedBox(height: 12),
                  _buildDetailItem(
                      'Referência:', withdrawal.reference! as String),
                ],
              ],
            ),
          ),
        ],
      ),
      actionsPadding: EdgeInsets.only(bottom: 24, left: 24, right: 24),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: _primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    'FECHAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _onSurfaceColor.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: _onSurfaceColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
