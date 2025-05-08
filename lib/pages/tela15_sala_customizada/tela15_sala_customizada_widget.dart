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
      return const Center(child: CircularProgressIndicator());
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
        body: SingleChildScrollView(
          child: Form(
            key: _model.formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.people_alt_rounded,
                          size: 50, color: Colors.grey),
                      const SizedBox(height: 10),
                      Text(
                        'CRIAR PARTIDA PERSONALIZADA',
                        style: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(
                              fontFamily: 'Inter Tight',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                // Main Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Number of Players
                      _buildSectionTitle('Configurações Básicas'),
                      _buildInputCard(
                        context: context,
                        label: 'Número de Jogadores',
                        hintText: 'Ex.: 10',
                        controller: _model.numberPlayerTextController,
                        focusNode: _model.numberPlayerFocusNode,
                        validator: (val) =>
                            _model.validateNumberPlayer(context, val),
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        icon: Icons.people_outline,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),

                      if (_model
                          .numberPlayerTextController.text.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildSectionTitle('Adicionar Jogadores'),
                        _buildPlayerAutocomplete(context),
                        if (_model.addedUsers.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildAddedPlayersSection(context),
                        ],
                        const SizedBox(height: 16),
                        _buildSectionTitle('Configurações do Jogo'),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputCard(
                                  context: context,
                                  label: 'Nº de Questões',
                                  hintText: 'Ex.: 10',
                                  controller:
                                      _model.numberQuestionTextController,
                                  focusNode: _model.numberQuestionFocusNode,
                                  validator: (val) => _model
                                      .validateNumberQuestion(context, val),
                                  maxLength: 2,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.quiz_outlined,
                                  onChanged: ((e) {})),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildInputCard(
                                  context: context,
                                  label: 'Opções Resposta',
                                  hintText: 'Ex.: 4',
                                  controller:
                                      _model.numberOptionAnswerTextController,
                                  focusNode: _model.numberOptionAnswerFocusNode,
                                  validator: (val) => _model
                                      .validateNumberOptionAnswer(context, val),
                                  maxLength: 1,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.format_list_numbered,
                                  onChanged: ((e) {})),
                            ),
                          ],
                        ),
                        _buildInputCard(
                            context: context,
                            label: 'Valor da Aposta',
                            hintText: 'Ex.: 1500',
                            controller: _model.montanteTextController,
                            focusNode: _model.montanteFocusNode,
                            validator: (val) =>
                                _model.validateMontante(context, val),
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            icon: Icons.attach_money,
                            prefixText: 'AOA ',
                            onChanged: ((e) {})),
                        _buildAdvancedSettingsSection(context),
                        const SizedBox(height: 24),
                        _buildStartGameButton(context),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Inter Tight',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard({
    required BuildContext context,
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
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 20,
                    color: FlutterFlowTheme.of(context).secondaryText),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hintText,
                prefixText: prefixText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              style: FlutterFlowTheme.of(context).bodyLarge,
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

  Widget _buildPlayerAutocomplete(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.search,
                    size: 20,
                    color: FlutterFlowTheme.of(context).secondaryText),
                const SizedBox(width: 8),
                Text(
                  'Buscar Jogador',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            buildAutocompleteUsuario(
              context: context,
              model: _model,
              usuarios: _model.listContacts,
              onUsuarioSelecionado: (phoneNumber) {
                setState(() {
                  _model.addUser(phoneNumber, setState);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddedPlayersSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        title: Row(
          children: [
            Icon(Icons.group,
                size: 20, color: FlutterFlowTheme.of(context).secondaryText),
            const SizedBox(width: 8),
            Text(
              'Jogadores Adicionados (${_model.addedUsers.length})',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
            ),
          ],
        ),
        children: _model.addedUsers.map((usuario) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: CircleAvatar(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              child: Text(
                usuario['nome']!.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(usuario['nome']!),
            trailing: IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () {
                setState(() {
                  _model.addedUsers.remove(usuario);
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAdvancedSettingsSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        title: Row(
          children: [
            Icon(Icons.settings,
                size: 20, color: FlutterFlowTheme.of(context).secondaryText),
            const SizedBox(width: 8),
            Text(
              'Configurações Avançadas',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.of(context).primaryColor,
                  ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipo de Pergunta:',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Simples'),
                        value: true,
                        groupValue: _model.isSimpleQuestion,
                        onChanged: (value) {
                          setState(() => _model.isSimpleQuestion = value!);
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Completa'),
                        value: false,
                        groupValue: _model.isSimpleQuestion,
                        onChanged: (value) {
                          setState(() => _model.isSimpleQuestion = value!);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Vencedores:',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Apenas 1'),
                        value: true,
                        groupValue: _model.onlyOneWinner,
                        onChanged: (value) {
                          setState(() => _model.onlyOneWinner = value!);
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Múltiplos'),
                        value: false,
                        groupValue: _model.onlyOneWinner,
                        onChanged: (value) {
                          setState(() => _model.onlyOneWinner = value!);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartGameButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFEC8D0D),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        onPressed: () async {
          final isValid = _model.formKey.currentState?.validate() ?? false;
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

          await _model.createMatchAsync();
        },
        child: Text(
          'INICIAR PARTIDA',
          style: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: 'Inter Tight',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget buildAutocompleteUsuario({
    required BuildContext context,
    required Tela15SalaCustomizadaViewModel model,
    required Map<String, String> usuarios,
    required void Function(String id) onUsuarioSelecionado,
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
                    suffixIcon: textEditingController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () {
                              textEditingController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                  ),
                  style: FlutterFlowTheme.of(context).bodyLarge,
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
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.person_add, size: 18),
                      label: const Text('Adicionar Jogador'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEC8D0D),
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
            final isWeb = !kIsWeb ? false : true;

            if (isWeb && usuarios.isEmpty) {
              return Align(
                alignment: Alignment.topCenter,
                child: Material(
                  elevation: 4,
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.contacts,
                            size: 40, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          'Nenhum contato encontrado',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        if (text.isNotEmpty)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.person_add, size: 18),
                            label: Text('Adicionar "$text"'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFEC8D0D),
                              minimumSize: const Size(double.infinity, 40),
                            ),
                            onPressed: () {
                              model.idTextController.text = text;
                              onUsuarioSelecionado(text);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Align(
              alignment: Alignment.topCenter,
              child: Material(
                elevation: 4,
                child: Container(
                  width: 300,
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
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
                                leading: CircleAvatar(
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).primary,
                                  child: Text(
                                    usuarios[option]!
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(usuarios[option] ?? option),
                                subtitle: Text(option),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      if (hasNoMatch) const Divider(height: 1),
                      if (hasNoMatch)
                        ListTile(
                          leading:
                              const Icon(Icons.person_add, color: Colors.green),
                          title: Text('Adicionar "$text"'),
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
}
