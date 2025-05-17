import 'package:projeto_game_quiz/pages/support/support_screen.dart';
import 'package:projeto_game_quiz/pages/tela11_editar_perfil/tela11_editar_perfil_widget.dart';
import 'package:projeto_game_quiz/pages/tela12_vitoria_view/tela12_vitoria_view_widget.dart';
import 'package:projeto_game_quiz/pages/tela17_notificacao/tela17_notificacao_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'tela04_perfil_model.dart';
export 'tela04_perfil_model.dart';

class Tela04PerfilWidget extends StatefulWidget {
  const Tela04PerfilWidget({super.key});

  static String routeName = 'Tela04Perfil';
  static String routePath = '/tela04Perfil';

  @override
  State<Tela04PerfilWidget> createState() => _Tela04PerfilWidgetState();
}

class _Tela04PerfilWidgetState extends State<Tela04PerfilWidget> {
  late Tela04PerfilModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela04PerfilModel());
    _model.getUserInfoAndAccountInfoAsync(setState, context);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 60.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4.0,
                  color: Color(0x1A000000),
                  offset: Offset(0.0, 2.0),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFEC8D0D),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: FlutterFlowTheme.of(context).secondary,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      title.toUpperCase(),
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  if (showArrow)
                    Icon(
                      Icons.arrow_forward_ios,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 16.0,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30.0,
          ),
          onPressed: () async {
            context.safePop();
          },
        ),
        title: Text(
          'PERFIL',
          style: FlutterFlowTheme.of(context).titleLarge.override(
                fontFamily: 'Inter Tight',
                color: Color(0xFFEC8D0D),
                letterSpacing: 0.0,
              ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Container( // Adicionado Container com maxWidth
              constraints: BoxConstraints(
                maxWidth: isWeb ? 1000 : double.infinity,
              ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3.0,
                      color: Color(0x33000000),
                      offset: Offset(0.0, 1.0),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFEC8D0D),
                            width: 2.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://images.unsplash.com/photo-1531123414780-f74242c2b052?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDV8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.person),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _model.user == null
                                  ? 'Carregando...'
                                  : _model.user!.name.toUpperCase(),
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    fontFamily: 'Outfit',
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              _model.userAccountInfo == null
                                  ? "Carregando..."
                                  : 'ID: ${_model.userAccountInfo!.availableBalance}',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ), 
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 0.0, 8.0),
                child: Text(
                  'CONTA',
                  style: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12.0,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              _buildProfileItem(
                icon: Icons.hotel_class,
                title: 'Ranking de Partida',
                onTap: () {
                  context.pushNamed(
                    Tela12VitoriaViewWidget.routeName,
                    extra: <String, dynamic>{
                      kTransitionInfoKey: TransitionInfo(
                        hasTransition: true,
                        transitionType: PageTransitionType.rightToLeft,
                      ),
                    },
                  );
                },
              ),
        
              _buildProfileItem(
                icon: Icons.notifications_none,
                title: 'Notificações',
                onTap: () {
                  context.pushNamed(Tela17NotificacaoViewWidget.routeName);
                },
              ),
        
              _buildProfileItem(
                icon: Icons.account_circle_outlined,
                title: 'Editar Perfil',
                onTap: () {
                  context.pushNamed(Tela11EditarPerfilWidget.routeName);
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 0.0, 8.0),
                child: Text(
                  'GERAL',
                  style: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12.0,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              _buildProfileItem(
                icon: Icons.support_outlined,
                title: 'Suporte',
                onTap: () {
                  context.pushNamed(TelaSuporteWidget.routeName);
                },
              ),
              _buildProfileItem(
                icon: Icons.privacy_tip_rounded,
                title: 'Termos de Serviço',
              ),
        
              _buildProfileItem(
                icon: Icons.ios_share,
                title: 'Convidar Amigos',
              ),
        
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    ));
  }
}
