import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/account_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/responses/account_response.dart';
import 'package:projeto_game_quiz/core/models/responses/transaction_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';
import 'package:projeto_game_quiz/pages/deposit_history/deposit_history_model.dart';
import 'package:projeto_game_quiz/utils.dart';

class DepositHistoryScreenWidget extends StatefulWidget {
  const DepositHistoryScreenWidget({super.key});

  static String routeName = 'DepositHistoryScreen';
  static String routePath = '/DepositHistoryScreen';

  @override
  State<DepositHistoryScreenWidget> createState() =>
      _DepositHistoryScreenWidgetState();
}

class _DepositHistoryScreenWidgetState extends State<DepositHistoryScreenWidget>
    with SingleTickerProviderStateMixin {
  // ===============================
  // 1. CONSTANTES E CONFIGURAÇÕES
  // ===============================
  static const _entityNumber = '11454';

  // Cores do tema premium
  static const _primaryColor = Color(0xFFEC8D0D);
  static const _backgroundColor = Color(0xFFF8FAFC);
  static const _surfaceColor = Colors.white;
  static const _onSurfaceColor = Color(0xFF1E293B);
  static const _outlineColor = Color(0xFFE2E8F0);
  static const _successColor = Color(0xFF10B981);
  static const _warningColor = Color(0xFFF59E0B);
  static const _infoColor = Color(0xFF3B82F6);
  static const _errorColor = Color(0xFFEF4444);

  // Gradientes premium
  static final _primaryGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===============================
  // 2. VARIÁVEIS DE ESTADO
  // ===============================
  late DepositHistoryScreenModel _model;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final AccountService _accountService = AccountService();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Dados do usuário
  AccountResponse? _userAccountInfo;
  UserResponse? _user;

  // Histórico
  List<Map<String, dynamic>> _depositHistory = [];
  List<Map<String, dynamic>> _pendingReferences = [];

  // Estados de loading
  bool _isLoading = true;
  bool _isLoadingPendingReferences = false;
  bool _showPendingReferences = false;

  // ===============================
  // 3. MÉTODOS DE CICLO DE VIDA
  // ===============================
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeModel();
    _loadInitialData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _model.dispose();
    super.dispose();
  }

  // ===============================
  // 4. MÉTODOS DE INICIALIZAÇÃO
  // ===============================
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  void _initializeModel() {
    _model = createModel(context, () => DepositHistoryScreenModel());
  }

  void _loadInitialData() {
    getUserInfoAndAccountInfoAsync(setState, context).then((_) {
      _loadDepositHistory();
    });
  }

  // ===============================
  // 5. LÓGICA DE NEGÓCIO
  // ===============================
  /// Carrega referências pendentes (transações com reference > 0)
  Future<void> _loadPendingReferences() async {
    if (_userAccountInfo?.id == null) {
      print('Conta do usuário não encontrada');
      return;
    }

    setState(() => _isLoadingPendingReferences = true);

    try {
      final result = await _accountService.listTransactionsByStatusAsync(
          _userAccountInfo!.id, 'Pendente');

      if (result['isSuccess'] && mounted) {
        final List<TransactionResponse> pendingTransactions = result['data']; 
 
        final allPendingTransactions = pendingTransactions;  
        setState(() { 
          _pendingReferences =
              allPendingTransactions.map(_mapToReferenceItem).toList();
          _isLoadingPendingReferences = false;
        }); 
      } else { 
        setState(() {
          _pendingReferences = [];
          _isLoadingPendingReferences = false;
        });
      }
    } catch (e) {
      print('Exceção ao carregar referências pendentes: $e');
      setState(() {
        _pendingReferences = [];
        _isLoadingPendingReferences = false;
      });
    }
  }
 
  Map<String, dynamic> _mapToReferenceItem(TransactionResponse tx) {
    final createdAt = _toDateTime(tx.createdAt);
    final expiresAt = createdAt.add(const Duration(days: 1));
    final now = DateTime.now();
    final hoursRemaining = expiresAt.difference(now).inHours; 

    return {
      'id': tx.id,
      'reference': tx.reference?.toString() ?? 'INDISPONÍVEL',
      'amount': tx.amount,
      'currency': 'Kz',
      'createdAt': createdAt,
      'expiresAt': expiresAt,
      'status': tx.status,
      'entity': _entityNumber,
      'hoursRemaining': hoursRemaining,
      'originalTransaction': tx,
      'isExpired': hoursRemaining <= 0,
      'isExpiringSoon': hoursRemaining > 0 && hoursRemaining < 12,
    };
  }
  
  Future<void> _loadDepositHistory() async {
    final userId = _user?.id;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final accountResult =
          await _accountService.getAccountByUserIdAsync(userId);
      if (!accountResult['isSuccess'] || accountResult['data']?.id == null) {
        setState(() => _isLoading = false);
        return;
      }

      final accountId = accountResult['data']!.id;
      final transactionsResult =
          await _accountService.listDepositTransactionsAsync(accountId);

      if (transactionsResult['isSuccess']) {
        final List<TransactionResponse> transactions =
            List<TransactionResponse>.from(transactionsResult['data']);

        setState(() {
          _depositHistory = transactions.map(_mapToHistoryItem).toList();
          _isLoading = false;
        });

        _loadPendingReferences();
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Erro ao carregar histórico: $e');
      setState(() => _isLoading = false);
    }
  }
  Map<String, dynamic> _mapToHistoryItem(TransactionResponse tx) {
    return {
      'operacao': (tx.type == 'credit') ? 'Depósito' : tx.type,
      'montante': CurrencyUtil.formatKwanza(tx.amount),
      'dataHora':
          DateFormat('dd/MM/yyyy HH:mm').format(_toDateTime(tx.createdAt)),
      'status': tx.status,
      'transaction': tx,
    };
  }

  String _calculateTotalDeposits() {
    if (_depositHistory.isEmpty) return '0,00 Kz';

    double total = 0;
    for (var item in _depositHistory) {
      if (item['status'] == 'Realizado') {
        final valueStr =
            item['montante'].replaceAll(' Kz', '').replaceAll(',', '.');
        total += double.tryParse(valueStr) ?? 0;
      }
    }

    return CurrencyUtil.formatKwanza(total);
  }

  DateTime _toDateTime(dynamic value) {
    if (value == null) throw Exception('Data inválida: valor nulo');
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    throw Exception('Data inválida: tipo inesperado');
  }

  void _copyReference(String reference) {
    Clipboard.setData(ClipboardData(text: reference));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Referência copiada com sucesso!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: _successColor,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showReferenceDetails(Map<String, dynamic> reference) {
    showDialog(
      context: context,
      builder: (context) => _referenceDetailsDialog(reference),
    );
  }

  Widget _referenceDetailsDialog(Map<String, dynamic> reference) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: _surfaceColor,
      title: Row(
        children: [
          Icon(Icons.receipt_long_rounded, color: _primaryColor, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Detalhes da Referência',
              style: TextStyle(
                color: _onSurfaceColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400, maxHeight: 500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                icon: Icons.code_rounded,
                label: 'Referência',
                value: reference['reference'],
                color: _primaryColor,
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                icon: Icons.attach_money_rounded,
                label: 'Valor',
                value:
                    '${reference['amount'].toStringAsFixed(2)} ${reference['currency']}',
                color: _successColor,
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                icon: Icons.account_balance_rounded,
                label: 'Entidade',
                value: reference['entity'],
                color: _infoColor,
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                icon: Icons.payment_rounded,
                label: 'Método',
                value: reference['paymentMethod'] ?? 'Multicaixa',
                color: _warningColor,
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                icon: Icons.date_range_rounded,
                label: 'Criado em',
                value: DateFormat('dd/MM/yyyy HH:mm')
                    .format(reference['createdAt']),
                color: _onSurfaceColor.withOpacity(0.7),
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                icon: Icons.timer_rounded,
                label: 'Expira em',
                value: DateFormat('dd/MM/yyyy HH:mm')
                    .format(reference['expiresAt']),
                color: _errorColor.withOpacity(0.8),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _warningColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_rounded, color: _warningColor, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Esta referência ainda não foi paga. Use os dados acima para realizar o pagamento.',
                        style: TextStyle(
                          color: _onSurfaceColor.withOpacity(0.8),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'FECHAR',
            style: TextStyle(
              color: _onSurfaceColor.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {
            _copyReference(reference['reference']);
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copy_rounded, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'COPIAR REFERÊNCIA',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Center(
            child: Icon(icon, color: color, size: 18),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: _onSurfaceColor.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: _onSurfaceColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===============================
  // 8. WIDGETS PRINCIPAIS
  // ===============================
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
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              _buildHeader(),
              _buildToggleSection(),
              Expanded(child: _buildMainContent()),
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
                  _buildBackButton(),
                  SizedBox(width: 12),
                  _buildTitle(),
                ],
              ),
              SizedBox(height: 8),
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
    );
  }

  Widget _buildBackButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Expanded(
      child: Text(
        _showPendingReferences
            ? 'REFERÊNCIAS PENDENTES'
            : 'HISTÓRICO DE DEPÓSITOS',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildToggleSection() {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            _buildToggleButton(
              isActive: !_showPendingReferences,
              icon: Icons.history_rounded,
              label: 'Histórico',
              activeColor: _primaryColor,
              onTap: () {
                if (_showPendingReferences) {
                  setState(() => _showPendingReferences = false);
                }
              },
            ),
            SizedBox(width: 12),
            _buildToggleButton(
              isActive: _showPendingReferences,
              icon: Icons.pending_actions_rounded,
              label: 'Pendentes',
              activeColor: _warningColor,
              onTap: () {
                if (!_showPendingReferences) {
                  setState(() => _showPendingReferences = true);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required bool isActive,
    required IconData icon,
    required String label,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color:
                  isActive ? activeColor.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive ? activeColor.withOpacity(0.3) : _outlineColor,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color:
                      isActive ? activeColor : _onSurfaceColor.withOpacity(0.5),
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive
                        ? activeColor
                        : _onSurfaceColor.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        constraints:
            BoxConstraints(minWidth: screenWidth, maxWidth: screenWidth),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_showPendingReferences) ...[
              _buildTotalDepositsCard(screenWidth),
              SizedBox(height: 24),
            ],
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth - 32),
              child: _showPendingReferences
                  ? _buildPendingReferencesContent()
                  : _buildHistoryContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalDepositsCard(double screenWidth) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: screenWidth - 32),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _primaryColor.withOpacity(0.1),
              _primaryColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
          border: Border.all(color: _outlineColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: _primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
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
                    'Total Depositado',
                    style: TextStyle(
                      color: _onSurfaceColor.withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: screenWidth - 150),
                      child: Text(
                        _calculateTotalDeposits(),
                        style: TextStyle(
                          color: _primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingReferencesContent() {
    if (_pendingReferences.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline_rounded,
        title: 'Nenhuma referência pendente',
        description:
            'Todas as suas referências foram pagas ou não há referências pendentes no momento.',
        iconColor: _successColor,
      );
    }

    return Column(
      children: [
        _buildListHeader(
          title: 'REFERÊNCIAS AGUARDANDO PAGAMENTO',
          count: _pendingReferences.length,
          color: _warningColor,
        ),
        _buildPendingReferencesList(),
        if (_pendingReferences.isNotEmpty) ...[
          SizedBox(height: 20),
          _buildInfoCard(),
        ],
      ],
    );
  }

  Widget _buildHistoryContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_depositHistory.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history_rounded,
        title: 'Nenhum depósito encontrado',
        iconColor: _onSurfaceColor.withOpacity(0.3),
      );
    }

    return Column(
      children: [
        _buildListHeader(
          title: 'TRANSAÇÕES RECENTES',
          count: _depositHistory.length,
          color: _primaryColor,
        ),
        _buildHistoryList(),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: _primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 64,
            ),
            child: Text(
              'Carregando histórico...',
              style: TextStyle(
                color: _onSurfaceColor.withOpacity(0.6),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    String? description,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_backgroundColor, _backgroundColor.withOpacity(0.8)],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: _outlineColor, width: 2),
            ),
            child: Icon(icon, size: 40, color: iconColor),
          ),
          SizedBox(height: 20),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 64,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: _onSurfaceColor.withOpacity(0.7),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (description != null) ...[
            SizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 64,
              ),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: _onSurfaceColor.withOpacity(0.5),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListHeader({
    required String title,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2))
        ],
        border: Border(bottom: BorderSide(color: _outlineColor, width: 1.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: _onSurfaceColor.withOpacity(0.7),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3), width: 1),
                ),
                child: Text(
                  '$count ${count > 1 ? 'itens' : 'item'}',
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingReferencesList() {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: Offset(0, 5))
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _pendingReferences.length,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 1, color: _outlineColor),
        ),
        itemBuilder: (context, index) =>
            _buildReferenceItem(_pendingReferences[index]),
      ),
    );
  }

  Widget _buildReferenceItem(Map<String, dynamic> reference) {
    final screenWidth = MediaQuery.of(context).size.width;
    final hoursRemaining = reference['hoursRemaining'] as int;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: screenWidth - 32),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: _surfaceColor),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _warningColor.withOpacity(0.15),
                    _warningColor.withOpacity(0.05)
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                    color: _warningColor.withOpacity(0.3), width: 1.5),
              ),
              child: Center(
                child: Icon(Icons.pending_actions_rounded,
                    color: _warningColor, size: 18),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ref: ${reference['reference']}',
                    style: TextStyle(
                      color: _onSurfaceColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.attach_money_rounded,
                          color: _successColor, size: 12),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${reference['amount'].toStringAsFixed(2)} ${reference['currency']}',
                          style: TextStyle(
                            color: _successColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_rounded,
                        color:
                            hoursRemaining < 12 ? _errorColor : _warningColor,
                        size: 12,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hoursRemaining > 0
                              ? 'Expira em ${hoursRemaining}h'
                              : 'Expirou',
                          style: TextStyle(
                            color: hoursRemaining < 12
                                ? _errorColor
                                : _warningColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildActionButtons(reference),
                SizedBox(height: 8),
                _buildStatusBadge(
                    reference['status'].toUpperCase(), _warningColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> reference) {
    return Container(
      constraints: BoxConstraints(maxWidth: 100),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          children: [
            _buildActionButton(
              icon: Icons.copy_rounded,
              color: _infoColor,
              onTap: () => _copyReference(reference['reference']),
            ),
            SizedBox(width: 8),
            _buildActionButton(
              icon: Icons.visibility_rounded,
              color: _primaryColor,
              onTap: () => _showReferenceDetails(reference),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      constraints: BoxConstraints(maxWidth: 80),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _infoColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _infoColor.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _infoColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: _infoColor.withOpacity(0.3), width: 1),
            ),
            child: Center(
              child: Icon(Icons.info_rounded, color: _infoColor, size: 20),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Clique no ícone 👁️ para ver detalhes ou 📋 para copiar a referência. Use estes dados para realizar o pagamento.',
              style: TextStyle(
                color: _onSurfaceColor.withOpacity(0.8),
                fontSize: 13,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: Offset(0, 5))
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _depositHistory.length,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 1, color: _outlineColor),
        ),
        itemBuilder: (context, index) =>
            _buildHistoryItem(_depositHistory[index]),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isRealizado = item['status'] == 'Realizado';
    final color = isRealizado ? _successColor : _warningColor;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: screenWidth - 32),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: _surfaceColor),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3), width: 1.5),
              ),
              child: Center(
                child: Icon(
                  isRealizado
                      ? Icons.check_circle_rounded
                      : Icons.pending_actions_rounded,
                  color: color,
                  size: 18,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['operacao'],
                    style: TextStyle(
                      color: _onSurfaceColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          color: _onSurfaceColor.withOpacity(0.4), size: 12),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item['dataHora'],
                          style: TextStyle(
                            color: _onSurfaceColor.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 120),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item['montante'],
                        style: TextStyle(
                          color: _onSurfaceColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  _buildStatusBadge(item['status'].toUpperCase(), color),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  // 9. MÉTODOS EXISTENTES (não alterados)
  // ===============================
  Future<void> getUserAccountInfo(
      void Function(VoidCallback fn) setState) async {
    var result = await _accountService.getAccountByUserIdAsync(_user!.id);
    if (result["isSuccess"]) {
      setState(() {
        _userAccountInfo = result["data"];
      });
    } else {
      Warning00ErrorUtil.showDialogMessageError(context,
          result["error"].detail.message, result["error"].detail.details);
    }
  }

  Future<void> getUserInfoAndAccountInfoAsync(
      void Function(VoidCallback fn) setState, BuildContext context) async {
    await getUserInfo(setState);
    await getUserAccountInfo(setState);
  }

  Future<void> getUserInfo(void Function(VoidCallback fn) setState) async {
    var user = await UserUtil.getUserInfo();
    setState(() {
      _user = user!;
    });
  }
}
