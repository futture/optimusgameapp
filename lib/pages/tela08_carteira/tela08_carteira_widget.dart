import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/account_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/responses/account_response.dart';
import 'package:projeto_game_quiz/core/models/responses/transaction_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  final AccountService accountService = AccountService();
  bool isLoading = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Cores do tema premium alinhadas com sua app
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);
  final Color _successColor = Color(0xFF10B981);
  final Color _errorColor = Color(0xFFEF4444);

  // Gradientes premium
  final LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela08CarteiraModel());
    
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if ((_model.textController1.text.isEmpty ||
              _model.textController1.text == '') ||
          (_model.textController2.text.isEmpty ||
              _model.textController2.text == '')) {
        await showDialog(
          context: context,
          builder: (dialogContext) {
            return Dialog(
              elevation: 0,
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              alignment: AlignmentDirectional(0.0, 0.0)
                  .resolve(Directionality.of(context)),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(dialogContext).unfocus();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Warning00CampoVazioWidget(titulo: "", detalhe: ""),
              ),
            );
          },
        );
      }
    });

    getUserInfoAndAccountInfoAsync(setState, context).then((_) {
      loadDepositHistory();
    });
    
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
    
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

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _backgroundColor,
        body: SafeArea(
          top: true,
          child: Column(
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 24,
                    vertical: isMobile ? 12 : 16,
                  ),
                  child: Row(
                    children: [
                      // Botão Voltar Premium
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            context.safePop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                            size: isMobile ? 18 : 20,
                          ),
                          splashRadius: 20,
                          padding: EdgeInsets.all(isMobile ? 8 : 12),
                        ),
                      ),
                      SizedBox(width: isMobile ? 12 : 16),
                      Expanded(
                        child: Text(
                          'CARTEIRA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 18 : 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      // Ícone de carteira
                      Container(
                        width: isMobile ? 40 : 44,
                        height: isMobile ? 40 : 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                          size: isMobile ? 20 : 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Card de Saldo Premium
              Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 20),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isMobile ? 20 : 24),
                  decoration: BoxDecoration(
                    gradient: _primaryGradient,
                    borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: isMobile ? 40 : 44,
                            height: isMobile ? 40 : 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Colors.white,
                              size: isMobile ? 20 : 22,
                            ),
                          ),
                          SizedBox(width: isMobile ? 12 : 16),
                          Expanded(
                            child: Text(
                              'Sua Carteira Digital',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 15 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 16 : 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Carteira Nº',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: isMobile ? 13 : 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                userAccountInfo?.accountNumber.toString() ?? 'Não Informado',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 15 : 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Saldo Disponível',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: isMobile ? 13 : 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${(userAccountInfo?.availableBalance ?? 0.00).toStringAsFixed(2)} Kz',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 18 : 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // TabBar Premium
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: FlutterFlowButtonTabBar(
                    useToggleButtonStyle: true,
                    labelStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.0,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.0,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: _onSurfaceColor.withOpacity(0.6),
                    backgroundColor: _primaryColor,
                    unselectedBackgroundColor: _surfaceColor,
                    borderColor: _primaryColor,
                    unselectedBorderColor: _outlineColor,
                    borderWidth: 2.0,
                    borderRadius: isMobile ? 10 : 12,
                    elevation: 0.0,
                    labelPadding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 20,
                      vertical: isMobile ? 10 : 12,
                    ),
                    buttonMargin: EdgeInsets.all(4.0),
                    tabs: [
                      Tab(
                        text: 'Histórico',
                      ),
                      Tab(
                        text: 'Transferir Saldo',
                      ),
                    ],
                    controller: _model.tabBarController,
                    onTap: (i) async {
                      [() async {}, () async {}][i]();
                    },
                  ),
                ),
              ),

              SizedBox(height: isMobile ? 12 : 16),

              // Conteúdo das Tabs
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 20),
                  child: TabBarView(
                    controller: _model.tabBarController,
                    children: [
                      // Tab 1: Histórico
                      _buildHistoricoTab(isMobile),
                      // Tab 2: Transferir Saldo
                      _buildTransferirTab(isMobile),
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

  Widget _buildHistoricoTab(bool isMobile) {
    if (isMobile) {
      return _buildMobileHistorico();
    } else {
      return _buildDesktopHistorico();
    }
  }

  Widget _buildMobileHistorico() {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: depositHistory.isEmpty
          ? Center(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _outlineColor.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.history_rounded,
                        color: _onSurfaceColor.withOpacity(0.4),
                        size: 24,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nenhum Histórico',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _onSurfaceColor.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Suas transações aparecerão aqui',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: _onSurfaceColor.withOpacity(0.4),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              itemCount: depositHistory.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: _outlineColor,
              ),
              itemBuilder: (context, index) {
                final item = depositHistory[index];
                final isRealizado = item['status'] == 'Realizado';
                final isDeposito = item['operacao'] == 'Depósito';

                return Container(
                  color: index % 2 == 0 ? _surfaceColor : _backgroundColor,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Linha 1: Operação e Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isDeposito
                                      ? _successColor.withOpacity(0.1)
                                      : _primaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isDeposito
                                      ? Icons.arrow_downward_rounded
                                      : Icons.arrow_upward_rounded,
                                  color: isDeposito ? _successColor : _primaryColor,
                                  size: 16,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                item['operacao'],
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: _onSurfaceColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: isRealizado
                                  ? _successColor.withOpacity(0.1)
                                  : _errorColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isRealizado
                                    ? _successColor.withOpacity(0.3)
                                    : _errorColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              item['status'],
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: isRealizado ? _successColor : _errorColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      // Linha 2: Montante e Data
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Montante',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: _onSurfaceColor.withOpacity(0.6),
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                item['montante'],
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: _onSurfaceColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Data',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: _onSurfaceColor.withOpacity(0.6),
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                item['dataHora'],
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: _onSurfaceColor.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildDesktopHistorico() {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cabeçalho da Tabela
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Operação',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: _onSurfaceColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Montante',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: _onSurfaceColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Data e Hora',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: _onSurfaceColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Status',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: _onSurfaceColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: _outlineColor),

          // Lista de Histórico
          Expanded(
            child: depositHistory.isEmpty
                ? Center(
                    child: Container(
                      padding: EdgeInsets.all(32),
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
                              Icons.history_rounded,
                              color: _onSurfaceColor.withOpacity(0.4),
                              size: 32,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Nenhum Histórico Encontrado',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _onSurfaceColor.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Suas transações aparecerão aqui',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: _onSurfaceColor.withOpacity(0.4),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: depositHistory.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      thickness: 1,
                      color: _outlineColor,
                    ),
                    itemBuilder: (context, index) {
                      final item = depositHistory[index];
                      final isRealizado = item['status'] == 'Realizado';

                      return Container(
                        color: index % 2 == 0 ? _surfaceColor : _backgroundColor,
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: _primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      item['operacao'] == 'Depósito' 
                                          ? Icons.arrow_downward_rounded 
                                          : Icons.arrow_upward_rounded,
                                      color: _primaryColor,
                                      size: 16,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item['operacao'],
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: _onSurfaceColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                item['montante'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: _onSurfaceColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                item['dataHora'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: _onSurfaceColor.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 8.0),
                                decoration: BoxDecoration(
                                  color: isRealizado
                                      ? _successColor.withOpacity(0.1)
                                      : _errorColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isRealizado
                                        ? _successColor.withOpacity(0.3)
                                        : _errorColor.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  item['status'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: isRealizado ? _successColor : _errorColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferirTab(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 20 : 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isMobile ? 80 : 120,
                height: isMobile ? 80 : 120,
                decoration: BoxDecoration(
                  color: _outlineColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.swap_horiz_rounded,
                  color: _onSurfaceColor.withOpacity(0.4),
                  size: isMobile ? 32 : 48,
                ),
              ),
              SizedBox(height: isMobile ? 16 : 24),
              Text(
                'Funcionalidade de Transferência',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  color: _onSurfaceColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 8 : 12),
              Text(
                'Em breve você poderá transferir seu saldo para outras contas',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isMobile ? 13 : 14,
                  color: _onSurfaceColor.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MÉTODOS ORIGINAIS PRESERVADOS - 100% FUNCIONAIS
  Future<void> getUserAccountInfo(void Function(VoidCallback fn) setState) async {
    var result = await accountService.getAccountByUserIdAsync(user!.id);
    if (result["isSuccess"]) {
      setState(() {
        userAccountInfo = result["data"];
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
                'operacao': (tx.type == 'credit') ? 'Depósito' : (tx.type),
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