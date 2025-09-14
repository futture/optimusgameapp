import 'package:projeto_game_quiz/core/models/responses/question_response.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'tela06_salade_jogo_model.dart';
export 'tela06_salade_jogo_model.dart';

class Tela06SaladeJogoWidget extends StatefulWidget {
  final dynamic matchInfo;
  final bool? recebeuNotificaca;
  final int? playersConnected;
  final QuestionResponse? nextQuestion;

  const Tela06SaladeJogoWidget({
    super.key,
    this.matchInfo,
    this.recebeuNotificaca,
    this.playersConnected,
    this.nextQuestion,
  });

  static const String routeName = 'Tela06SaladeJogo';
  static const String routePath = '/tela06SaladeJogo';

  @override
  State<Tela06SaladeJogoWidget> createState() => _Tela06SaladeJogoWidgetState();
}

class _Tela06SaladeJogoWidgetState extends State<Tela06SaladeJogoWidget>
    with WidgetsBindingObserver {
  late Tela06SaladeJogoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeModel();
  }

  void _initializeModel() {
    _model = createModel(context, () => Tela06SaladeJogoModel());
    _model.radioGroupValueController = FormFieldController<String>(null);

    if (widget.matchInfo != null) {
      _model.matchInfo = widget.matchInfo;
      _model.playersConnected = widget.playersConnected;
      _model.getUserIdAsync();

      if (widget.recebeuNotificaca == null) {
        //_model.getMatchStartNoticeAsync(setState);
      }

      _model.setupGame(safeSetState, widget.nextQuestion);
    }
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _model.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      //_model.inactivatePlayerInMatchAsync();
      print("[INFO] - Aplicação em pausa");
    }
    if (state == AppLifecycleState.paused) {
      Future.delayed(const Duration(seconds: 5), () {
        if (WidgetsBinding.instance.lifecycleState ==
            AppLifecycleState.paused) {
          //_model.inactivatePlayerInMatchAsync();
          print("[INFO] - Aplicação em pausa");
        }
      });
    }
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
          appBar: _buildAppBar(),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Adiciona padding extra apenas para dispositivos pequenos
                final bottomPadding = constraints.maxHeight < 600 ? 16.0 : 0.0;
                return Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: _buildGameContent(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return WillPopScope(
  //     onWillPop: () async => false,
  //     child: GestureDetector(
  //       onTap: () => FocusScope.of(context).unfocus(),
  //       child: Scaffold(
  //         key: scaffoldKey,
  //         backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
  //         appBar: _buildAppBar(),
  //         body: SafeArea(
  //           child: _buildGameContent(),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      automaticallyImplyLeading: false,
      leading: FlutterFlowIconButton(
        borderColor: Colors.transparent,
        borderRadius: 30.0,
        borderWidth: 1.0,
        buttonSize: 60.0,
        icon: Icon(
          Icons.menu,
          color: FlutterFlowTheme.of(context).primaryText,
          size: 30.0,
        ),
        onPressed: () => print('Menu pressed'),
      ),
      title: Text(
        'GAME QUIZ',
        style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Inter Tight',
              color: const Color(0xFFEC8D0D),
              letterSpacing: 0.0,
              fontWeight: FontWeight.bold,
            ),
      ),
      centerTitle: true,
      elevation: 2.0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            child: _buildTimer(),
          ),
        ),
      ],
    );
  }

  // Widget _buildGameContent() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: Column(
  //       children: [
  //         _buildScoreInfo(),
  //         const SizedBox(height: 24.0),
  //         Expanded(
  //           child: SingleChildScrollView(
  //             physics: const BouncingScrollPhysics(),
  //             child: Column(
  //               children: [
  //                 _buildQuestionCard(),
  //                 const SizedBox(height: 24.0),
  //                 _buildAnswerOptions(),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildScoreInfo() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF01BF01),
              FlutterFlowTheme.of(context).secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoItem(
              'POSIÇÃO',
              '${_model.currentposition}',
              Icons.emoji_events,
            ),
            _buildInfoItem(
              'PONTOS',
              '${_model.points}',
              Icons.star,
            ),
            _buildInfoItem(
              'JOGADORES',
              '${_model.matchInfo!.room!.roomConfiguration!.numberOfPlayers}',
              Icons.people,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 24.0),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 12.0,
                letterSpacing: 0.0,
              ),
        ),
        Text(
          value,
          style: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: 'Inter Tight',
                color: Colors.white,
                fontSize: 18.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pergunta ${_model.questionsAlreadyPresented}',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${_model.matchInfo?.room?.roomConfiguration?.numberOfQuestions ?? 0}',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: _model.questionsAlreadyPresented /
                  (_model.matchInfo?.room?.roomConfiguration
                          ?.numberOfQuestions ??
                      1),
              backgroundColor: FlutterFlowTheme.of(context).alternate,
              color: const Color(0xFF01BF01),
              minHeight: 8.0,
              borderRadius: BorderRadius.circular(4.0),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: _model.isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        '${_model.question?.utterance}',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: 'Inter Tight',
                              fontSize: 20.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: _model.secondsRemaining <= 5
            ? Colors.red[400]
            : FlutterFlowTheme.of(context).secondaryBackground,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Center(
        child: Text(
          '${_model.secondsRemaining}',
          style: TextStyle(
            fontSize: 20.0,
            color: _model.secondsRemaining <= 5 ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGameContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildScoreInfo(),
          const SizedBox(height: 16.0),
          _buildQuestionCard(),
          const SizedBox(height: 16.0),
          // Área de respostas com scroll
          Expanded(
            child: _buildAnswerOptionsWithScroll(),
          ),
          // Botão fixo na parte inferior
          _buildValidateButton(),
          const SizedBox(height: 16.0), // Espaço extra no final
        ],
      ),
    );
  }

  // Widget _buildGameContent() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: Column(
  //       children: [
  //         _buildScoreInfo(),
  //         const SizedBox(height: 24.0),
  //         Column(
  //           children: [
  //             _buildQuestionCard(),
  //             const SizedBox(height: 24.0),
  //             _buildAnswerOptions(),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildAnswerOptions() {
  //   return Column(
  //     children: [
  //       if (_model.isLoading)
  //         const Center(child: CircularProgressIndicator())
  //       else if (_model.question?.optionAnswers != null)
  //         ..._buildAnswerOptionList(),
  //     ],
  //   );
  // }

  // Widget _buildAnswerOptionsWithScroll() {
  //   return SingleChildScrollView(
  //     physics: const BouncingScrollPhysics(),
  //      padding: const EdgeInsets.symmetric(vertical: 8.0), // Adicionado padding vertical

  //     child: Column(
  //       children: [
  //         if (_model.isLoading)
  //           const Center(child: CircularProgressIndicator())
  //         else if (_model.question?.optionAnswers != null)
  //           ..._buildAnswerOptionList(),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildAnswerOptionsWithScroll() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 8.0), // Adicionado padding vertical
        child: Column(
          children: [
            if (_model.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_model.question?.optionAnswers != null)
              ..._buildAnswerOptionList(),
          ],
        ),
      ),
    );
  }
  // Widget _buildAnswerOptions() {
  //   return Column(
  //     children: [
  //       if (_model.isLoading)
  //         const CircularProgressIndicator()
  //       else if (_model.question?.optionAnswers != null)
  //         Container(
  //           height: MediaQuery.of(context).size.height * 0.5,
  //           child: SingleChildScrollView(
  //             physics: const BouncingScrollPhysics(),
  //             child: Column(
  //               children: _buildAnswerOptionList(),
  //             ),
  //           ),
  //         ),
  //       const SizedBox(height: 16.0),
  //       _buildValidateButton(),
  //     ],
  //   );
  // }

  List<Widget> _buildAnswerOptionList() {
    return _model.question!.optionAnswers!
        .map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildAnswerOption(e),
            ))
        .toList();
  }

  Widget _buildAnswerOption(OptionAnswersResponse e) {
    return InkWell(
      onTap: () {
        setState(() => _model.answerOptionId = e.id);
        _model.radioGroupValueController?.value = e.codeOption;
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        constraints:
            const BoxConstraints(minHeight: 48.0), // Reduzido de 60.0 para 48.0
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _model.answerOptionId == e.id
                ? [
                    const Color(0xFF00B80E),
                    FlutterFlowTheme.of(context).secondary
                  ]
                : [
                    const Color(0xFFEC8D0D),
                    FlutterFlowTheme.of(context).secondary
                  ],
          ),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: _model.answerOptionId == e.id
                ? FlutterFlowTheme.of(context).primary
                : Colors.transparent,
            width: 2.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 12.0, vertical: 8.0), // Reduzido o padding
        child: Row(
          children: [
            Container(
              width: 24.0, // Reduzido de 30.0
              height: 24.0, // Reduzido de 30.0
              decoration: BoxDecoration(
                color: _model.answerOptionId == e.id
                    ? Colors.white
                    : FlutterFlowTheme.of(context).primaryBackground,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  e.codeOption,
                  style: TextStyle(
                    color: _model.answerOptionId == e.id
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12.0, // Reduzido o tamanho da fonte
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12.0), // Reduzido de 16.0
            Expanded(
              child: Text(
                e.textOption,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: _model.answerOptionId == e.id
                          ? Colors.white
                          : Colors.black,
                      fontSize: 14.0, // Reduzido de 16.0
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            Radio<String>(
              value: e.codeOption,
              groupValue: _model.radioGroupValueController?.value,
              onChanged: (val) {
                setState(() => _model.answerOptionId = e.id);
                _model.radioGroupValueController?.value = val;
              },
              visualDensity:
                  VisualDensity.compact, // Adicionado para reduzir tamanho
              materialTapTargetSize: MaterialTapTargetSize
                  .shrinkWrap, // Adicionado para reduzir área de toque
            ),
          ],
        ),
      ),
    );
  }
  // Widget _buildAnswerOption(OptionAnswersResponse e) {
  //   return InkWell(
  //     onTap: () {
  //       setState(() => _model.answerOptionId = e.id);
  //       _model.radioGroupValueController?.value = e.codeOption;
  //     },
  //     borderRadius: BorderRadius.circular(12.0),
  //     child: Container(
  //       width: double.infinity,
  //       constraints: const BoxConstraints(minHeight: 60.0),
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: _model.answerOptionId == e.id
  //               ? [
  //                   const Color(0xFF00B80E),
  //                   FlutterFlowTheme.of(context).secondary
  //                 ]
  //               : [
  //                   const Color(0xFFEC8D0D),
  //                   FlutterFlowTheme.of(context).secondary
  //                 ],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //         borderRadius: BorderRadius.circular(12.0),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.1),
  //             blurRadius: 4.0,
  //             offset: const Offset(0, 2),
  //           )
  //         ],
  //         border: Border.all(
  //           color: _model.answerOptionId == e.id
  //               ? FlutterFlowTheme.of(context).primary
  //               : Colors.transparent,
  //           width: 2.0,
  //         ),
  //       ),
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  //       child: Row(
  //         children: [
  //           Container(
  //             width: 30.0,
  //             height: 30.0,
  //             decoration: BoxDecoration(
  //               color: _model.answerOptionId == e.id
  //                   ? Colors.white
  //                   : FlutterFlowTheme.of(context).primaryBackground,
  //               shape: BoxShape.circle,
  //             ),
  //             child: Center(
  //               child: Text(
  //                 e.codeOption,
  //                 style: TextStyle(
  //                   color: _model.answerOptionId == e.id
  //                       ? FlutterFlowTheme.of(context).primary
  //                       : FlutterFlowTheme.of(context).secondaryText,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(width: 16.0),
  //           Expanded(
  //             child: Text(
  //               e.textOption,
  //               style: FlutterFlowTheme.of(context).bodyMedium.override(
  //                     fontFamily: 'Inter',
  //                     color: _model.answerOptionId == e.id
  //                         ? Colors.white
  //                         : Colors.black,
  //                     fontSize: 16.0,
  //                     letterSpacing: 0.0,
  //                   ),
  //             ),
  //           ),
  //           Radio<String>(
  //             value: e.codeOption,
  //             groupValue: _model.radioGroupValueController?.value,
  //             onChanged: (val) {
  //               setState(() => _model.answerOptionId = e.id);
  //               _model.radioGroupValueController?.value = val;
  //             },
  //             activeColor: Colors.white,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildValidateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _model.isButtonDisabled || _model.answerOptionId.isEmpty
            ? null
            : _handleValidation,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF01BF01),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4.0,
        ),
        child: _model.isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Text(
                    'Validando...',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : const Text(
                'VALIDAR RESPOSTA',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
  // Widget _buildValidateButton() {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: ElevatedButton(
  //       onPressed: _model.isButtonDisabled || _model.answerOptionId.isEmpty
  //           ? null
  //           : _handleValidation,
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: const Color(0xFF01BF01),
  //         padding: const EdgeInsets.symmetric(vertical: 16.0),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12.0),
  //         ),
  //         elevation: 4.0,
  //       ),
  //       child: _model.isLoading
  //           ? const Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 SizedBox(
  //                   width: 20.0,
  //                   height: 20.0,
  //                   child: CircularProgressIndicator(
  //                     color: Colors.white,
  //                     strokeWidth: 2.0,
  //                   ),
  //                 ),
  //                 SizedBox(width: 12.0),
  //                 Text(
  //                   'Validando...',
  //                   style: TextStyle(
  //                     fontSize: 16.0,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ],
  //             )
  //           : const Text(
  //               'VALIDAR RESPOSTA',
  //               style: TextStyle(
  //                 fontSize: 16.0,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white,
  //               ),
  //             ),
  //     ),
  //   );
  // }

  Future<void> _handleValidation() async {
    if (_model.answerOptionId.isEmpty) return;

    setState(() {
      _model.isButtonDisabled = true;
      _model.isLoading = true;
    });

    _model.cancelarTimers();
    _model.showDialogWaitingPlayer(context, setState);
    await _model.sendUserResponseAsync(_model.answerOptionId, setState);
  }
}
