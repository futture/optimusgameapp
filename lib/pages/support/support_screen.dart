import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';

class TelaSuporteWidget extends StatefulWidget {
  const TelaSuporteWidget({super.key});

  static String routeName = 'support';
  static String routePath = '/support';

  @override
  State<TelaSuporteWidget> createState() => _TelaSuporteWidgetState();
}

class _TelaSuporteWidgetState extends State<TelaSuporteWidget> 
    with SingleTickerProviderStateMixin {
  // Cores do tema premium com laranja como primária
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _primaryDark = Color(0xFFD17A0A);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);
  final Color _successColor = Color(0xFF10B981);
  final Color _errorColor = Color(0xFFEF4444);

  // Gradientes premium
  final LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final List<FAQItem> faqItems = [
    FAQItem(
      question: "Como resetar minha senha?",
      answer:
          "Você pode resetar sua senha acessando 'Configurações' > 'Segurança' > 'Redefinir senha'. Um e-mail será enviado com as instruções.",
    ),
    FAQItem(
      question: "Quais métodos de pagamento são aceitos?",
      answer:
          "Aceitamos cartões de crédito (Visa, Mastercard, Amex), Pix e transferência bancária.",
    ),
    FAQItem(
      question: "Como cancelar minha assinatura?",
      answer:
          "Acesse 'Sua Conta' > 'Assinatura' e clique em 'Cancelar assinatura'. O cancelamento será efetivado no final do período atual.",
    ),
    FAQItem(
      question: "O app está travando, o que fazer?",
      answer:
          "Tente reiniciar o aplicativo. Se o problema persistir, desinstale e reinstale o app ou entre em contato com nosso suporte.",
    ),
    FAQItem(
      question: "Como alterar meu e-mail cadastrado?",
      answer:
          "Vá para 'Configurações' > 'Dados Pessoais' > 'Alterar E-mail'. Você precisará confirmar a alteração pelo e-mail atual.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Configuração das animações
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: child,
            ),
          );
        },
        child: Column(
          children: [
            // Header Premium
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: _primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Botão Voltar Premium
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () {
                                context.safePop();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              splashRadius: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Central de Suporte',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          // Ícone de suporte
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.support_agent_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Barra de progresso sutil
                      Container(
                        height: 2,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isWeb ? 1000 : double.infinity,
                  ),
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Card de Boas-vindas
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: _primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.support_agent_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Central de Ajuda',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Estamos aqui para resolver suas dúvidas e problemas',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),

                      // Grid de Opções de Suporte
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isSmallScreen ? 1 : 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 4,
                        children: [
                          _buildSupportOption(
                            icon: Icons.help_outline_rounded,
                            title: 'Perguntas Frequentes',
                            subtitle: 'Encontre respostas rápidas',
                            onTap: () => _showFAQPopup(context),
                          ),
                          _buildSupportOption(
                            icon: Icons.chat_bubble_outline_rounded,
                            title: 'Fale Conosco',
                            subtitle: 'Converse com nosso time',
                            onTap: () => _showContactPopup(context),
                          ),
                          _buildSupportOption(
                            icon: Icons.report_problem_rounded,
                            title: 'Relatar Problema',
                            subtitle: 'Informe sobre dificuldades',
                            onTap: () => _showReportProblemPopup(context),
                          ),
                          _buildSupportOption(
                            icon: Icons.policy_rounded,
                            title: 'Política de Privacidade',
                            subtitle: 'Termos e condições',
                            onTap: () => _showPolicyPopup(context),
                          ),
                        ],
                      ),

                      SizedBox(height: 32),

                      // Seção de Contato Direto
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: _primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.contact_support_rounded,
                                    color: _primaryColor,
                                    size: 22,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Text(
                                  'CONTATO DIRETO',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: _primaryColor,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _buildContactButton(
                                  icon: Icons.email_rounded,
                                  label: 'E-mail',
                                  onTap: () => _contactViaEmail(),
                                ),
                                _buildContactButton(
                                  icon: Icons.phone_rounded,
                                  label: 'Telefone',
                                  onTap: () => _contactViaPhone(),
                                ),
                                _buildContactButton(
                                  icon: Icons.chat_rounded,
                                  label: 'Chat Online',
                                  onTap: () => _startChat(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Card de Suporte Urgente
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: _primaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: _errorColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.warning_amber_rounded,
                                    color: _errorColor,
                                    size: 22,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Precisa de ajuda urgente?',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: _onSurfaceColor,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Suporte prioritário 24 horas',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          color: _onSurfaceColor.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: _errorColor.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _errorColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () => _showUrgentSupportPopup(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.emergency_rounded, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'SUPORTE URGENTE 24H',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: _outlineColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: _primaryColor, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: _onSurfaceColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: _onSurfaceColor.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: _onSurfaceColor.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: _outlineColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: _primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: _onSurfaceColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Métodos de contato
  void _contactViaEmail() {
    _showSnackBar('Abrindo cliente de e-mail...', _primaryColor);
  }

  void _contactViaPhone() {
    _showSnackBar('Iniciando chamada telefônica...', _primaryColor);
  }

  void _startChat() {
    _showSnackBar('Conectando com o suporte...', _primaryColor);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
      ),
    );
  }

  // Diálogos com cores corrigidas
  void _showFAQPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _FAQDialog(
        faqItems: faqItems, 
        primaryColor: _primaryColor,
        surfaceColor: _surfaceColor,
        onSurfaceColor: _onSurfaceColor,
        outlineColor: _outlineColor,
      ),
    );
  }

  void _showContactPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _ContactDialog(
        primaryColor: _primaryColor,
        surfaceColor: _surfaceColor,
        onSurfaceColor: _onSurfaceColor,
      ),
    );
  }

  void _showReportProblemPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _ReportProblemDialog(
        primaryColor: _primaryColor,
        surfaceColor: _surfaceColor,
        onSurfaceColor: _onSurfaceColor,
        outlineColor: _outlineColor,
        errorColor: _errorColor,
      ),
    );
  }

  void _showPolicyPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _PolicyDialog(
        primaryColor: _primaryColor,
        surfaceColor: _surfaceColor,
        onSurfaceColor: _onSurfaceColor,
      ),
    );
  }

  void _showUrgentSupportPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _UrgentSupportDialog(
        primaryColor: _primaryColor,
        surfaceColor: _surfaceColor,
        onSurfaceColor: _onSurfaceColor,
        errorColor: _errorColor,
      ),
    );
  }
}

