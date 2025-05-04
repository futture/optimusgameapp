import 'package:projeto_game_quiz/core/models/responses/question_response.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            child: _buildGameContent(),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      automaticallyImplyLeading: false,
      leading: FlutterFlowIconButton(
        borderColor: Colors.transparent,
        borderRadius: 30.0,
        borderWidth: 1.0,
        buttonSize: 60.0,
        icon: FaIcon(
          FontAwesomeIcons.bars,
          color: FlutterFlowTheme.of(context).primaryText,
          size: 25.0,
        ),
        onPressed: () => print('IconButton pressed ...'),
      ),
      title: Text(
        'GAME QUIZ',
        style: FlutterFlowTheme.of(context).headlineSmall.override(
              fontFamily: 'Inter Tight',
              color: const Color(0xFFEC8D0D),
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
      ),
      centerTitle: true,
      elevation: 4.0,
    );
  }

  Widget _buildGameContent() {
    return Align(
      alignment: AlignmentDirectional.center,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 350.0,
          minHeight: 350.0,
          maxWidth: 1024.0,
          maxHeight: 1360.0,
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildScoreInfo(),
                _buildQuestionCard(),
                _buildTimer(),
                _buildAnswerOptions(),
              ].divide(const SizedBox(height: 10.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreInfo() {
    return Container(
      width: 350.0,
      height: 60.0,
      alignment: AlignmentDirectional.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildInfoPositionBox(
              'POSIÇÃO:',
              _model.currentposition,
              _model.matchInfo == null
                  ? 1
                  : _model.matchInfo!.room!.roomConfiguration!.numberOfPlayers),
          const SizedBox(width: 10.0),
          _buildInfoBox('PONTOS:', '${_model.points}'),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      width: 170.0,
      height: 45.0,
      decoration: BoxDecoration(
        color: const Color(0xFF01BF01),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: _getInfoTextStyle(),
            ),
            Text(
              value,
              style: _getInfoTextStyle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPositionBox(String label, int value, int totalPlayers) {
    Color getColorByRelativePosition(int pos, int total) {
      if (pos == 1) return const Color(0xFF01BF01);
      if (pos == 2) return const Color(0xFF7ED957);

      final percentile = pos / total;
      if (percentile <= 0.5) {
        return const Color(0xFFFFA500);
      } else {
        return const Color(0xFFFF4C4C);
      }
    }

    return Container(
      width: 170.0,
      height: 45.0,
      decoration: BoxDecoration(
        color: getColorByRelativePosition(value, totalPlayers),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: _getInfoTextStyle(),
            ),
            const SizedBox(width: 4),
            Text(
              value.toString(),
              style: _getInfoTextStyle(),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _getInfoTextStyle() {
    return FlutterFlowTheme.of(context).bodyMedium.override(
          fontFamily: 'Inter',
          color: Colors.black,
          fontSize: 16.0,
          letterSpacing: 0.0,
        );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: 350.0,
      height: 130.0,
      constraints: const BoxConstraints(
        minWidth: 300.0,
        minHeight: 130.0,
        maxWidth: 900.0,
        maxHeight: 250.0,
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
            spreadRadius: 5.0,
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          _buildQuestionCounter(),
          _buildQuestionText(),
        ],
      ),
    );
  }

  Widget _buildQuestionCounter() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
      child: Container(
        width: 320.0,
        height: 25.0,
        child: Row(
          children: [
            const Icon(Icons.quiz, size: 18.0),
            const SizedBox(width: 5.0),
            Text(
              '${_model.questionsAlreadyPresented}',
              style: _getBoldTextStyle(),
            ),
            Text('/', style: _getBoldTextStyle()),
            Text(
              '${_model.matchInfo!.room!.roomConfiguration!.numberOfQuestions}',
              style: _getBoldTextStyle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionText() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        child: Center(
          child: _model.isLoading
              ? const CircularProgressIndicator()
              : Text(
                  '${_model.question!.utterance}',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Inter Tight',
                        letterSpacing: 0.0,
                      ),
                ),
        ),
      ),
    );
  }

  TextStyle _getBoldTextStyle() {
    return FlutterFlowTheme.of(context).bodyMedium.override(
          fontFamily: 'Inter',
          color: FlutterFlowTheme.of(context).primaryText,
          fontSize: 16.0,
          letterSpacing: 0.0,
          fontWeight: FontWeight.bold,
        );
  }

  Widget _buildTimer() {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(40.0),
        border: Border.all(color: const Color(0xFFFF0505)),
      ),
      child: Center(
        child: Text(
          '${_model.secondsRemaining}s',
          style: TextStyle(
            fontSize: 20,
            color: _model.secondsRemaining <= 3 ? Colors.red : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerOptions() {
    return Container(
      width: 390.0,
      height: 420.0,
      child: Form(
        key: _model.formKey,
        child: Column(
          children: [
            if (_model.isLoading)
              const CircularProgressIndicator()
            else if (_model.question!.optionAnswers != null)
              ..._buildAnswerOptionList(),
            _buildValidateButton(),
          ].divide(const SizedBox(height: 20.0)),
        ),
      ),
    );
  }

  List<Widget> _buildAnswerOptionList() {
    return _model.question!.optionAnswers!
        .map((e) => _buildAnswerOption(e))
        .toList();
  }

  Widget _buildAnswerOption(OptionAnswersResponse e) {
    return Container(
      width: 350.0,
      height: 45.0,
      constraints: const BoxConstraints(
        minWidth: 350.0,
        minHeight: 45.0,
        maxWidth: 900.0,
        maxHeight: 100.0,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEC8D0D),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
            spreadRadius: 5.0,
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.codeOption, style: _getOptionCodeStyle()),
                Text(e.textOption, style: _getOptionTextStyle()),
                const Opacity(
                  opacity: 0.0,
                  child: FaIcon(FontAwesomeIcons.font, size: 24.0),
                ),
              ],
            ),
          ),
          _buildRadioButton(e),
        ],
      ),
    );
  }

  TextStyle _getOptionCodeStyle() {
    return FlutterFlowTheme.of(context).headlineSmall.override(
          fontFamily: 'Inter Tight',
          color: Colors.black,
          letterSpacing: 0.0,
        );
  }

  TextStyle _getOptionTextStyle() {
    return FlutterFlowTheme.of(context).titleLarge.override(
          fontFamily: 'Inter Tight',
          color: Colors.black,
          letterSpacing: 0.0,
        );
  }

  Widget _buildRadioButton(OptionAnswersResponse e) {
    return FlutterFlowRadioButton(
      options: [e.codeOption],
      onChanged: (val) {
        if (e.codeOption == val) {
          setState(() => _model.answerOptionId = e.id);
        }
        safeSetState(() {});
      },
      controller: _model.radioGroupValueController!,
      optionHeight: 60.0,
      optionWidth: 350.0,
      textStyle: FlutterFlowTheme.of(context).labelMedium.override(
            fontFamily: 'Inter',
            letterSpacing: 0.0,
          ),
      selectedTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Inter',
            color: const Color(0x0014181B),
            fontSize: 16.0,
            letterSpacing: 0.0,
          ),
      textPadding: const EdgeInsetsDirectional.fromSTEB(250.0, 0.0, 0.0, 0.0),
      buttonPosition: RadioButtonPosition.right,
      radioButtonColor: const Color(0xFF00C90C),
      inactiveRadioButtonColor: const Color(0xFF14181B),
    );
  }

  Widget _buildValidateButton() {
    return FFButtonWidget(
      onPressed: _model.isButtonDisabled ? null : _handleValidation,
      text: _model.isLoading ? 'Validando...' : 'Validar',
      icon: _model.isLoading
          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
          : null,
      options: FFButtonOptions(
        width: 350.0,
        height: 45.0,
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        color: const Color(0xFF01BF01),
        textStyle: FlutterFlowTheme.of(context).titleMedium.override(
              fontFamily: 'Inter Tight',
              color: Colors.black,
              letterSpacing: 0.0,
              fontWeight: FontWeight.normal,
            ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Future<void> _handleValidation() async {
    if (_model.answerOptionId.isEmpty) return;

    setState(() {
      _model.isButtonDisabled = true;
      _model.isLoading = true;
    });

    _model.cancelarTimers();
    _model.showDialogWaitingPlayer(context);
    await _model.sendUserResponseAsync(_model.answerOptionId, setState);
  }
}
