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

  // Breakpoints para responsividade
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 1200;

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
    final isMobile = MediaQuery.of(context).size.width < _mobileBreakpoint;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
      ),
      backgroundColor: _surfaceColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 24 : 32,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 500,
          maxHeight: isMobile ? MediaQuery.of(context).size.height * 0.8 : 600,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 20 : 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.receipt_long_rounded,
                        color: _primaryColor, size: isMobile ? 24 : 28),
                    SizedBox(width: isMobile ? 10 : 12),
                    Expanded(
                      child: Text(
                        'Detalhes da Referência',
                        style: TextStyle(
                          color: _onSurfaceColor,
                          fontSize: isMobile ? 18 : 20,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 20 : 24),
                ..._buildDetailRows(reference, isMobile),
                SizedBox(height: isMobile ? 20 : 24),
                Container(
                  padding: EdgeInsets.all(isMobile ? 12 : 16),
                  decoration: BoxDecoration(
                    color: _warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                    border: Border.all(
                      color: _warningColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_rounded,
                          color: _warningColor, size: isMobile ? 18 : 20),
                      SizedBox(width: isMobile ? 10 : 12),
                      Expanded(
                        child: Text(
                          'Esta referência ainda não foi paga. Use os dados acima para realizar o pagamento.',
                          style: TextStyle(
                            color: _onSurfaceColor.withOpacity(0.8),
                            fontSize: isMobile ? 12 : 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 24),
                _buildDialogActions(isMobile, reference),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDetailRows(Map<String, dynamic> reference, bool isMobile) {
    final rows = [
      _buildDetailRow(
        icon: Icons.code_rounded,
        label: 'Referência',
        value: reference['reference'],
        color: _primaryColor,
        isMobile: isMobile,
      ),
      SizedBox(height: isMobile ? 12 : 16),
      _buildDetailRow(
        icon: Icons.attach_money_rounded,
        label: 'Valor',
        value:
            '${reference['amount'].toStringAsFixed(2)} ${reference['currency']}',
        color: _successColor,
        isMobile: isMobile,
      ),
      SizedBox(height: isMobile ? 12 : 16),
      _buildDetailRow(
        icon: Icons.account_balance_rounded,
        label: 'Entidade',
        value: reference['entity'],
        color: _infoColor,
        isMobile: isMobile,
      ),
      SizedBox(height: isMobile ? 12 : 16),
      _buildDetailRow(
        icon: Icons.date_range_rounded,
        label: 'Criado em',
        value: DateFormat('dd/MM/yyyy HH:mm').format(reference['createdAt']),
        color: _onSurfaceColor.withOpacity(0.7),
        isMobile: isMobile,
      ),
      SizedBox(height: isMobile ? 12 : 16),
      _buildDetailRow(
        icon: Icons.timer_rounded,
        label: 'Expira em',
        value: DateFormat('dd/MM/yyyy HH:mm').format(reference['expiresAt']),
        color: _errorColor.withOpacity(0.8),
        isMobile: isMobile,
      ),
    ];

    return rows;
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isMobile,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: isMobile ? 32 : 36,
          height: isMobile ? 32 : 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Center(
            child: Icon(icon, color: color, size: isMobile ? 16 : 18),
          ),
        ),
        SizedBox(width: isMobile ? 10 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: _onSurfaceColor.withOpacity(0.6),
                  fontSize: isMobile ? 11 : 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isMobile ? 2 : 4),
              Text(
                value,
                style: TextStyle(
                  color: _onSurfaceColor,
                  fontSize: isMobile ? 13 : 15,
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

  Widget _buildDialogActions(bool isMobile, Map<String, dynamic> reference) {
    if (isMobile) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                _copyReference(reference['reference']);
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'FECHAR',
                style: TextStyle(
                  color: _onSurfaceColor.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isMobile = screenWidth < _mobileBreakpoint;
            final isTablet = screenWidth >= _mobileBreakpoint &&
                screenWidth < _tabletBreakpoint;

            return AnimatedBuilder(
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
                  _buildHeader(isMobile),
                  _buildToggleSection(isMobile, isTablet),
                  Expanded(
                      child:
                          _buildMainContent(isMobile, isTablet, screenWidth)),
                ],
              ),
            );
          },
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
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: isMobile ? 12 : 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildBackButton(isMobile),
                  SizedBox(width: isMobile ? 10 : 12),
                  _buildTitle(isMobile),
                ],
              ),
              SizedBox(height: isMobile ? 6 : 8),
              Container(
                height: 2,
                width: 40,
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

  Widget _buildBackButton(bool isMobile) {
    return Container(
      width: isMobile ? 36 : 40,
      height: isMobile ? 36 : 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: isMobile ? 18 : 20,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(bool isMobile) {
    return Expanded(
      child: Text(
        _showPendingReferences
            ? 'REFERÊNCIAS PENDENTES'
            : 'HISTÓRICO DE DEPÓSITOS',
        style: TextStyle(
          color: Colors.white,
          fontSize: isMobile ? 16 : 18,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildToggleSection(bool isMobile, bool isTablet) {
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
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 20, // Reduzido de 12 para 16 no mobile
          vertical: isMobile ? 8 : 10, // Reduzido verticalmente
        ),
        child: Row(
          children: [
            _buildToggleButton(
              isActive: !_showPendingReferences,
              icon: Icons.history_rounded,
              label: 'Histórico',
              activeColor: _primaryColor,
              isMobile: isMobile,
              onTap: () {
                if (_showPendingReferences) {
                  setState(() => _showPendingReferences = false);
                }
              },
            ),
            SizedBox(width: isMobile ? 12 : 16), // Espaço entre botões
            _buildToggleButton(
              isActive: _showPendingReferences,
              icon: Icons.pending_actions_rounded,
              label: 'Pendentes',
              activeColor: _warningColor,
              isMobile: isMobile,
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
    required bool isMobile,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10), // Border radius fixo
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 10, // Reduzido verticalmente
              horizontal: 8, // Reduzido horizontalmente
            ),
            decoration: BoxDecoration(
              color:
                  isActive ? activeColor.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
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
                  size: isMobile ? 16 : 18,
                ),
                SizedBox(width: isMobile ? 6 : 8),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive
                          ? activeColor
                          : _onSurfaceColor.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      fontSize: isMobile ? 13 : 14,
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
    );
  }

  Widget _buildMainContent(bool isMobile, bool isTablet, double screenWidth) {
    final horizontalPadding = isMobile ? 12.0 : 16.0;
    final maxContentWidth =
        isTablet ? 800.0 : (isMobile ? double.infinity : 1200.0);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(horizontalPadding),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_showPendingReferences) ...[
                  _buildTotalDepositsCard(isMobile, isTablet),
                  SizedBox(height: isMobile ? 16 : 24),
                ],
                _showPendingReferences
                    ? _buildPendingReferencesContent(isMobile, isTablet)
                    : _buildHistoryContent(isMobile, isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalDepositsCard(bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity, // Garante que ocupe toda a largura disponível
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _primaryColor.withOpacity(0.1),
            _primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
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
            width: isMobile ? 44 : 50,
            height: isMobile ? 44 : 50,
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
              size: isMobile ? 20 : 24,
            ),
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Depositado',
                  style: TextStyle(
                    color: _onSurfaceColor.withOpacity(0.8),
                    fontSize: isMobile ? 12 : 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Text(
                  _calculateTotalDeposits(),
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingReferencesContent(bool isMobile, bool isTablet) {
    if (_isLoadingPendingReferences) {
      return _buildLoadingState(isMobile);
    }

    if (_pendingReferences.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline_rounded,
        title: 'Nenhuma referência pendente',
        description:
            'Todas as suas referências foram pagas ou não há referências pendentes no momento.',
        iconColor: _successColor,
        isMobile: isMobile,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // Alterado para stretch
      children: [
        _buildListHeader(
          title: 'REFERÊNCIAS AGUARDANDO PAGAMENTO',
          count: _pendingReferences.length,
          color: _warningColor,
          isMobile: isMobile,
        ),
        _buildPendingReferencesList(isMobile, isTablet),
        if (_pendingReferences.isNotEmpty) ...[
          SizedBox(height: isMobile ? 16 : 20),
          _buildInfoCard(isMobile),
        ],
      ],
    );
  }

  Widget _buildHistoryContent(bool isMobile, bool isTablet) {
    if (_isLoading) {
      return _buildLoadingState(isMobile);
    }

    if (_depositHistory.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history_rounded,
        title: 'Nenhum depósito encontrado',
        iconColor: _onSurfaceColor.withOpacity(0.3),
        isMobile: isMobile,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // Alterado para stretch
      children: [
        _buildListHeader(
          title: 'TRANSAÇÕES RECENTES',
          count: _depositHistory.length,
          color: _primaryColor,
          isMobile: isMobile,
        ),
        _buildHistoryList(isMobile, isTablet),
      ],
    );
  }

  Widget _buildLoadingState(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isMobile ? 50 : 60,
            height: isMobile ? 50 : 60,
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
                width: isMobile ? 24 : 30,
                height: isMobile ? 24 : 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          Text(
            'Carregando histórico...',
            style: TextStyle(
              color: _onSurfaceColor.withOpacity(0.6),
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isMobile ? 60 : 80,
            height: isMobile ? 60 : 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_backgroundColor, _backgroundColor.withOpacity(0.8)],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: _outlineColor, width: 2),
            ),
            child: Icon(icon, size: isMobile ? 32 : 40, color: iconColor),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              color: _onSurfaceColor.withOpacity(0.7),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (description != null) ...[
            SizedBox(height: isMobile ? 6 : 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 32),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
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
    required bool isMobile,
  }) {
    return Container(
      width: double.infinity, // Ocupa toda a largura disponível
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isMobile ? 12 : 16),
          topRight: Radius.circular(isMobile ? 12 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
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
          SizedBox(width: isMobile ? 8 : 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: _onSurfaceColor.withOpacity(0.7),
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 6 : 8,
              vertical: isMobile ? 3 : 4,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Text(
              '$count ${count > 1 ? 'itens' : 'item'}',
              style: TextStyle(
                color: color,
                fontSize: isMobile ? 10 : 11,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingReferencesList(bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity, // Ocupa toda a largura disponível
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(isMobile ? 12 : 16),
          bottomRight: Radius.circular(isMobile ? 12 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _pendingReferences.length,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),
          child: Divider(height: 1, color: _outlineColor),
        ),
        itemBuilder: (context, index) =>
            _buildReferenceItem(_pendingReferences[index], isMobile),
      ),
    );
  }

  Widget _buildReferenceItem(Map<String, dynamic> reference, bool isMobile) {
    final hoursRemaining = reference['hoursRemaining'] as int;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(color: _surfaceColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isMobile ? 36 : 40,
            height: isMobile ? 36 : 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _warningColor.withOpacity(0.15),
                  _warningColor.withOpacity(0.05),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: _warningColor.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.pending_actions_rounded,
                color: _warningColor,
                size: isMobile ? 16 : 18,
              ),
            ),
          ),
          SizedBox(width: isMobile ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ref: ${reference['reference']}',
                  style: TextStyle(
                    color: _onSurfaceColor,
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money_rounded,
                      color: _successColor,
                      size: isMobile ? 11 : 12,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${reference['amount'].toStringAsFixed(2)} ${reference['currency']}',
                        style: TextStyle(
                          color: _successColor,
                          fontSize: isMobile ? 12 : 13,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Row(
                  children: [
                    Icon(
                      Icons.timer_rounded,
                      color: hoursRemaining < 12 ? _errorColor : _warningColor,
                      size: isMobile ? 11 : 12,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        hoursRemaining > 0
                            ? 'Expira em ${hoursRemaining}h'
                            : 'Expirou',
                        style: TextStyle(
                          color:
                              hoursRemaining < 12 ? _errorColor : _warningColor,
                          fontSize: isMobile ? 10 : 11,
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
              _buildActionButtons(reference, isMobile),
              SizedBox(height: isMobile ? 6 : 8),
              _buildStatusBadge(
                reference['status'].toUpperCase(),
                _warningColor,
                isMobile: isMobile,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> reference, bool isMobile) {
    return Row(
      children: [
        _buildActionButton(
          icon: Icons.copy_rounded,
          color: _infoColor,
          isMobile: isMobile,
          onTap: () => _copyReference(reference['reference']),
        ),
        SizedBox(width: isMobile ? 6 : 8),
        _buildActionButton(
          icon: Icons.visibility_rounded,
          color: _primaryColor,
          isMobile: isMobile,
          onTap: () => _showReferenceDetails(reference),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required bool isMobile,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(isMobile ? 5 : 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Icon(icon, color: color, size: isMobile ? 14 : 16),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color,
      {required bool isMobile}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 6 : 8,
        vertical: isMobile ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: isMobile ? 9 : 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildInfoCard(bool isMobile) {
    return Container(
      width: double.infinity, // Ocupa toda a largura disponível
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: _infoColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        border: Border.all(color: _infoColor.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 36 : 40,
            height: isMobile ? 36 : 40,
            decoration: BoxDecoration(
              color: _infoColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: _infoColor.withOpacity(0.3), width: 1),
            ),
            child: Center(
              child: Icon(
                Icons.info_rounded,
                color: _infoColor,
                size: isMobile ? 18 : 20,
              ),
            ),
          ),
          SizedBox(width: isMobile ? 10 : 12),
          Expanded(
            child: Text(
              'Clique no ícone 👁️ para ver detalhes ou 📋 para copiar a referência. Use estes dados para realizar o pagamento.',
              style: TextStyle(
                color: _onSurfaceColor.withOpacity(0.8),
                fontSize: isMobile ? 12 : 13,
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

  Widget _buildHistoryList(bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity, // Ocupa toda a largura disponível
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(isMobile ? 12 : 16),
          bottomRight: Radius.circular(isMobile ? 12 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _depositHistory.length,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),
          child: Divider(height: 1, color: _outlineColor),
        ),
        itemBuilder: (context, index) =>
            _buildHistoryItem(_depositHistory[index], isMobile),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item, bool isMobile) {
    final isRealizado = item['status'] == 'Realizado';
    final color = isRealizado ? _successColor : _warningColor;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(color: _surfaceColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isMobile ? 36 : 40,
            height: isMobile ? 36 : 40,
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
                size: isMobile ? 16 : 18,
              ),
            ),
          ),
          SizedBox(width: isMobile ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['operacao'],
                  style: TextStyle(
                    color: _onSurfaceColor,
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: _onSurfaceColor.withOpacity(0.4),
                      size: isMobile ? 11 : 12,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item['dataHora'],
                        style: TextStyle(
                          color: _onSurfaceColor.withOpacity(0.6),
                          fontSize: isMobile ? 10 : 11,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item['montante'],
                style: TextStyle(
                  color: _onSurfaceColor,
                  fontSize: isMobile ? 13 : 15,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isMobile ? 4 : 6),
              _buildStatusBadge(
                item['status'].toUpperCase(),
                color,
                isMobile: isMobile,
              ),
            ],
          ),
        ],
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
