import 'dart:math';

import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;
  late AnimationController _mainAnimationController;
  late AnimationController _loadingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoGlowAnimation;
  late Animation<double> _mathRotationAnimation;
  late Animation<double> _loadingProgressAnimation;
  late Animation<double> _pulseAnimation;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // Controlador principal para animações visuais
    _mainAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Animações sequenciadas - CORRIGIDAS para não usar TweenSequence
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOutCubic),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _logoGlowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
      ),
    );

    _mathRotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: Curves.linear,
      ),
    );

    // Animação de pulso contínuo usando um controlador separado
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOutSine),
      ),
    );

    // Controlador para loading (5 segundos)
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _loadingProgressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: Curves.easeInOutCubic,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          context.pushReplacementNamed(
            Tela00LoginWidget.routeName,
            extra: <String, dynamic>{
              kTransitionInfoKey: TransitionInfo(
                hasTransition: true,
                transitionType: PageTransitionType.scale,
                duration: const Duration(milliseconds: 1000),
              ),
            },
          );
        }
      });

    // Iniciar animações
    Future.delayed(const Duration(milliseconds: 200), () {
      _mainAnimationController.forward().then((_) {
        // Após animação principal, faz pulso contínuo
        _mainAnimationController.repeat(reverse: true);
      });
      _loadingController.forward();
    });
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _loadingController.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF0A1028),
      body: SafeArea(
        top: true,
        child: AnimatedBuilder(
          animation: Listenable.merge([_mainAnimationController, _loadingController]),
          builder: (context, child) {
            // Calcula valores de animação seguros
            final mainValue = _mainAnimationController.value;
            final fadeValue = _fadeAnimation.value;
            final scaleValue = _logoScaleAnimation.value;
            final glowValue = _logoGlowAnimation.value;
            final rotationValue = _mathRotationAnimation.value;
            final pulseValue = _pulseAnimation.value;
            final progressValue = _loadingProgressAnimation.value;
            
            return Stack(
              children: [
                // Fundo dinâmico com elementos matemáticos
                Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0, -0.3),
                      radius: 1.5,
                      colors: [
                        Color(0xFF1A237E),
                        Color(0xFF0A1028),
                        Color(0xFF000000),
                      ],
                      stops: [0.0, 0.6, 1.0],
                    ),
                  ),
                  child: CustomPaint(
                    painter: _MathElementsPainter(
                      rotation: rotationValue % (2 * pi),
                      pulse: pulseValue,
                      time: mainValue * 3 * pi,
                    ),
                    size: MediaQuery.of(context).size,
                  ),
                ),

                // Conteúdo principal
                Center(
                  child: Opacity(
                    opacity: fadeValue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo profissional e visível
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Efeito de glow dinâmico
                            Transform.scale(
                              scale: scaleValue * 1.5,
                              child: Container(
                                width: 250,
                                height: 250,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color(0xFF00E5FF).withOpacity(glowValue * 0.3),
                                      const Color(0xFF2979FF).withOpacity(glowValue * 0.2),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  ),
                                ),
                              ),
                            ),

                            // Anel giratório
                            Transform.rotate(
                              angle: rotationValue % (2 * pi),
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF00E5FF).withOpacity(0.5),
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),

                            // Logo principal
                            Transform.scale(
                              scale: scaleValue,
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF00E5FF),
                                      Color(0xFF2979FF),
                                      Color(0xFF7C4DFF),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00E5FF).withOpacity(glowValue * 0.6),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFF7C4DFF).withOpacity(glowValue * 0.4),
                                      blurRadius: 60,
                                      spreadRadius: 20,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: Image.asset(
                                      'assets/images/1000171765.jpg',
                                      width: 140,
                                      height: 140,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withOpacity(0.1),
                                          ),
                                          child: const Icon(
                                            Icons.calculate_rounded,
                                            size: 80,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Título principal
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [
                                const Color(0xFF00E5FF),
                                const Color(0xFF2979FF),
                                const Color(0xFF7C4DFF),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds);
                          },
                          child: Text(
                            'MATH GENIUS',
                            style: TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                              height: 1.1,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.8),
                                  blurRadius: 20,
                                  offset: const Offset(3, 3),
                                ),
                                Shadow(
                                  color: const Color(0xFF00E5FF).withOpacity(0.5),
                                  blurRadius: 30,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Subtítulo
                        AnimatedOpacity(
                          opacity: fadeValue,
                          duration: const Duration(milliseconds: 500),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Domine a ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                TextSpan(
                                  text: 'ARTE DOS NÚMEROS',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: const Color(0xFF00E5FF),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                TextSpan(
                                  text: ' com desafios inteligentes',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Loading premium
                        Column(
                          children: [
                            // Indicador circular premium
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: Stack(
                                children: [
                                  // Fundo
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                  
                                  // Progresso
                                  Transform.rotate(
                                    angle: -pi / 2,
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        value: progressValue,
                                        strokeWidth: 4,
                                        backgroundColor: Colors.transparent,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          const Color(0xFF00E5FF).withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // Símbolo central
                                  Center(
                                    child: Transform.scale(
                                      scale: 0.8 + 0.2 * sin(mainValue * 2 * pi),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF00E5FF),
                                              Color(0xFF2979FF),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF00E5FF).withOpacity(0.5),
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            _getMathSymbol(progressValue),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 30),
                            
                            // Texto e barra de progresso
                            Column(
                              children: [
                                // Texto de status
                                SizedBox(
                                  width: 280,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'CARREGANDO',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.7),
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      Text(
                                        '${(progressValue * 100).toInt()}%',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: const Color(0xFF00E5FF),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 12),
                                
                                // Barra de progresso premium
                                Container(
                                  width: 280,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Fundo
                                      Container(
                                        width: 280,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.05),
                                              Colors.white.withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                      ),
                                      
                                      // Progresso
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        width: 280 * progressValue,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF00E5FF),
                                              Color(0xFF2979FF),
                                              Color(0xFF7C4DFF),
                                            ],
                                            stops: [0.0, 0.5, 1.0],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF00E5FF).withOpacity(0.5),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Ponto de destaque
                                      Positioned(
                                        left: 280 * progressValue - 8,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: const LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Color(0xFF00E5FF),
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF00E5FF).withOpacity(0.8),
                                                blurRadius: 10,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Texto descritivo
                                Text(
                                  _getLoadingDescription(progressValue),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.6),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ========== FUNÇÕES AUXILIARES ==========

  String _getMathSymbol(double progress) {
    final symbols = ['+', '−', '×', '÷', '='];
    final index = (progress * (symbols.length - 1)).round();
    return symbols[index];
  }

  String _getLoadingDescription(double progress) {
    if (progress < 0.25) return "Preparando desafios de adição...";
    if (progress < 0.5) return "Carregando problemas de subtração...";
    if (progress < 0.75) return "Configurando multiplicações...";
    if (progress < 0.95) return "Finalizando divisões...";
    return "Sistema matemático pronto!";
  }
}

// ========== PAINTER SIMPLIFICADO ==========
class _MathElementsPainter extends CustomPainter {
  final double rotation;
  final double pulse;
  final double time;

  _MathElementsPainter({
    required this.rotation,
    required this.pulse,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Anéis concêntricos
    for (int i = 1; i <= 5; i++) {
      final radius = 80.0 * i;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = const Color(0xFF00E5FF).withOpacity(0.05 + 0.02 * i);
      
      canvas.drawCircle(center, radius * pulse, paint);
    }

    // Pontos flutuantes
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF00E5FF).withOpacity(0.2);

    for (int i = 0; i < 20; i++) {
      final angle = rotation + i * (2 * pi / 20);
      final distance = 150.0 + 50.0 * sin(time + i);
      final x = center.dx + cos(angle) * distance;
      final y = center.dy + sin(angle) * distance;
      
      final dotSize = 8.0 + 6.0 * sin(time * 2 + i);
      canvas.drawCircle(Offset(x, y), dotSize, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MathElementsPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
           oldDelegate.pulse != pulse ||
           oldDelegate.time != time;
  }
}