// Diálogo de FAQ com cores corrigidas
class _FAQDialog extends StatefulWidget {
  final List<FAQItem> faqItems;
  final Color primaryColor;
  final Color surfaceColor;
  final Color onSurfaceColor;
  final Color outlineColor;

  const _FAQDialog({
    required this.faqItems,
    required this.primaryColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
    required this.outlineColor,
  });

  @override
  State<_FAQDialog> createState() => _FAQDialogState();
}

class _FAQDialogState extends State<_FAQDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<FAQItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.faqItems;
    _searchController.addListener(_filterFAQs);
  }

  void _filterFAQs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.faqItems.where((item) {
        return item.question.toLowerCase().contains(query) ||
               item.answer.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: widget.surfaceColor,
      surfaceTintColor: widget.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 600, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header do diálogo
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: widget.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: widget.primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.help_outline_rounded,
                      color: widget.primaryColor,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Perguntas Frequentes',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: widget.onSurfaceColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Barra de pesquisa
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar nas perguntas...',
                  hintStyle: TextStyle(
                    color: widget.onSurfaceColor.withOpacity(0.4),
                  ),
                  prefixIcon: Icon(Icons.search_rounded, color: widget.primaryColor),
                  filled: true,
                  fillColor: widget.surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: widget.outlineColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: widget.outlineColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: widget.primaryColor, width: 2),
                  ),
                ),
                style: TextStyle(color: widget.onSurfaceColor),
              ),
            ),

            // Lista de FAQs
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: widget.onSurfaceColor.withOpacity(0.3),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Nenhuma pergunta encontrada',
                            style: TextStyle(
                              color: widget.onSurfaceColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) => _buildFAQItem(_filteredItems[index]),
                    ),
            ),

            // Botão de fechar
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: widget.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'FECHAR',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: widget.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.outlineColor),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          item.question,
          style: TextStyle(
            fontFamily: 'Inter',
            color: widget.onSurfaceColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24, 8, 16, 16),
            child: Text(
              item.answer,
              style: TextStyle(
                fontFamily: 'Inter',
                color: widget.onSurfaceColor.withOpacity(0.8),
                height: 1.5,
              ),
            ),
          ),
        ],
        iconColor: widget.primaryColor,
        collapsedIconColor: widget.primaryColor,
        childrenPadding: EdgeInsets.zero,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Diálogo de Contato
class _ContactDialog extends StatelessWidget {
  final Color primaryColor;
  final Color surfaceColor;
  final Color onSurfaceColor;

