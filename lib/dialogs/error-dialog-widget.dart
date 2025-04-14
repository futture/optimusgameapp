import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class ErrorDialogWidget extends StatefulWidget {
  final String message;
  final VoidCallback? onOk;

  const ErrorDialogWidget({
    super.key,
    required this.message,
    this.onOk,
  });

  @override
  _ErrorDialogWidgetState createState() => _ErrorDialogWidgetState();
}

class _ErrorDialogWidgetState extends State<ErrorDialogWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _circleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _iconScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _circleAnimation = Tween<double>(begin: 0.0, end: 120.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 320.0,
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 4),
              blurRadius: 20.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [ 
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _circleAnimation,
                  builder: (_, __) => Container(
                    width: _circleAnimation.value,
                    height: _circleAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent.withOpacity(0.2),
                    ),
                  ),
                ),
                // Ícone de erro animado
                ScaleTransition(
                  scale: _iconScaleAnimation,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red,
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.white,
                      size: 60.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
            ),
            const SizedBox(height: 24.0),
            FFButtonWidget(
              onPressed: () {
                if (widget.onOk != null) {
                  widget.onOk!();
                }
              },
              text: 'OK',
              options: FFButtonOptions(
                height: 50.0,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                color: Colors.redAccent,
                textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                elevation: 5.0,
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
