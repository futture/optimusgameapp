import 'dart:ui';
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class SuccessDialogWidget extends StatefulWidget {
  final String message;
  final VoidCallback? onOk;

  const SuccessDialogWidget({
    super.key,
    required this.message,
    this.onOk,
  });

  @override
  State<SuccessDialogWidget> createState() => _SuccessDialogWidgetState();
}

class _SuccessDialogWidgetState extends State<SuccessDialogWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    const successGreen = Color(0xFF4CAF50); // Verde sucesso

    return Center(
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 32),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: successGreen.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 72,
                        color: successGreen,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Sucesso!',
                        style: theme.titleLarge.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: theme.bodyMedium.copyWith(
                          fontSize: 16,
                          color: theme.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onOk?.call();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: successGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