  const _ContactDialog({
    required this.primaryColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: surfaceColor,
      surfaceTintColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_rounded,
                color: primaryColor,
                size: 30,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Fale Conosco',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: onSurfaceColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Escolha como deseja entrar em contato com nosso suporte',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                color: onSurfaceColor.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildContactOption(
                  icon: Icons.email_rounded,
                  label: 'E-mail',
                  description: 'suporte@empresa.com',
                ),
                _buildContactOption(
                  icon: Icons.phone_rounded,
                  label: 'Telefone',
                  description: '(11) 9999-9999',
                ),
                _buildContactOption(
                  icon: Icons.chat_rounded,
                  label: 'Chat Online',
                  description: 'Disponível 24h',
                ),
              ],
            ),
            SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ENTENDI',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String label,
    required String description,
  }) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryColor, size: 32),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: onSurfaceColor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: onSurfaceColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// Diálogo de Reportar Problema
class _ReportProblemDialog extends StatefulWidget {
  final Color primaryColor;
  final Color surfaceColor;
  final Color onSurfaceColor;
  final Color outlineColor;
  final Color errorColor;

  const _ReportProblemDialog({
    required this.primaryColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
    required this.outlineColor,
    required this.errorColor,
  });

  @override
  State<_ReportProblemDialog> createState() => _ReportProblemDialogState();
}

class _ReportProblemDialogState extends State<_ReportProblemDialog> {
  final TextEditingController _problemController = TextEditingController();
  String? _selectedCategory;
  bool _isUrgent = false;

  final List<ProblemCategory> _categories = [
    ProblemCategory(name: "Bug/Erro", icon: Icons.bug_report_rounded),
    ProblemCategory(name: "Desempenho", icon: Icons.speed_rounded),
    ProblemCategory(name: "Usabilidade", icon: Icons.accessibility_rounded),
    ProblemCategory(name: "Segurança", icon: Icons.security_rounded),
    ProblemCategory(name: "Outro", icon: Icons.more_horiz_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: widget.surfaceColor,
      surfaceTintColor: widget.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: widget.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.report_problem_rounded,
                      color: widget.primaryColor,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Relatar Problema',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: widget.onSurfaceColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              Text(
                'CATEGORIA DO PROBLEMA',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: widget.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category.name;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(category.icon, size: 18, 
                            color: isSelected ? Colors.white : widget.primaryColor),
                        SizedBox(width: 6),
                        Text(
                          category.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : widget.onSurfaceColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category.name : null;
                      });
                    },
                    backgroundColor: widget.surfaceColor,
                    selectedColor: widget.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 24),

              Text(
                'DESCREVA O PROBLEMA*',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: widget.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _problemController,
                maxLines: 5,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: widget.onSurfaceColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Descreva detalhadamente o problema encontrado...',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    color: widget.onSurfaceColor.withOpacity(0.4),
                  ),
                  filled: true,
                  fillColor: widget.surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: widget.outlineColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: widget.outlineColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: widget.primaryColor, width: 2),
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Checkbox(
                    value: _isUrgent,
                    onChanged: (value) {
                      setState(() {
                        _isUrgent = value ?? false;
                      });
                    },
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return widget.primaryColor;
                        }
                        return widget.surfaceColor;
                      },
                    ),
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Este é um problema urgente',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: widget.onSurfaceColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: widget.onSurfaceColor,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'CANCELAR',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: widget.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (_selectedCategory == null || _problemController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Por favor, selecione uma categoria e descreva o problema',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: widget.errorColor,
                            ),
                          );
                          return;
                        }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Problema reportado com sucesso!'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                      child: Text(
                        'ENVIAR RELATÓRIO',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Diálogo de Política de Privacidade
class _PolicyDialog extends StatelessWidget {
  final Color primaryColor;
  final Color surfaceColor;
  final Color onSurfaceColor;

  const _PolicyDialog({
    required this.primaryColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: surfaceColor,
      surfaceTintColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 600, maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.policy_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Política de Privacidade',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: onSurfaceColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Aqui vai o conteúdo da política de privacidade...',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: onSurfaceColor,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'ENTENDI',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Diálogo de Suporte Urgente
class _UrgentSupportDialog extends StatelessWidget {
  final Color primaryColor;
  final Color surfaceColor;
  final Color onSurfaceColor;
  final Color errorColor;

  const _UrgentSupportDialog({
    required this.primaryColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
    required this.errorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: surfaceColor,
      surfaceTintColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emergency_rounded,
                color: errorColor,
                size: 40,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Suporte Urgente 24H',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: onSurfaceColor,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Para emergências e problemas críticos que necessitam de atenção imediata',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                color: onSurfaceColor.withOpacity(0.7),
                height: 1.5,
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: errorColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: errorColor.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    'Contato de Emergência',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: onSurfaceColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '(11) 9999-9999',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: errorColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'suporte.urgente@empresa.com',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: onSurfaceColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: onSurfaceColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'VOLTAR',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: errorColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: errorColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'LIGAR AGORA',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class ProblemCategory {
  final String name;
  final IconData icon;

  ProblemCategory({required this.name, required this.icon});
}