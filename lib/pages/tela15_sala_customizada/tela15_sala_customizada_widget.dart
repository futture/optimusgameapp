import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_game_quiz/components/moda_menu_pagian_inicial_widget.dart';
import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_icon_button.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/pages/tela03_principal/tela03_principal_widget.dart';
import 'package:projeto_game_quiz/pages/tela15_sala_customizada/tela15_sala_customizada_model.dart';

class Tela15SalaCustomizadaViewWidget extends StatefulWidget {
  const Tela15SalaCustomizadaViewWidget({super.key});

  static String routeName = 'Tela15SalaCustomizadaView';
  static String routePath = '/tela15SalaCustomizadaView';

  @override
  State<Tela15SalaCustomizadaViewWidget> createState() =>
      _Tela15SalaCustomizadaViewWidgetState();
}

class _Tela15SalaCustomizadaViewWidgetState
    extends State<Tela15SalaCustomizadaViewWidget>
    with TickerProviderStateMixin {
  late Tela15SalaCustomizadaViewModel _model;
  bool _isInitialized = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Cores do tema
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);
  final Color _textColor = Color(0xFF334155);

  // Breakpoints para responsividade
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 1200;

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _initializeModel() async {
    _model = createModel(context, () => Tela15SalaCustomizadaViewModel());
    await Future.delayed(Duration.zero);

    _model.initState(context);
    await _model.getUserIdAsync(() => setState);
    await _model.fetchContactsAsync(setState);

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: _backgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Tela03PrincipalWidget()),
        );
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        key: scaffoldKey,
        backgroundColor: _backgroundColor,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isMobile = screenWidth < _mobileBreakpoint;
            final isTablet = screenWidth >= _mobileBreakpoint &&
                screenWidth < _tabletBreakpoint;

            return Column(
              children: [
                // Header
                _buildHeader(isMobile, isTablet, screenWidth),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: _buildMainContent(isMobile, isTablet, screenWidth),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile, bool isTablet, double screenWidth) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, Color(0xFFF59E0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : _tabletBreakpoint),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 12 : 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Botão Voltar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius:
                              BorderRadius.circular(isMobile ? 10 : 12),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => Tela03PrincipalWidget()),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: isMobile ? 18 : 20,
                          ),
                          splashRadius: 20,
                        ),
                      ),
                      SizedBox(width: isMobile ? 12 : 16),
                      Expanded(
                        child: Text(
                          'CRIAR PARTIDA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 18 : 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            fontFamily: 'Inter',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 6 : 8),
                  Container(
                    height: 2,
                    width: isMobile ? 40 : 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(horizontalPadding),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: Form(
            key: _model.formKey,
            child: Column(
              children: [
                // Cabeçalho melhorado da criação
                _buildMainHeader(isMobile, isTablet),

                SizedBox(height: isMobile ? 12 : 16),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título da seção
                      _buildSectionTitle(
                        title: 'Configurações Básicas',
                        icon: Icons.settings_rounded,
                        isMobile: isMobile,
                      ),
                      SizedBox(height: isMobile ? 12 : 16),

                      // Campo: Número de Jogadores
                      _buildInputField(
                        label: 'Número de Jogadores',
                        hintText: 'Ex: 10',
                        controller: _model.numberPlayerTextController,
                        focusNode: _model.numberPlayerFocusNode,
                        validator: (val) =>
                            _model.validateNumberPlayer(context, val),
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        icon: Icons.people_alt_rounded,
                        onChanged: (value) => setState(() {}),
                        isMobile: isMobile,
                      ),

                      if (_model
                          .numberPlayerTextController.text.isNotEmpty) ...[
                        SizedBox(height: isMobile ? 16 : 24),

                        // Título: Adicionar Jogadores
                        _buildSectionTitle(
                          title: 'Adicionar Jogadores',
                          icon: Icons.person_add_alt_1_rounded,
                          isMobile: isMobile,
                        ),
                        SizedBox(height: isMobile ? 12 : 16),

                        // Campo de busca de jogadores
                        _buildPlayerAutocomplete(context, isMobile),

                        if (_model.addedUsers.isNotEmpty) ...[
                          SizedBox(height: isMobile ? 16 : 20),
                          _buildAddedPlayersSection(context, isMobile),
                        ],

                        SizedBox(height: isMobile ? 16 : 24),

                        // Título: Configurações do Jogo
                        _buildSectionTitle(
                          title: 'Configurações do Jogo',
                          icon: Icons.videogame_asset_rounded,
                          isMobile: isMobile,
                        ),
                        SizedBox(height: isMobile ? 12 : 16),

                        // Campos de configuração em linha
                        _buildGameSettingsRow(isMobile),

                        SizedBox(height: isMobile ? 12 : 16),

                        // Campo: Valor da Aposta
                        _buildInputField(
                          label: 'Valor da Aposta',
                          hintText: 'Ex: 1500',
                          controller: _model.montanteTextController,
                          focusNode: _model.montanteFocusNode,
                          validator: (val) =>
                              _model.validateMontante(context, val),
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          icon: Icons.account_balance_wallet_rounded,
                          onChanged: (value) {},
                          prefixText: 'AOA ',
                          isMobile: isMobile,
                        ),

                        SizedBox(height: isMobile ? 16 : 24),

                        // Configurações Avançadas
                        _buildAdvancedSettingsSection(context, isMobile),

                        SizedBox(height: isMobile ? 20 : 32),

                        // Botão de Iniciar Partida
                        _buildStartGameButton(context, isMobile),

                        SizedBox(height: isMobile ? 16 : 20),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainHeader(bool isMobile, bool isTablet) {
    return Container(
      margin: EdgeInsets.all(isMobile ? 12 : 20),
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_surfaceColor, Color(0xFFFEF7E6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: _outlineColor,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Ícone e título
          Container(
            width: isMobile ? 60 : 80,
            height: isMobile ? 60 : 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, Color(0xFFF59E0B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.group_add_rounded,
              size: isMobile ? 28 : 36,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 20),

          // Título principal
          Text(
            'CRIAR PARTIDA PERSONALIZADA',
            style: TextStyle(
              fontFamily: 'Inter Tight',
              color: _onSurfaceColor,
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: isMobile ? 4 : 8),

          // Subtítulo
          Text(
            'Configure regras, convide amigos e crie uma experiência única de jogo',
            style: TextStyle(
              fontFamily: 'Inter',
              color: Colors.grey.shade600,
              fontSize: isMobile ? 12 : 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: isMobile ? 12 : 20),

          // Badge informativo
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: isMobile ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              border: Border.all(
                color: _primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: isMobile ? 14 : 16,
                  color: _primaryColor,
                ),
                SizedBox(width: isMobile ? 6 : 8),
                Text(
                  'Convide até 50 jogadores',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: _primaryColor,
                    fontSize: isMobile ? 12 : 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
      {required String title, required IconData icon, required bool isMobile}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: isMobile ? 36 : 40,
            height: isMobile ? 36 : 40,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              border: Border.all(
                color: _primaryColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              size: isMobile ? 18 : 20,
              color: _primaryColor,
            ),
          ),
          SizedBox(width: isMobile ? 10 : 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                color: _onSurfaceColor,
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String? Function(String?)? validator,
    required int maxLength,
    required TextInputType keyboardType,
    required IconData icon,
    required Function(String?)? onChanged,
    String? prefixText,
    required bool isMobile,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _outlineColor,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: isMobile ? 32 : 36,
                  height: isMobile ? 32 : 36,
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                  ),
                  child: Icon(
                    icon,
                    size: isMobile ? 16 : 18,
                    color: _primaryColor,
                  ),
                ),
                SizedBox(width: isMobile ? 10 : 12),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: _textColor,
                    fontSize: isMobile ? 15 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontFamily: 'Inter',
                  fontSize: isMobile ? 15 : 16,
                ),
                prefixText: prefixText,
                prefixStyle: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 14 : 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                  borderSide: BorderSide(
                    color: _outlineColor,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                  borderSide: BorderSide(
                    color: _outlineColor,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                  borderSide: BorderSide(
                    color: _primaryColor,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: _backgroundColor,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 14 : 16,
                  vertical: isMobile ? 14 : 16,
                ),
              ),
              style: TextStyle(
                fontFamily: 'Inter',
                color: _textColor,
                fontSize: isMobile ? 15 : 16,
                fontWeight: FontWeight.w500,
              ),
              maxLength: maxLength,
              keyboardType: keyboardType,
              validator: validator,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerAutocomplete(BuildContext context, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _outlineColor,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: isMobile ? 32 : 36,
                  height: isMobile ? 32 : 36,
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    size: isMobile ? 16 : 18,
                    color: _primaryColor,
                  ),
                ),
                SizedBox(width: isMobile ? 10 : 12),
                Text(
                  'Buscar Jogador',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: _textColor,
                    fontSize: isMobile ? 15 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            buildAutocompleteUsuario(
              context: context,
              model: _model,
              usuarios: _model.listContacts,
              onUsuarioSelecionado: (phoneNumber) {
                setState(() {
                  _model.addUser(phoneNumber, setState);
                });
              },
              isMobile: isMobile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddedPlayersSection(BuildContext context, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _outlineColor,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Row(
              children: [
                Container(
                  width: isMobile ? 32 : 36,
                  height: isMobile ? 32 : 36,
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                  ),
                  child: Icon(
                    Icons.group_rounded,
                    size: isMobile ? 16 : 18,
                    color: _primaryColor,
                  ),
                ),
                SizedBox(width: isMobile ? 10 : 12),
                Expanded(
                  child: Text(
                    'Jogadores Adicionados',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: _textColor,
                      fontSize: isMobile ? 15 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10 : 12,
                    vertical: isMobile ? 5 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                    border: Border.all(
                      color: _primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${_model.addedUsers.length}',
                    style: TextStyle(
                      color: _primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 14 : 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ..._model.addedUsers.map((usuario) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 10 : 12,
              ),
              child: Row(
                children: [
                  Container(
                    width: isMobile ? 40 : 44,
                    height: isMobile ? 40 : 44,
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        usuario['nome']!.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 14 : 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isMobile ? 10 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          usuario['nome']!,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: _textColor,
                            fontSize: isMobile ? 14 : 15,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          usuario['telefone'] ?? '',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.grey.shade600,
                            fontSize: isMobile ? 12 : 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: isMobile ? 32 : 36,
                    height: isMobile ? 32 : 36,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                      border: Border.all(
                        color: Colors.red.shade100,
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close_rounded, size: isMobile ? 16 : 18),
                      color: Colors.red.shade500,
                      onPressed: () {
                        setState(() {
                          _model.addedUsers.remove(usuario);
                        });
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettingsSection(BuildContext context, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _outlineColor,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: isMobile ? 32 : 36,
                  height: isMobile ? 32 : 36,
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                  ),
                  child: Icon(
                    Icons.settings_rounded,
                    size: isMobile ? 16 : 18,
                    color: _primaryColor,
                  ),
                ),
                SizedBox(width: isMobile ? 10 : 12),
                Text(
                  'Configurações Avançadas',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: _textColor,
                    fontSize: isMobile ? 15 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: isMobile ? 16 : 20),

            // Tipo de Pergunta
            Text(
              'Tipo de Pergunta:',
              style: TextStyle(
                fontFamily: 'Inter',
                color: _textColor,
                fontSize: isMobile ? 14 : 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: isMobile ? 10 : 12),
            _buildRadioOptions(
              isMobile: isMobile,
              groupValue: _model.isSimpleQuestion,
              onChanged: (value) {
                setState(() => _model.isSimpleQuestion = value!);
              },
              option1Title: 'Simples',
              option1Value: true,
              option2Title: 'Completa',
              option2Value: false,
            ),

            SizedBox(height: isMobile ? 16 : 20),

            // Vencedores
            Text(
              'Vencedores:',
              style: TextStyle(
                fontFamily: 'Inter',
                color: _textColor,
                fontSize: isMobile ? 14 : 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: isMobile ? 10 : 12),
            _buildRadioOptions(
              isMobile: isMobile,
              groupValue: _model.onlyOneWinner,
              onChanged: (value) {
                setState(() => _model.onlyOneWinner = value!);
              },
              option1Title: 'Apenas 1',
              option1Value: true,
              option2Title: 'Múltiplos',
              option2Value: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOptions({
    required bool isMobile,
    required bool? groupValue,
    required Function(bool?) onChanged,
    required String option1Title,
    required bool option1Value,
    required String option2Title,
    required bool option2Value,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildRadioOption(
            title: option1Title,
            value: option1Value,
            groupValue: groupValue,
            onChanged: onChanged,
            isMobile: isMobile,
          ),
        ),
        SizedBox(width: isMobile ? 8 : 12),
        Expanded(
          child: _buildRadioOption(
            title: option2Title,
            value: option2Value,
            groupValue: groupValue,
            onChanged: onChanged,
            isMobile: isMobile,
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required String title,
    required bool value,
    required bool? groupValue,
    required Function(bool?) onChanged,
    required bool isMobile,
  }) {
    final isSelected = groupValue == value;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor.withOpacity(0.1) : _backgroundColor,
          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
          border: Border.all(
            color: isSelected ? _primaryColor : _outlineColor,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: isMobile ? 18 : 20,
              height: isMobile ? 18 : 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _primaryColor : Colors.grey.shade400,
                  width: isSelected ? 5 : 2,
                ),
              ),
            ),
            SizedBox(width: isMobile ? 8 : 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: isSelected ? _primaryColor : _textColor,
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartGameButton(BuildContext context, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: isMobile ? 16 : 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
          ),
          elevation: 0,
          minimumSize: Size(double.infinity, isMobile ? 56 : 64),
        ),
        onPressed: _model.isLoadingStartMatch
            ? null
            : () async {
                final isValid =
                    _model.formKey.currentState?.validate() ?? false;
                if (!isValid) return;

                _model.playerIds = [];
                _model.addedUsers.forEach((action) {
                  _model.playerIds.add(action['id']!);
                });

                if (_model.playerIds.isEmpty) {
                  await Warning00ErrorUtil.showDialogMessageError(
                    context,
                    "Falha ao iniciar partida",
                    "Você precisa adicionar pelo menos um jogador.",
                  );
                  return;
                }

                setState(() {
                  _model.isLoadingStartMatch = true;
                });

                try {
                  await _model.createMatchAsync(setState);
                } finally {
                  if (mounted) {
                    setState(() {
                      _model.isLoadingStartMatch = false;
                    });
                  }
                }
              },
        child: _model.isLoadingStartMatch
            ? SizedBox(
                width: isMobile ? 24 : 28,
                height: isMobile ? 24 : 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: isMobile ? 36 : 40,
                    height: isMobile ? 36 : 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: isMobile ? 20 : 22,
                    ),
                  ),
                  SizedBox(width: isMobile ? 12 : 16),
                  Flexible(
                    child: Text(
                      'INICIAR PARTIDA',
                      style: TextStyle(
                        fontFamily: 'Inter Tight',
                        color: Colors.white,
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGameSettingsRow(bool isMobile) {
    return isMobile
        ? Column(
            children: [
              _buildCompactInputField(
                label: 'Nº de Questões',
                hintText: 'Ex: 10',
                controller: _model.numberQuestionTextController,
                focusNode: _model.numberQuestionFocusNode,
                validator: (val) => _model.validateNumberQuestion(context, val),
                maxLength: 8,
                keyboardType: TextInputType.number,
                icon: Icons.quiz_rounded,
                isMobile: isMobile,
              ),
              SizedBox(height: 12),
              _buildCompactInputField(
                label: 'Opções por Questão',
                hintText: 'Ex: 4',
                controller: _model.numberOptionAnswerTextController,
                focusNode: _model.numberOptionAnswerFocusNode,
                validator: (val) =>
                    _model.validateNumberOptionAnswer(context, val),
                maxLength: 1,
                keyboardType: TextInputType.number,
                icon: Icons.format_list_numbered_rounded,
                isMobile: isMobile,
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: _buildCompactInputField(
                  label: 'Nº de Questões',
                  hintText: 'Ex: 10',
                  controller: _model.numberQuestionTextController,
                  focusNode: _model.numberQuestionFocusNode,
                  validator: (val) =>
                      _model.validateNumberQuestion(context, val),
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                  icon: Icons.quiz_rounded,
                  isMobile: isMobile,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildCompactInputField(
                  label: 'Opções por Questão',
                  hintText: 'Ex: 4',
                  controller: _model.numberOptionAnswerTextController,
                  focusNode: _model.numberOptionAnswerFocusNode,
                  validator: (val) =>
                      _model.validateNumberOptionAnswer(context, val),
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  icon: Icons.format_list_numbered_rounded,
                  isMobile: isMobile,
                ),
              ),
            ],
          );
  }

  Widget buildAutocompleteUsuario({
    required BuildContext context,
    required Tela15SalaCustomizadaViewModel model,
    required Map<String, String> usuarios,
    required void Function(String id) onUsuarioSelecionado,
    required bool isMobile,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return usuarios.keys.where((id) =>
                id.contains(textEditingValue.text) ||
                usuarios[id]!
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
          },
          displayStringForOption: (option) => usuarios[option] ?? option,
          onSelected: (selectedOption) {
            model.idTextController.text = selectedOption;
            onUsuarioSelecionado(selectedOption);
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            model.idTextController = textEditingController;
            model.idFocusNode = focusNode;
            return Column(
              children: [
                TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Digite nome ou telefone',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontFamily: 'Inter',
                      fontSize: isMobile ? 15 : 16,
                    ),
                    suffixIcon: textEditingController.text.isNotEmpty
                        ? Container(
                            width: isMobile ? 32 : 36,
                            height: isMobile ? 32 : 36,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.close_rounded,
                                  size: isMobile ? 16 : 18),
                              color: Colors.grey.shade600,
                              onPressed: () {
                                textEditingController.clear();
                                setState(() {});
                              },
                              padding: EdgeInsets.zero,
                            ),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                      borderSide: BorderSide(
                        color: _outlineColor,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                      borderSide: BorderSide(
                        color: _outlineColor,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                      borderSide: BorderSide(
                        color: _primaryColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: _backgroundColor,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 14 : 16,
                      vertical: isMobile ? 14 : 16,
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: _textColor,
                    fontSize: isMobile ? 15 : 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLength: 14,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => setState(() {}),
                ),
                if (textEditingController.text.isNotEmpty &&
                    !usuarios.keys.any((key) =>
                        key.contains(textEditingController.text) &&
                        !usuarios.values.any((value) => value
                            .toLowerCase()
                            .contains(
                                textEditingController.text.toLowerCase()))))
                  Padding(
                    padding: EdgeInsets.only(top: isMobile ? 10 : 12),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.person_add_rounded,
                          size: isMobile ? 16 : 18),
                      label: Text(
                        'Adicionar Jogador',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 14 : 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, isMobile ? 44 : 48),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(isMobile ? 10 : 12),
                        ),
                        elevation: 2,
                        shadowColor: _primaryColor.withOpacity(0.3),
                      ),
                      onPressed: () {
                        final text = textEditingController.text.trim();
                        if (text.isNotEmpty) {
                          model.idTextController.text = text;
                          onUsuarioSelecionado(text);
                        }
                      },
                    ),
                  ),
              ],
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            final text = model.idTextController.text.trim();
            final hasNoMatch = options.isEmpty && text.isNotEmpty;

            return Align(
              alignment: Alignment.topCenter,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
                child: Container(
                  width: isMobile ? double.infinity : 320,
                  constraints: BoxConstraints(maxHeight: isMobile ? 200 : 240),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (options.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 12 : 16,
                                  vertical: isMobile ? 10 : 12,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: _primaryColor,
                                  foregroundColor: Colors.white,
                                  radius: isMobile ? 18 : 20,
                                  child: Text(
                                    usuarios[option]!
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: isMobile ? 14 : 16,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  usuarios[option] ?? option,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: _textColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: isMobile ? 14 : 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  option,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.grey.shade600,
                                    fontSize: isMobile ? 12 : 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      if (hasNoMatch) Divider(height: 1, color: _outlineColor),
                      if (hasNoMatch)
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 12 : 16,
                            vertical: isMobile ? 10 : 12,
                          ),
                          leading: Container(
                            width: isMobile ? 36 : 40,
                            height: isMobile ? 36 : 40,
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.green.shade100,
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.person_add_rounded,
                              size: isMobile ? 18 : 20,
                              color: Colors.green.shade600,
                            ),
                          ),
                          title: Text(
                            'Adicionar "$text"',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: _textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: isMobile ? 14 : 15,
                            ),
                          ),
                          onTap: () {
                            model.idTextController.text = text;
                            onUsuarioSelecionado(text);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCompactInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String? Function(String?)? validator,
    required int maxLength,
    required TextInputType keyboardType,
    required IconData icon,
    required bool isMobile,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _outlineColor,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: isMobile ? 28 : 32,
                  height: isMobile ? 28 : 32,
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
                  ),
                  child: Icon(
                    icon,
                    size: isMobile ? 14 : 16,
                    color: _primaryColor,
                  ),
                ),
                SizedBox(width: isMobile ? 8 : 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: _textColor,
                      fontSize: isMobile ? 14 : 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 10 : 12),
            SizedBox(
              height: isMobile ? 48 : 52,
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontFamily: 'Inter',
                    fontSize: isMobile ? 14 : 15,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 14,
                    vertical: isMobile ? 12 : 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                    borderSide: BorderSide(
                      color: _outlineColor,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                    borderSide: BorderSide(
                      color: _outlineColor,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                    borderSide: BorderSide(
                      color: _primaryColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: _backgroundColor,
                ),
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: _textColor,
                  fontSize: isMobile ? 14 : 15,
                  fontWeight: FontWeight.w500,
                ),
                maxLength: maxLength,
                keyboardType: keyboardType,
                validator: validator,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
