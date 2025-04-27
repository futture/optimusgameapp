import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_game_quiz/components/moda_menu_pagian_inicial_widget.dart';
import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_icon_button.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_widgets.dart';
import 'package:projeto_game_quiz/pages/tela03_principal/tela03_principal_widget.dart';
import 'package:projeto_game_quiz/pages/tela15_sala_customizada/phone_autocomplete_controller.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late PhoneAutocompleteController phoneAutocompleteController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela15SalaCustomizadaViewModel());
    _model.initState(context);
    _model.getUserIdAsync(() => setState);
    _model.fetchContactsAsync(setState);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                Column(
                  children: [
                    const Icon(Icons.manage_accounts,
                        size: 70.0, color: Colors.white),
                    const SizedBox(height: 4.0),
                    Text(
                      'BUSCAR JOGADOR',
                      style: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: 290.0,
                      child: Divider(
                        thickness: 2.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                buildInput(
                  context: context,
                  label: 'Nº DE JOGADOR',
                  controller: _model.numberPlayerTextController!,
                  focusNode: _model.numberPlayerFocusNode!,
                  hintText: 'Ex.: 10',
                  validator: (val) => _model.validateNumberPlayer(context, val),
                  lengthText: 2,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(
                        () {}); // Chama setState para garantir que a UI seja atualizada
                  },
                ),
                // buildBuscarUsuario(
                //   context: context,
                //   model: _model,
                //   onUsuarioSelecionado: _model.addUser,
                // ),

                if (_model.numberPlayerTextController?.text.isNotEmpty ??
                    false) ...[
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
                  SizedBox(
                    width: 290.0,
                    child: Divider(
                      thickness: 2.0,
                      color: Colors.black,
                    ),
                  ),
                  buildInput(
                      context: context,
                      label: 'Nº DE QUESTÕES',
                      controller: _model.numberQuestionTextController!,
                      focusNode: _model.numberQuestionFocusNode!,
                      hintText: 'Ex.: 10',
                      validator: (val) =>
                          _model.validateNumberQuestion(context, val),
                      lengthText: 2,
                      keyboardType: TextInputType.number),
                  SizedBox(width: 6.0),
                  buildInput(
                      context: context,
                      label: 'Nº DE OPÇÕES DE RESPOSTA',
                      controller: _model.numberOptionAnswerTextController!,
                      focusNode: _model.numberOptionAnswerFocusNode!,
                      hintText: 'Ex.: 4',
                      validator: (val) => _model.validateNumberOptionAnswer(
                            context,
                            val,
                          ),
                      lengthText: 2,
                      keyboardType: TextInputType.number),
                  buildInput(
                      context: context,
                      label: 'MONTANTE DA APOSTA',
                      controller: _model.montanteTextController!,
                      focusNode: _model.montanteFocusNode!,
                      hintText: 'Ex.: 1500',
                      validator: (val) => _model.validateMontante(context, val),
                      lengthText: 10,
                      keyboardType: TextInputType.number),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          title: Text(
                            'Adicionais',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Inter Tight',
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tipo de Pergunta:',
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  RadioListTile<bool>(
                                    dense: true,
                                    title: const Text('Simples'),
                                    value: true,
                                    groupValue: _model.isSimpleQuestion,
                                    onChanged: (value) {
                                      setState(() =>
                                          _model.isSimpleQuestion = value!);
                                    },
                                  ),
                                  RadioListTile<bool>(
                                    dense: true,
                                    title: const Text('Completa'),
                                    value: false,
                                    groupValue: _model.isSimpleQuestion,
                                    onChanged: (value) {
                                      setState(() =>
                                          _model.isSimpleQuestion = value!);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    'Vencedores:',
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  RadioListTile<bool>(
                                    dense: true,
                                    title: const Text('Apenas 1 vencedor'),
                                    value: true,
                                    groupValue: _model.onlyOneWinner,
                                    onChanged: (value) {
                                      setState(
                                          () => _model.onlyOneWinner = value!);
                                    },
                                  ),
                                  RadioListTile<bool>(
                                    dense: true,
                                    title: const Text('Vários vencedores'),
                                    value: false,
                                    groupValue: _model.onlyOneWinner,
                                    onChanged: (value) {
                                      setState(
                                          () => _model.onlyOneWinner = value!);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ])),
                  if (_model.addedUsers.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: Text(
                          'Usuários Adicionados (${_model.addedUsers.length})',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Inter Tight',
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        children: _model.addedUsers.map((usuario) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Card(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.person,
                                        color: FlutterFlowTheme.of(context)
                                            .primary),
                                    const SizedBox(width: 8.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(usuario['nome']!,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium),
                                      ],
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          _model.addedUsers.remove(usuario);
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        final isValid =
                            _model.formKey.currentState?.validate() ?? false;

                        if (!isValid) {
                          return;
                        }

                        _model.playerIds = [];
                        _model.addedUsers.forEach((action) {
                          _model.playerIds.add(action['id']!);
                        });

                        if (_model.playerIds.length == 0) {
                          await Warning00ErrorUtil.showDialogMessageError(
                            context,
                            "Falha ao iniciar uma partida customizada",
                            "Deve adicionar participantes para seguir.",
                          );
                        }

                        await _model.createMatchAsync();
                      },
                      text: 'INCIAR PARTIDA',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 45.0,
                        color: Color(0xFFEC8D0D),
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Inter Tight',
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  )
                ]
              ]
                  .divide(const SizedBox(height: 5.0))
                  .addToStart(const SizedBox(height: 20.0)),
            ),
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
            // Filtra os usuários com base no texto digitado
            return usuarios.keys.where((id) =>
                id.contains(textEditingValue.text) ||
                usuarios[id]!
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
          },
          displayStringForOption: (option) => '${usuarios[option]}',
          onSelected: (selectedOption) {
            model.idTextController.text = selectedOption;
            onUsuarioSelecionado(selectedOption);
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            model.idTextController = textEditingController;
            model.idFocusNode = focusNode;
            return buildInput(
              context: context,
              label: 'Nº DE TELEFONE',
              controller: textEditingController,
              focusNode: focusNode,
              hintText: 'Ex.: 999999999',
              validator: (_) => null,
              lengthText: 14,
              keyboardType: TextInputType.number,
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            final text = model.idTextController.text;
            final hasNoMatch =
                options.isEmpty && text.isNotEmpty && text.length >= 9;
            return Align(
              alignment: Alignment.topCenter,
              child: Material(
                elevation: 4,
                child: Container(
                  width: 300,
                  constraints: BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return ListTile(
                              dense: true,
                              title: Text(usuarios[option] ?? option),
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                      if (hasNoMatch) const SizedBox(height: 4.0),
                      if (hasNoMatch)
                        Center(
                          child: IconButton(
                            icon: const Icon(Icons.person_add),
                            onPressed: () {
                              final id = model.idTextController?.text.trim();
                              if (id != null && id.isNotEmpty) {
                                onUsuarioSelecionado(id);
                              }
                            },
                          ),
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

  // Widget buildAutocompleteUsuario({
  //   required BuildContext context,
  //   required Tela15SalaCustomizadaViewModel model,
  //   required Map<String, String> usuarios,
  //   required void Function(String id) onUsuarioSelecionado,
  // }) {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       return Autocomplete<String>(
  //         optionsBuilder: (TextEditingValue textEditingValue) {
  //           if (textEditingValue.text.isEmpty)
  //             return const Iterable<String>.empty();
  //           return usuarios.keys.where((id) =>
  //               id.contains(textEditingValue.text) ||
  //               usuarios[id]!
  //                   .toLowerCase()
  //                   .contains(textEditingValue.text.toLowerCase()));
  //         },
  //         displayStringForOption: (option) => '${usuarios[option]}',
  //         onSelected: (selectedOption) {
  //           model.idTextController.text = selectedOption;
  //           onUsuarioSelecionado(selectedOption);
  //         },
  //         fieldViewBuilder:
  //             (context, textEditingController, focusNode, onFieldSubmitted) {
  //           model.idTextController = textEditingController;
  //           model.idFocusNode = focusNode;
  //           return buildInput(
  //             context: context,
  //             label: 'Nº DE TELEFONE',
  //             controller: textEditingController,
  //             focusNode: focusNode,
  //             hintText: 'Ex.: 999999999',
  //             validator: (_) => null,
  //             lengthText: 14,
  //             keyboardType: TextInputType.number,
  //           );
  //         },
  //         optionsViewBuilder: (context, onSelected, options) {
  //           return Align(
  //             alignment: Alignment.topCenter,
  //             child: Material(
  //               elevation: 4,
  //               child: Container(
  //                 width: 300,
  //                 constraints: BoxConstraints(
  //                   maxHeight: 200,
  //                 ),
  //                 child: ListView.builder(
  //                   padding: EdgeInsets.zero,
  //                   shrinkWrap: true,
  //                   itemCount: options.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     final String option = options.elementAt(index);
  //                     return ListTile(
  //                       dense: true,
  //                       title: Text(usuarios[option] ?? option),
  //                       onTap: () {
  //                         onSelected(option);
  //                       },
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // Widget buildBuscarUsuario({
  //   required BuildContext context,
  //   required Tela15SalaCustomizadaViewModel model,
  //   required void Function(String id, void Function(VoidCallback) setState)
  //       onUsuarioSelecionado,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         CompositedTransformTarget(
  //           link: phoneAutocompleteController.layerLink,
  //           child: buildInput(
  //             context: context,
  //             label: 'Nº DE TELEFONE JOGADOR',
  //             controller: model.idTextController!,
  //             focusNode: model.idFocusNode!,
  //             hintText: 'Ex.: 0000.0000.0000',
  //             validator: (_) => null,
  //             keyboardType: TextInputType.phone,
  //             onChanged: (value) {
  //               if (value.isNotEmpty) {
  //                 phoneAutocompleteController.showOverlay(
  //                   context,
  //                   model.idTextController!,
  //                   model.idFocusNode!,
  //                 );
  //               } else {
  //                 phoneAutocompleteController.hideOverlay();
  //               }
  //             },
  //             onTap: () {
  //               if (model.idTextController!.text.isNotEmpty) {
  //                 phoneAutocompleteController.showOverlay(
  //                   context,
  //                   model.idTextController!,
  //                   model.idFocusNode!,
  //                 );
  //               }
  //             },
  //             onEditingComplete: () {
  //               phoneAutocompleteController.hideOverlay();
  //             },
  //             onFieldSubmitted: (_) {
  //               phoneAutocompleteController.hideOverlay();
  //             },
  //           ),
  //         ),
  //         const SizedBox(height: 4.0),
  //         Center(
  //           child: IconButton(
  //             icon: const Icon(Icons.person_add),
  //             onPressed: () {
  //               phoneAutocompleteController.hideOverlay();
  //               final id = model.idTextController?.text.trim();
  //               if (id != null && id.isNotEmpty) {
  //                 onUsuarioSelecionado(id, setState);
  //               }
  //             },
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget buildInput({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    String? hintText,
    String? Function(String?)? validator,
    int lengthText = 55,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
    VoidCallback? onEditingComplete,
    VoidCallback? onTap,
    Function(String)? onFieldSubmitted,
  }) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: 300.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(-1.0, 0.0),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                child: Text(
                  label,
                  style: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ),
            TextFormField(
              controller: controller,
              focusNode: focusNode,
              obscureText: false,
              onTap: onTap,
              onFieldSubmitted: onFieldSubmitted,
              decoration: InputDecoration(
                hintText: hintText ?? '',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: FlutterFlowTheme.of(context).error),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: FlutterFlowTheme.of(context).error),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
              ),
              style: FlutterFlowTheme.of(context).bodyMedium,
              maxLength: lengthText,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: keyboardType,
              cursorColor: FlutterFlowTheme.of(context).primaryText,
              validator: validator,
              onChanged: onChanged, // Aqui
              onEditingComplete: onEditingComplete, // Aqui
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      required maxLength}) =>
                  null,
            ),
          ],
        ),
      ),
    );
  }
}
