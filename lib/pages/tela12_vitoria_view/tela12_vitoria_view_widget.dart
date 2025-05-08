import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tela12_vitoria_view_model.dart';
export 'tela12_vitoria_view_model.dart';

class Tela12VitoriaViewWidget extends StatefulWidget {
  final dynamic gameResultInfo;
  const Tela12VitoriaViewWidget({super.key, this.gameResultInfo});

  static String routeName = 'Tela12VitoriaView';
  static String routePath = '/tela12VitoriaView';

  @override
  State<Tela12VitoriaViewWidget> createState() =>
      _Tela12VitoriaViewWidgetState();
}

class _Tela12VitoriaViewWidgetState extends State<Tela12VitoriaViewWidget>
    with TickerProviderStateMixin {
  late Tela12VitoriaViewModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela12VitoriaViewModel());
    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return const Color(0xFFFFD700); // Ouro
      case 2:
        return const Color(0xFFC0C0C0); // Prata
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return const Color(0xFFEC8D0D);
    }
  }

  Widget _buildPodiumUser({
    required int position,
    required String name,
    required String points,
    required String avatarUrl,
    required double height,
    bool isFirst = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isFirst)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFD700),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ],
            ),
            child: const FaIcon(
              FontAwesomeIcons.crown,
              color: Colors.white,
              size: 24,
            ),
          ),
        const SizedBox(height: 8),
        Container(
          width: 90,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
            border: Border.all(
              color: _getPositionColor(position),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Número da posição
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _getPositionColor(position),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    position.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Avatar
              Container(
                decoration: isFirst
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFFD700),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            spreadRadius: 1,
                          )
                        ],
                      )
                    : null,
                child: CircleAvatar(
                  radius: isFirst ? 32 : 28,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
              const SizedBox(height: 10),
              // Nome
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isFirst ? const Color(0xFFEC8D0D) : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              // Pontos
              Text(
                points,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFEC8D0D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRankingList() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(10, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFEC8D0D),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (index + 4).toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEC8D0D),
                        ),
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(
                            'https://picsum.photos/seed/${index + 100}/600'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Usuário ${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEC8D0D), Color(0xFFF5B041)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(10000 - index * 1000)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
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
              icon: Icon(
                Icons.arrow_back,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
          ),
          title: Text(
            'RANKINGS',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'Inter Tight',
                  color: const Color(0xFFEC8D0D),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              // TabBar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: FlutterFlowButtonTabBar(
                    useToggleButtonStyle: true,
                    labelStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Inter Tight',
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.0,
                            ),
                    unselectedLabelStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Inter Tight',
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                            ),
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFFEC8D0D),
                    backgroundColor: const Color(0xFFEC8D0D),
                    unselectedBackgroundColor: Colors.white,
                    borderColor: Colors.transparent,
                    unselectedBorderColor: Colors.transparent,
                    borderWidth: 0,
                    borderRadius: 8.0,
                    elevation: 0,
                    buttonMargin: const EdgeInsetsDirectional.fromSTEB(
                        4.0, 0.0, 4.0, 0.0),
                    padding: const EdgeInsets.all(8.0),
                    tabs: const [
                      Tab(
                        text: 'Hoje',
                        icon: Icon(Icons.today, size: 18),
                      ),
                      Tab(
                        text: 'Semana',
                        icon: Icon(Icons.date_range, size: 18),
                      ),
                      Tab(
                        text: 'Mês',
                        icon: Icon(Icons.calendar_month, size: 18),
                      ),
                    ],
                    controller: _model.tabBarController,
                    onTap: (i) async {
                      [() async {}, () async {}, () async {}][i]();
                    },
                  ),
                ),
              ),

              // Pódio de vencedores
              Container(
                height: 260,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Stack(
                  children: [
                    // Base do pódio
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEC8D0D).withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                      ),
                    ),

                    // Posição 2 (esquerda)
                    Positioned(
                      left: 20,
                      bottom: 50,
                      child: _buildPodiumUser(
                        position: 2,
                        name: 'João Seba',
                        points: '200.245',
                        avatarUrl: 'https://picsum.photos/seed/380/600',
                        height: 150,
                      ),
                    ),

                    // Posição 1 (centro) - com coroa
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2 - 60,
                      bottom: 30,
                      child: _buildPodiumUser(
                        position: 1,
                        name: 'Paulo Pinto',
                        points: '200.245',
                        avatarUrl:
                            'https://images.unsplash.com/photo-1507502707541-f369a3b18502',
                        height: 177,
                        isFirst: true,
                      ),
                    ),

                    // Posição 3 (direita)
                    Positioned(
                      right: 20,
                      bottom: 40,
                      child: _buildPodiumUser(
                        position: 3,
                        name: 'Pedro Sampaio',
                        points: '200.245',
                        avatarUrl:
                            'https://images.unsplash.com/photo-1507502707541-f369a3b18502',
                        height: 140,
                      ),
                    ),
                  ],
                ),
              ),

              // Lista de rankings
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: TabBarView(
                    controller: _model.tabBarController,
                    children: [
                      _buildRankingList(),
                      _buildRankingList(),
                      _buildRankingList(),
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
}
