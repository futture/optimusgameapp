import 'package:projeto_game_quiz/core/api/utils/token_util.dart';
import 'package:projeto_game_quiz/pages/deposit_history/deposit_history_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'moda_menu_pagian_inicial_model.dart';
export 'moda_menu_pagian_inicial_model.dart';

class ModaMenuPagianInicialWidget extends StatefulWidget {
  final bool? isMainScreen;
  const ModaMenuPagianInicialWidget({super.key, this.isMainScreen});

  @override
  State<ModaMenuPagianInicialWidget> createState() =>
      _ModaMenuPagianInicialWidgetState();
}

class _ModaMenuPagianInicialWidgetState
    extends State<ModaMenuPagianInicialWidget> {
  late ModaMenuPagianInicialModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModaMenuPagianInicialModel());
    _model.getUserIdAsync();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: 350.0,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 1.0),
              spreadRadius: 5.0,
            )
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter Tight',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      icon: Icon(
                        Icons.close,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () => context.safePop(),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2.0,
                color: Colors.black,
                indent: 20.0,
                endIndent: 20.0,
              ),
              _buildMenuItem(
                icon: Icons.person,
                text: 'Meu Perfil',
                onTap: () => context.pushNamed(Tela04PerfilWidget.routeName),
              ),
              _buildMenuItem(
                icon: Icons.account_balance,
                text: 'Dados Financeiros',
                onTap: () => context.pushNamed(Tela07FinancasWidget.routeName),
              ),
              _buildMenuItem(
                icon: FontAwesomeIcons.wallet,
                text: 'Carteira',
                onTap: () => context.pushNamed(Tela08CarteiraWidget.routeName),
              ),
              _buildMenuItem(
                icon: Icons.history_sharp,
                text: 'Histórico de Jogos',
                onTap: () =>
                    context.pushNamed(Tela09HistoricoJodosWidget.routeName),
              ),
              _buildMenuItem(
                icon: Icons.history_toggle_off_sharp,
                text: 'Histórico Depósito',
                onTap: () =>
                    context.pushNamed(DepositHistoryScreenWidget.routeName),
              ),
              if (widget.isMainScreen == null)
                _buildMenuItem(
                  icon: Icons.home_outlined,
                  text: 'Inicio',
                  onTap: () =>
                      context.pushNamed(Tela03PrincipalWidget.routeName),
                ),
              Divider(
                thickness: 2.0,
                color: Colors.black,
                indent: 20.0,
                endIndent: 20.0,
              ),
              _buildMenuItem(
                icon: Icons.logout_sharp,
                text: 'Terminar Sessão',
                onTap: () async {
                  try {
                    TokenUtil.removeToken();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sessão terminada com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    await _model.logoutAsync();
                    context.pushNamed(Tela00LoginWidget.routeName);
                  } catch (e) {
                    print('Erro ao terminar sessão: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Erro ao terminar sessão. Tente novamente.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: 45.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(icon, size: 20.0),
              SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  text.toUpperCase(),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
