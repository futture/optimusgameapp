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

  // Cores uniformizadas com a tela de login
  final Color _primaryColor = Color(0xFFEC8D0D); // Laranja principal
  final Color _primaryLight = Color(0xFFFDE68A); // Laranja claro
  final Color _primaryDark = Color(0xFFD97706); // Laranja escuro
  final Color _backgroundColor = Color(0xFFFAFAFA); // Fundo claro
  final Color _surfaceColor = Color(0xFFFFFFFF); // Superfície branca
  final Color _textPrimary = Color(0xFF1F2937); // Texto escuro
  final Color _textSecondary = Color(0xFF6B7280); // Texto secundário
  final Color _borderColor = Color(0xFFE5E7EB); // Borda
  final Color _successColor = Color(0xFF10B981); // Verde sucesso

  // Gradiente uniformizado com login
  final LinearGradient _primaryGradient = LinearGradient(
    colors: [
      Color(0xFFEC8D0D), // Laranja principal
      Color(0xFFF59E0B), // Laranja mais claro
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradiente para elementos matemáticos
  final LinearGradient _mathGradient = LinearGradient(
    colors: [
      Color(0xFFEC8D0D), // Laranja principal
      Color(0xFFF59E0B), // Laranja claro
      Color(0xFFFBBF24), // Laranja amarelado
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

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

    // Animações sequenciadas
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

    // Animação de pulso contínuo
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
                transitionType: PageTransitionType.fade,
                duration: const Duration(milliseconds: 800),
              ),
            },
          );
        }
      });

    // Iniciar animações
    Future.delayed(const Duration(milliseconds: 200), () {
      _mainAnimationController.forward().then((_) {
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
      backgroundColor: _backgroundColor, // Usando a mesma cor de fundo do login
      body: SafeArea(
        top: true,
        child: AnimatedBuilder(
          animation:
              Listenable.merge([_mainAnimationController, _loadingController]),
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
                // Fundo dinâmico com elementos matemáticos - NOVO ESTILO
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _primaryColor.withOpacity(0.08),
                        _backgroundColor.withOpacity(0.02),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                  child: CustomPaint(
                    painter: _MathElementsPainter(
                      rotation: rotationValue % (2 * pi),
                      pulse: pulseValue,
                      time: mainValue * 3 * pi,
                      primaryColor: _primaryColor,
                      primaryLight: _primaryLight,
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
                        // Logo profissional em estilo laranja
                        _buildLaranjaLogo(
                          scaleValue: scaleValue,
                          glowValue: glowValue,
                          rotationValue: rotationValue,
                          pulseValue: pulseValue,
                        ),

                        const SizedBox(height: 40),

                        // Título principal com gradiente laranja
                        _buildLaranjaTitle(),

                        const SizedBox(height: 12),

                        // Subtítulo
                        _buildLaranjaSubtitle(fadeValue),

                        const SizedBox(height: 50),

                        // Loading premium em estilo laranja
                        _buildLaranjaLoadingIndicator(
                          progressValue: progressValue,
                          mainValue: mainValue,
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

  // ========== MÉTODOS DE CONSTRUÇÃO COM TEMÁTICA LARANJA ==========

  Widget _buildLaranjaLogo({
    required double scaleValue,
    required double glowValue,
    required double rotationValue,
    required double pulseValue,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow dinâmico em laranja
        Transform.scale(
          scale: scaleValue * 1.5,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _primaryColor.withOpacity(glowValue * 0.3),
                  _primaryLight.withOpacity(glowValue * 0.2),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // Anel giratório laranja
        Transform.rotate(
          angle: rotationValue % (2 * pi),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _primaryColor.withOpacity(0.5),
                width: 3,
              ),
            ),
          ),
        ),

        // Logo principal - Design premium em laranja
        Transform.scale(
          scale: scaleValue,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(glowValue * 0.6),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: _primaryDark.withOpacity(glowValue * 0.4),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ],
            ),
            child: Center(
              child: Stack(
                children: [
                  // Símbolo matemático central (desenho vetorial em laranja) - AUMENTADO
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _MathLogoPainter(
                        scale: scaleValue,
                        pulse: pulseValue,
                        primaryColor: _primaryColor,
                      ),
                    ),
                  ),

                  // Container para a imagem com borda laranja - CORRIGIDO
                  Container(
                    width: 180, // MESMO tamanho do container pai
                    height: 180, // MESMO tamanho do container pai
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _surfaceColor.withOpacity(0.9),
                      border: Border.all(
                        color: _primaryColor.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90), // Metade de 180
                      child: Image.asset(
                        'assets/images/optimuslogo.png',
                        width: 180, // MESMO tamanho do container
                        height: 180, // MESMO tamanho do container
                        fit: BoxFit.cover, // COVER para preencher completamente
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: _primaryGradient,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calculate_rounded,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'MATH',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLaranjaTitle() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return _primaryGradient.createShader(bounds);
      },
      child: Text(
        'OPTIMUS GAME',
        style: TextStyle(
          fontSize: 40,
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
              color: _primaryColor.withOpacity(0.5),
              blurRadius: 30,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaranjaSubtitle(double fadeValue) {
    return AnimatedOpacity(
      opacity: fadeValue,
      duration: const Duration(milliseconds: 500),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Desafie sua ',
              style: TextStyle(
                fontSize: 16,
                color: _textSecondary,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.0,
              ),
            ),
            TextSpan(
              text: 'INTELIGÊNCIA MATEMÁTICA',
              style: TextStyle(
                fontSize: 16,
                color: _primaryColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            TextSpan(
              text: ' agora!',
              style: TextStyle(
                fontSize: 16,
                color: _textSecondary,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaranjaLoadingIndicator({
    required double progressValue,
    required double mainValue,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _borderColor,
                    width: 3,
                  ),
                ),
              ),

              // Progresso com gradiente laranja
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
                      _primaryColor.withOpacity(0.8),
                    ),
                  ),
                ),
              ),

              // Símbolo central pulsante - AUMENTADO
              Center(
                child: Transform.scale(
                  scale: 0.9 +
                      0.3 *
                          sin(mainValue * 2 * pi), // AUMENTADO de 0.2 para 0.3
                  child: Container(
                    width: 50, // AUMENTADO de 40 para 50
                    height: 50, // AUMENTADO de 40 para 50
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.5),
                          blurRadius: 15, // AUMENTADO de 10 para 15
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _getMathSymbol(progressValue),
                        style: TextStyle(
                          fontSize: 24, // AUMENTADO de 20 para 24
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
                      color: _textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    '${(progressValue * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 16,
                      color: _primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Barra de progresso premium em laranja
            Container(
              width: 280,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: _borderColor,
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
                          _borderColor.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),

                  // Progresso com gradiente laranja
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 280 * progressValue,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: _primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),

                  // Ponto de destaque
                  if (progressValue > 0.02)
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
                              Color(0xFFEC8D0D),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.8),
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
                color: _textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ========== FUNÇÕES AUXILIARES ==========

  String _getMathSymbol(double progress) {
    final symbols = ['+', '−', '×', '÷', '='];
    final index = (progress * (symbols.length - 1)).round();
    return symbols[index];
  }

  String _getLoadingDescription(double progress) {
    if (progress < 0.25) return "Inicializando desafios matemáticos...";
    if (progress < 0.5) return "Carregando problemas avançados...";
    if (progress < 0.75) return "Preparando sistema de pontuação...";
    if (progress < 0.95) return "Finalizando configurações...";
    return "Pronto para o desafio!";
  }
}

// ========== PAINTER PARA LOGO MATEMÁTICO EM LARANJA ==========
// ATUALIZADO: Símbolos matemáticos aumentados para melhor visibilidade
class _MathLogoPainter extends CustomPainter {
  final double scale;
  final double pulse;
  final Color primaryColor;

  _MathLogoPainter({
    required this.scale,
    required this.pulse,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.8;

    // Símbolo matemático em laranja - AUMENTADO
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0 * scale // AUMENTADO de 4.0 para 6.0
      ..color = primaryColor
          .withOpacity(0.3 * pulse); // AUMENTADO opacidade de 0.2 para 0.3

    // Símbolo de infinito matemático - AUMENTADO
    final path = Path();

    // Primeira curva do infinito - AUMENTADA
    path.moveTo(
        center.dx - radius * 0.7, center.dy); // AUMENTADO de 0.6 para 0.7
    path.cubicTo(
      center.dx - radius * 0.9,
      center.dy - radius * 0.5, // AUMENTADO de 0.8 e 0.4 para 0.9 e 0.5
      center.dx, center.dy - radius * 0.5, // AUMENTADO de 0.4 para 0.5
      center.dx, center.dy,
    );

    // Segunda curva do infinito - AUMENTADA
    path.cubicTo(
      center.dx, center.dy + radius * 0.5, // AUMENTADO de 0.4 para 0.5
      center.dx + radius * 0.9,
      center.dy + radius * 0.5, // AUMENTADO de 0.8 e 0.4 para 0.9 e 0.5
      center.dx + radius * 0.7, center.dy, // AUMENTADO de 0.6 para 0.7
    );

    // Volta para completar - AUMENTADA
    path.cubicTo(
      center.dx + radius * 0.9,
      center.dy - radius * 0.5, // AUMENTADO de 0.8 e 0.4 para 0.9 e 0.5
      center.dx, center.dy - radius * 0.5, // AUMENTADO de 0.4 para 0.5
      center.dx, center.dy,
    );

    canvas.drawPath(path, paint);

    // Adicionar símbolos matemáticos adicionais para mais visibilidade
    final additionalPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0 * scale
      ..color = primaryColor.withOpacity(0.4 * pulse);

    // Símbolo de soma (+) nos cantos - AUMENTADO
    final crossSize = radius * 0.2; // AUMENTADO tamanho

    // Canto superior esquerdo
    canvas.drawLine(
      Offset(
          center.dx - radius * 0.3 - crossSize / 2, center.dy - radius * 0.3),
      Offset(
          center.dx - radius * 0.3 + crossSize / 2, center.dy - radius * 0.3),
      additionalPaint,
    );
    canvas.drawLine(
      Offset(
          center.dx - radius * 0.3, center.dy - radius * 0.3 - crossSize / 2),
      Offset(
          center.dx - radius * 0.3, center.dy - radius * 0.3 + crossSize / 2),
      additionalPaint,
    );

    // Canto inferior direito
    canvas.drawLine(
      Offset(
          center.dx + radius * 0.3 - crossSize / 2, center.dy + radius * 0.3),
      Offset(
          center.dx + radius * 0.3 + crossSize / 2, center.dy + radius * 0.3),
      additionalPaint,
    );
    canvas.drawLine(
      Offset(
          center.dx + radius * 0.3, center.dy + radius * 0.3 - crossSize / 2),
      Offset(
          center.dx + radius * 0.3, center.dy + radius * 0.3 + crossSize / 2),
      additionalPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MathLogoPainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.pulse != pulse ||
        oldDelegate.primaryColor != primaryColor;
  }
}

// ========== PAINTER PARA ELEMENTOS DO FUNDO EM LARANJA ==========
// ATUALIZADO: Elementos de fundo aumentados para melhor visibilidade
class _MathElementsPainter extends CustomPainter {
  final double rotation;
  final double pulse;
  final double time;
  final Color primaryColor;
  final Color primaryLight;

  _MathElementsPainter({
    required this.rotation,
    required this.pulse,
    required this.time,
    required this.primaryColor,
    required this.primaryLight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Anéis concêntricos em laranja suave - AUMENTADOS
    for (int i = 1; i <= 5; i++) {
      final radius = 80.0 * i;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 // AUMENTADO de 1.0 para 2.0
        ..color =
            primaryColor.withOpacity(0.08 + 0.03 * i); // AUMENTADO opacidade

      canvas.drawCircle(center, radius * pulse, paint);
    }

    // Pontos flutuantes (símbolos matemáticos em laranja) - AUMENTADOS
    final symbols = [
      '+',
      '−',
      '×',
      '÷',
      '=',
      'π',
      '∫',
      '∑'
    ]; // ADICIONADOS mais símbolos

    for (int i = 0; i < 20; i++) {
      final angle = rotation + i * (2 * pi / 20);
      final distance = 150.0 + 50.0 * sin(time + i);
      final x = center.dx + cos(angle) * distance;
      final y = center.dy + sin(angle) * distance;

      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = primaryColor
            .withOpacity(0.3 + 0.15 * sin(time * 2 + i)); // AUMENTADO opacidade

      final dotSize =
          10.0 + 8.0 * sin(time * 2 + i); // AUMENTADO de 8.0/6.0 para 10.0/8.0
      canvas.drawCircle(Offset(x, y), dotSize, paint);

      // Desenhar símbolos matemáticos pequenos - AUMENTADOS
      final symbolPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5 // AUMENTADO de 1.5 para 2.5
        ..color = primaryLight
            .withOpacity(0.5); // AUMENTADO opacidade de 0.3 para 0.5

      // Desenha símbolo baseado no índice
      final symbolIndex = i % symbols.length;
      final symbol = symbols[symbolIndex];

      if (symbol == '+') {
        final lineLength = dotSize * 0.6; // AUMENTADO de 0.5 para 0.6
        canvas.drawLine(
          Offset(x - lineLength, y),
          Offset(x + lineLength, y),
          symbolPaint,
        );
        canvas.drawLine(
          Offset(x, y - lineLength),
          Offset(x, y + lineLength),
          symbolPaint,
        );
      } else if (symbol == '−') {
        final lineLength = dotSize * 0.6; // AUMENTADO de 0.5 para 0.6
        canvas.drawLine(
          Offset(x - lineLength, y),
          Offset(x + lineLength, y),
          symbolPaint,
        );
      } else if (symbol == '×') {
        final lineLength = dotSize * 0.45; // AUMENTADO de 0.35 para 0.45
        canvas.drawLine(
          Offset(x - lineLength, y - lineLength),
          Offset(x + lineLength, y + lineLength),
          symbolPaint,
        );
        canvas.drawLine(
          Offset(x + lineLength, y - lineLength),
          Offset(x - lineLength, y + lineLength),
          symbolPaint,
        );
      } else if (symbol == '=') {
        final lineLength = dotSize * 0.6; // AUMENTADO
        final spacing = dotSize * 0.2;
        canvas.drawLine(
          Offset(x - lineLength, y - spacing),
          Offset(x + lineLength, y - spacing),
          symbolPaint,
        );
        canvas.drawLine(
          Offset(x - lineLength, y + spacing),
          Offset(x + lineLength, y + spacing),
          symbolPaint,
        );
      }
    }

    // Linhas de função senoidal em laranja - AUMENTADAS
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 // AUMENTADO de 1.5 para 2.0
      ..color =
          primaryColor.withOpacity(0.2); // AUMENTADO opacidade de 0.15 para 0.2

    for (int wave = 0; wave < 3; wave++) {
      final path = Path();
      final waveAmplitude = 25.0 + wave * 12; // AUMENTADO de 20/10 para 25/12
      final waveFrequency = 0.03 + wave * 0.01;

      for (double x = 0; x < size.width; x += 4) {
        final y = center.dy +
            sin(x * waveFrequency + time * 2 + wave) * waveAmplitude +
            cos(x * waveFrequency * 1.3 + time + wave) * waveAmplitude * 0.5;

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, linePaint);
    }

    // Adicionar símbolos matemáticos maiores no fundo
    final largeSymbolPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = primaryColor.withOpacity(0.1);

    // Símbolo de integral grande
    final integralPath = Path();
    integralPath.moveTo(center.dx - 100, center.dy - 50);
    integralPath.quadraticBezierTo(
      center.dx - 80,
      center.dy - 80,
      center.dx - 60,
      center.dy - 40,
    );
    integralPath.quadraticBezierTo(
      center.dx - 40,
      center.dy,
      center.dx - 60,
      center.dy + 40,
    );
    integralPath.quadraticBezierTo(
      center.dx - 80,
      center.dy + 80,
      center.dx - 100,
      center.dy + 50,
    );
    canvas.drawPath(integralPath, largeSymbolPaint);
  }

  @override
  bool shouldRepaint(covariant _MathElementsPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.pulse != pulse ||
        oldDelegate.time != time ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.primaryLight != primaryLight;
  }
}
