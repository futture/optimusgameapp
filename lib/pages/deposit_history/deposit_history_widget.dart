import 'package:flutter/material.dart';
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

class _DepositHistoryScreenWidgetState
    extends State<DepositHistoryScreenWidget> {
  late DepositHistoryScreenModel _model;
  AccountResponse? userAccountInfo;
  UserResponse? user;
  List<Map<String, dynamic>> depositHistory = [];
  final AccountService accountService = AccountService();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DepositHistoryScreenModel());
    getUserInfoAndAccountInfoAsync(setState, context).then((_) {
      loadDepositHistory();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[50]!,
              Colors.grey[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar personalizada
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFEC8D0D)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Histórico de Depósitos',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      if (depositHistory.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEC8D0D).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${depositHistory.length}',
                            style: const TextStyle(
                              color: Color(0xFFEC8D0D),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Corpo principal
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      // Card de resumo premium
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFEC8D0D).withOpacity(0.1),
                              const Color(0xFFEC8D0D).withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFEC8D0D).withOpacity(0.2),
                                    const Color(0xFFEC8D0D).withOpacity(0.1),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Color(0xFFEC8D0D),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Depositado',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _calculateTotalDeposits(),
                                  style: const TextStyle(
                                    color: Color(0xFFEC8D0D),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Lista de transações
                      Expanded(
                        child: _buildHistoryContent(),
                      ),
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

  Widget _buildHistoryContent() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFFEC8D0D)),
            const SizedBox(height: 16),
            Text(
              'Carregando histórico...',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    if (depositHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_rounded,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum depósito encontrado',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Seus depósitos aparecerão aqui',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Cabeçalho da lista
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            children: [
              Text(
                'TRANSAÇÕES RECENTES',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        // Lista de itens
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: depositHistory.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[200],
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final item = depositHistory[index];
                final isRealizado = item['status'] == 'Realizado';

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFEC8D0D).withOpacity(0.15),
                              const Color(0xFFEC8D0D).withOpacity(0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isRealizado
                              ? Icons.check_circle_rounded
                              : Icons.pending_rounded,
                          color: isRealizado
                              ? Colors.green[600]
                              : Colors.orange[600],
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['operacao'],
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['dataHora'],
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item['montante'],
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isRealizado
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item['status'],
                              style: TextStyle(
                                color: isRealizado
                                    ? Colors.green[800]
                                    : Colors.orange[800],
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _calculateTotalDeposits() {
    if (depositHistory.isEmpty) return '0,00 Kz';
    
    double total = 0;
    for (var item in depositHistory) {
      if (item['status'] == 'Realizado') {
        final valueStr = item['montante'].replaceAll(' Kz', '').replaceAll(',', '.');
        total += double.tryParse(valueStr) ?? 0;
      }
    }
    
     return CurrencyUtil.formatKwanza(total);
  }

  Future<void> getUserAccountInfo(void Function(VoidCallback fn) setState) async {
    var result = await accountService.getAccountByUserIdAsync(user!.id);
    if (result["isSuccess"]) {
      setState(() {
        userAccountInfo = result["data"];
      });
    } else {
      Warning00ErrorUtil.showDialogMessageError(
          context,
          result["error"].detail.message,
          result["error"].detail.details);
    }
  }

  Future<void> getUserInfoAndAccountInfoAsync(
      void Function(VoidCallback fn) setState, BuildContext context) async {
    await getUserInfo(setState);
    await getUserAccountInfo(setState);
  }

  Future<void> getUserInfo(void Function(VoidCallback fn) setState) async {
    var _user = await UserUtil.getUserInfo();
    setState(() {
      user = _user!;
    });
  }

  DateTime toDateTime(dynamic value) {
    if (value == null) throw Exception('Data inválida: valor nulo');
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    throw Exception('Data inválida: tipo inesperado');
  }

  Future<void> loadDepositHistory() async {
    final userId = user?.id;

    if (userId == null) {
      setState(() => isLoading = false);
      return;
    }

    final accountResult = await accountService.getAccountByUserIdAsync(userId);
    if (accountResult['isSuccess']) {
      final accountId = accountResult['data']?.id;

      if (accountId != null) {
        final transactionsResult =
            await accountService.listDepositTransactionsAsync(accountId);

        if (transactionsResult['isSuccess']) {
          final List<TransactionResponse> transactions =
              List<TransactionResponse>.from(transactionsResult['data']);

          setState(() {
            depositHistory = transactions.map((tx) {
              return {
                'operacao': (tx.type == 'credit') ? 'Depósito' : tx.type,
                'montante':
                    '${double.tryParse(tx.amount.toString())?.toStringAsFixed(2).replaceAll('.', ',') ?? '0,00'} Kz',
                'dataHora': DateFormat('dd/MM/yyyy HH:mm')
                    .format(toDateTime(tx.createdAt)),
                'status': tx.status,
              };
            }).toList();
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
    }
  }
}