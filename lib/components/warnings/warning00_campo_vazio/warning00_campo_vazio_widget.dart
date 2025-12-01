import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';

class Warning00CampoVazioWidget extends StatefulWidget {
  final String titulo;
  final String detalhe;
  final int tempoExibicao;

  const Warning00CampoVazioWidget({
    super.key,
    required this.titulo,
    required this.detalhe,
    this.tempoExibicao = 3,
  });

  @override
  State<Warning00CampoVazioWidget> createState() =>
      _Warning00CampoVazioWidgetState();
}

class _Warning00CampoVazioWidgetState extends State<Warning00CampoVazioWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late AnimationController _progressController;
  late AudioPlayer _audioPlayer;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.tempoExibicao),
    )..addListener(() {
        setState(() {
          _progressValue = _progressController.value;
        });
        if (_progressController.isCompleted) {
          _fecharDialogo();
        }
      });

    _audioPlayer = AudioPlayer();
    //_tocarSomAlerta();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      _progressController.forward();
    });
  }

  // Future<void> _tocarSomAlerta() async {
  //   await _audioPlayer.play(AssetSource('sounds/alert.wav'));
  // }

  Future<void> _fecharDialogo() async {
    await _controller.reverse();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _progressController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: 320.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                FlutterFlowTheme.of(context).secondaryBackground,
                FlutterFlowTheme.of(context).primaryBackground,
              ],
            ),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 25.0,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red[700],
                        size: 48.0,
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat())
                        .shake(duration: 1000.ms, hz: 2),

                    const SizedBox(height: 20),

                    // Título
                    Text(
                      widget.titulo,
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Plus Jakarta Sans',
                            color: Colors.red[700],
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 12),

                    Text(
                      widget.detalhe,
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 15.0,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                    ).animate().fadeIn(delay: 100.ms),

                    const SizedBox(height: 24),

                    FFButtonWidget(
                      onPressed: _fecharDialogo,
                      text: 'ENTENDI',
                      options: FFButtonOptions(
                        width: 150,
                        height: 45,
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        color: const Color(0xFFEC8D0D),
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Inter Tight',
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                        elevation: 2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ).animate().scale(delay: 200.ms),
                  ],
                ),
              ),
              LinearProgressIndicator(
                value: _progressValue,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                minHeight: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Warning00ErrorUtil {
  static Future<void> showDialogMessageError(
    BuildContext? context,
    String title,
    String description, {
    int displayTime = 6,
  }) async {
    await showDialog(
      context: context!,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          child: Warning00CampoVazioWidget(
            titulo: title,
            detalhe: description,
            tempoExibicao: displayTime,
          ),
        );
      },
    );
  }
}
