import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:projeto_game_quiz/components/moda_menu_pagian_inicial_widget.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_icon_button.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_model.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/pages/tela13_dados_de_partida/tela13_dados_de_partida_widget.dart';
import 'package:projeto_game_quiz/pages/tela17_notificacao/tela17_notificacao_model.dart';

class Tela17NotificacaoViewWidget extends StatefulWidget {
  const Tela17NotificacaoViewWidget({super.key});

  static String routeName = 'Tela17Notificacao';
  static String routePath = '/tela17Notificacao';

  @override
  State<Tela17NotificacaoViewWidget> createState() =>
      _Tela17NotificacaoViewWidgetState();
}

class _Tela17NotificacaoViewWidgetState
    extends State<Tela17NotificacaoViewWidget> {
  late Tela17NotificacaoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela17NotificacaoModel());
    _model.loadAsync(setState);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('dd/MM/yyyy').format(date);
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} dias atrás';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} horas atrás';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutos atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  IconData _getNotificationIcon(String? code) {
    switch (code) {
      case 'Desafio':
        return Icons.sports_esports;
      case 'Desqualificação':
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String? code, bool isNew) {
    if (isNew) {
      switch (code) {
        case 'Desafio':
          return Colors.blue.shade50;
        case 'Desqualificação':
          return Colors.orange.shade50;
        default:
          return Colors.deepPurple.shade50;
      }
    }
    return Colors.white;
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
      ),
      body: Builder(
        builder: (context) {
          if (_model.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            );
          } else if (_model.pushNotifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty_notifications.png',
                    width: 150,
                    height: 150,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Nenhuma notificação encontrada',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Quando você receber notificações,\nelas aparecerão aqui.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => _model.loadAsync(setState),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _model.pushNotifications.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _model.pushNotifications[index];
                  final isNew = item.isNew ?? false;

                  return Container(
                    color: _getNotificationColor(item.code, isNew),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isNew
                              ? Theme.of(context).primaryColor.withOpacity(0.2)
                              : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getNotificationIcon(item.code),
                          color: isNew
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade600,
                        ),
                      ),
                      title: Text(
                        item.subject ?? 'Sem assunto',
                        style: TextStyle(
                          fontWeight:
                              isNew ? FontWeight.bold : FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.message ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(item.createdAt ?? DateTime.now()),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      trailing: isNew
                          ? Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                      onTap: () {
                        if (item.code == "Desafio") {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => Tela13DadosDePartidaWidget(
                                matchId: item.metaData,
                                recebeuNotificaca: true,
                              ),
                            ),
                          );
                        }
                        if (item.code == "Desqualificação") {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => Tela13DadosDePartidaWidget(
                                matchId: item.metaData,
                                notDisplayButton: true,
                                isDesqualification: true,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
