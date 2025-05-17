// imports...
import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/components/warnings/warning04_reducao_de_saldo/warning04_reducao_de_saldo_widget.dart';
import 'package:projeto_game_quiz/core/api/services/fcm_token_service.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';
import 'package:projeto_game_quiz/dialogs/common_dialog_widget.dart';
import 'package:projeto_game_quiz/utils.dart';
import '/components/moda_listade_sala_widget.dart';
import '/components/moda_menu_pagian_inicial_widget.dart';
import '/components/modals_saque_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tela03_principal_model.dart';

export 'tela03_principal_model.dart';

class Tela03PrincipalWidget extends StatefulWidget {
  const Tela03PrincipalWidget({super.key});

  static String routeName = 'Tela03Principal';
  static String routePath = '/tela03Principal';

  @override
  State<Tela03PrincipalWidget> createState() => _Tela03PrincipalWidgetState();
}

class _Tela03PrincipalWidgetState extends State<Tela03PrincipalWidget> {
  late Tela03PrincipalModel _model;
  final matchService = MatchService();
  bool _isLoadingMatchDetails = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FcmTokenService _fcmTokenService = FcmTokenService();

  @override
  void initState() {
    super.initState();
    _fcmTokenService.initFirebaseMessaging(context);

    _model = createModel(context, () => Tela03PrincipalModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
    _model.getUserInfoAndAccountInfoAsync(setState, context);
    _model.loadMatches(setState);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: FlutterFlowIconButton(
                borderRadius: 8.0,
                buttonSize: 45.0,
                fillColor: FlutterFlowTheme.of(context).primaryBackground,
                icon: FaIcon(
                  FontAwesomeIcons.bars,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: _showMenuModal,
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
          ),
          body: Center(
            child: Container( // Adicionado Container com maxWidth
              constraints: BoxConstraints(
                maxWidth: isWeb ? 1000 : double.infinity,
              ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildUserProfileCard(),
                      const SizedBox(height: 20),
                      _buildGameRoomButton(),
                      const SizedBox(height: 20),
                      _buildSuperLeagueHeader(),
                      const SizedBox(height: 16),
                      if (_model.isLoadingMatches)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: CircularProgressIndicator(),
                        )
                      else if (_model.matchList.isEmpty)
                        _buildEmptyMatchesState()
                      else
                        ..._model.matchList.map((match) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _buildMatchCard(match),
                            )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> _refreshData() async {
    await _model.getUserInfoAndAccountInfoAsync(setState, context);
    await _model.loadMatches(setState);
  }

  void _showMenuModal() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const ModaMenuPagianInicialWidget(isMainScreen: true),
        ),
      ),
    );
    safeSetState(() {});
  }

  Widget _buildUserProfileCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.pushNamed(
                    Tela04PerfilWidget.routeName,
                    extra: <String, dynamic>{
                      kTransitionInfoKey: const TransitionInfo(
                        hasTransition: true,
                        transitionType: PageTransitionType.rightToLeft,
                      ),
                    },
                  ),
                  child: CircleAvatar(
                    radius: 35.0,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1507679799987-c73779587ccf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxwcm98ZW58MHx8fHwxNzQzNTg0NTYxfDA&ixlib=rb-4.0.3&q=80&w=1080',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _model.user?.name ?? "Carregando...",
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.0,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _model.userAccountInfo != null
                            ? 'ID: ${_model.userAccountInfo!.accountNumber}'
                            : "Carregando...",
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontFamily: 'Inter',
                              fontSize: 13.0,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'SALDO: ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontFamily: 'Inter',
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextSpan(
                        text: _model.userAccountInfo != null
                            ? CurrencyUtil.formatKwanza(
                                    _model.userAccountInfo!.balance)
                                .toString()
                            : "Carregando...",
                        style: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontFamily: 'Inter Tight',
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                      // ,
                      // TextSpan(
                      //   text: ' AOA',
                      //   style: FlutterFlowTheme.of(context).bodyMedium.override(
                      //         color: Colors.black,
                      //         fontFamily: 'Inter',
                      //         fontSize: 18.0,
                      //         letterSpacing: 0.0,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.file_download_outlined,
                  label: 'DEPOSITAR',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Tela10DepositoListaWidget(),
                    ),
                  ),
                ),
                _buildActionButton(
                  icon: Icons.file_upload_outlined,
                  label: 'SACAR',
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      useSafeArea: true,
                      context: context,
                      builder: (context) => GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: const ModalsSaqueWidget(),
                        ),
                      ),
                    );
                    safeSetState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: FFButtonWidget(
          onPressed: onPressed,
          text: label,
          icon: Icon(icon, size: 20.0),
          options: FFButtonOptions(
            height: 45.0,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            iconPadding: const EdgeInsets.only(right: 8.0),
            color: const Color(0xFFEC8D0D),
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: 'Inter Tight',
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                ),
            elevation: 2.0,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _buildGameRoomButton() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clique para escolher sala de jogo',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 12),
            FFButtonWidget(
              onPressed: () async {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  enableDrag: false,
                  context: context,
                  builder: (context) => GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: const ModaListadeSalaWidget(),
                    ),
                  ),
                );
                safeSetState(() {});
              },
              text: 'PARTIDAS',
              icon: const FaIcon(FontAwesomeIcons.gamepad, size: 20.0),
              options: FFButtonOptions(
                width: double.infinity,
                height: 50.0,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                color: const Color(0xFF00B80E),
                textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter Tight',
                      color: Colors.white,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
                elevation: 2.0,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuperLeagueHeader() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'SUPER LIGA',
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Inter Tight',
                                fontSize: 20.0,
                                letterSpacing: 0.0,
                              ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.bolt,
                      color: Color(0xFFD2A739),
                      size: 24.0,
                    ),
                  ],
                ),
                if (_model.nextMatch != null)
                  _buildCountdownTimer()
                else
                  _buildPlaceholderTimer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Habilita-se a ganhar grandes prêmios, participando nas partidas abaixo. '
              'Basta clicar na partida para se inscrever.',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, size: 18, color: Colors.orange),
          const SizedBox(width: 4),
          Text(
            _formatCountdown(_model.timerMilliseconds),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: 18, color: Colors.grey),
          SizedBox(width: 4),
          Text(
            "N/A",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMatchesState() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.videogame_asset_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma partida disponível no momento',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            FFButtonWidget(
              onPressed: () async {
                await _model.loadMatches(setState);
              },
              text: 'Recarregar',
              icon: const Icon(Icons.refresh, size: 20),
              options: FFButtonOptions(
                width: 150,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: FlutterFlowTheme.of(context).secondaryBackground,
                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      letterSpacing: 0.0,
                    ),
                elevation: 1,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard(MatchResponse match) {
    final isRegistered = match.isUserRegistered ?? false;

    return InkWell(
      onTap: () async {
        if (_isLoadingMatchDetails) return;

        setState(() => _isLoadingMatchDetails = true);

        try {
          await _model.getUsersByMatchId(setState, match.id);
          CommonDialogWidget.showMatchParticipantsDialog(
              context,
              List.empty(),
              null,
              match,
              _model.users,
              _model.user,
              buildMatchButton(
                isRegistered: isRegistered,
                match: match,
                onJoin: (m) => _handleMatchTap(m as MatchResponse),
                onLeave: (m) => _leaveMatch(m as MatchResponse),
                context: context,
              ),
              isPlaySound: false,
              isProgressBar: false);
        } catch (e) {
          Warning00ErrorUtil.showDialogMessageError(
            context,
            "Erro ao carregar partida",
            "Ocorreu um erro ao carregar os detalhes da partida.",
          );
        } finally {
          setState(() => _isLoadingMatchDetails = false);
        }
        //_handleMatchTap(match);
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: isRegistered ? const Color(0xFF4CAF50) : const Color(0xFFEC8D0D),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.sketch, size: 20.0),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Super Partida das ${formatHour(match.matchStartDate)}',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Inter Tight',
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '${match.room?.roomConfiguration?.minimumAmountToPlay ?? 0}KZ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMatchStat(
                    icon: Icons.people_alt_rounded,
                    value: '${match.matchPlayers?.length ?? 0} Inscritos',
                  ),
                  _buildMatchStat(
                    icon: Icons.schedule,
                    value: formatHour(match.matchStartDate),
                  ),
                  if (isRegistered)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'INSCRITO',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (_isLoadingMatchDetails)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchStat({required IconData icon, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Future<void> _handleMatchTap(MatchResponse match) async {
    await _model.checkPlayerAlreadyRegisteredMatchAsync(setState, match.id);

    if (!_model.isNotRegisteredMatch) {
      Navigator.pop(context);
      Warning00ErrorUtil.showDialogMessageError(
        context,
        "Falha ao se increver na partida",
        "Jogador já inscrito na partida.",
      );
    } else {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(24),
            child: Warning04ReducaoDeSaldoWidget(
              subscribe: true,
              matchInfo: match,
              onConfirmed: () => Navigator.of(context).pop(true),
            ),
          );
        },
      );

      if (result == true) {
        Navigator.pop(context);

        setState(() {
          _model.getUserInfoAndAccountInfoAsync(setState, context);
          _model.loadMatches(setState);
        });
      }
    }
  }

  String formatHour(DateTime? dateTime) {
    if (dateTime == null) return '';
    final hour = dateTime.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    return '${formattedHour}h$period';
  }

  String _formatCountdown(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);

    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  Future<void> _leaveMatch(MatchResponse match) async {
    try {
      Navigator.pop(context);
      await _model.leaveMatchAsync(match.id);
      setState(() {
        _model.getUserInfoAndAccountInfoAsync(setState, context);
        _model.loadMatches(setState);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você saiu da partida com sucesso')),
      );
    } catch (e) {
      Warning00ErrorUtil.showDialogMessageError(
        context,
        "Erro ao sair da partida",
        "Ocorreu um erro ao tentar sair da partida. Tente novamente.",
      );
    }
  }

  Widget buildMatchButton({
    required bool isRegistered,
    required dynamic match,
    required Future<void> Function(dynamic) onJoin,
    required Future<void> Function(dynamic) onLeave,
    required BuildContext context,
  }) {
    return FFButtonWidget(
      onPressed: () async {
        if (isRegistered) {
          await onLeave(match);
        } else {
          await onJoin(match);
        }
      },
      text: isRegistered ? 'SAIR DA PARTIDA' : 'INSCREVER-SE',
      icon: Icon(
        isRegistered ? Icons.logout : Icons.login,
        size: 20,
      ),
      options: FFButtonOptions(
        width: double.infinity,
        height: 50,
        color: isRegistered ? Colors.redAccent : const Color(0xFF00B80E),
        textStyle: FlutterFlowTheme.of(context).titleMedium.override(
              fontFamily: 'Inter Tight',
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
            ),
        elevation: 2,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
