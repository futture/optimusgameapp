import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';

class TelaSuporteWidget extends StatefulWidget {
  const TelaSuporteWidget({super.key});

  static String routeName = 'support';
  static String routePath = '/support';

  @override
  State<TelaSuporteWidget> createState() => _TelaSuporteWidgetState();
}

class _TelaSuporteWidgetState extends State<TelaSuporteWidget> {
  final Color primaryColor = const Color(0xFFEC8D0D);
  final Color darkColor = const Color(0xFF121212);
  final Color lightColor = const Color(0xFFFFFFFF);
  final Color cardColor = const Color(0xFF1E1E1E);

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
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        title: Text(
          'Suporte',
          style: TextStyle(
            color: lightColor,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 20 : 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Container( // Adicionado Container com maxWidth
              constraints: BoxConstraints(
                maxWidth: isWeb ? 1000 : double.infinity,
              ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 24,
            vertical: 16,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor.withOpacity(0.9),
                      primaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.support_agent, size: 40, color: lightColor),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Central de Ajuda',
                            style: TextStyle(
                              color: lightColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Estamos aqui para resolver suas dúvidas',
                            style: TextStyle(
                              color: lightColor.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
        
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isSmallScreen ? 1 : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 4,
                children: [
                  _buildSupportOption(
                    icon: Icons.help_outline,
                    title: 'Perguntas Frequentes (FAQ)',
                    subtitle: 'Encontre respostas rápidas',
                    onTap: () => _showFAQPopup(context),
                  ),
                  _buildSupportOption(
                    icon: Icons.chat_bubble_outline,
                    title: 'Fale Conosco',
                    subtitle: 'Converse com nosso time',
                    onTap: () {},
                  ),
                  _buildSupportOption(
                    icon: Icons.report_problem_outlined,
                    title: 'Relatar um Problema',
                    subtitle: 'Informe sobre dificuldades',
                    onTap: () => _showReportProblemPopup(context),
                  ),
                  _buildSupportOption(
                    icon: Icons.policy_outlined,
                    title: 'Política de Privacidade',
                    subtitle: 'Termos e condições',
                    onTap: () {},
                  ),
                ],
              ),
        
              const SizedBox(height: 24),
        
              Text(
                'CONTATO DIRETO',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildContactButton(
                    icon: Icons.email,
                    label: 'E-mail',
                  ),
                  _buildContactButton(
                    icon: Icons.phone,
                    label: 'Telefone',
                  ),
                  _buildContactButton(
                    icon: Icons.chat,
                    label: 'Chat Online',
                  ),
                ],
              ),
        
              const SizedBox(height: 24),
        
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Precisa de ajuda urgente?',
                      style: TextStyle(
                        color: lightColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: darkColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('SUPORTE URGENTE 24H'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void _showFAQPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: darkColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: primaryColor.withOpacity(0.5)),
        ),
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.help_outline, color: primaryColor, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Perguntas Frequentes',
                      style: TextStyle(
                        color: lightColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar nas perguntas...',
                    hintStyle: TextStyle(color: lightColor.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.search, color: primaryColor),
                    filled: true,
                    fillColor: cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: faqItems.length,
                  itemBuilder: (context, index) => _buildFAQItem(faqItems[index]),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('FECHAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportProblemPopup(BuildContext context) {
    final TextEditingController problemController = TextEditingController();
    String? selectedCategory;
    bool isUrgent = false;

    final List<ProblemCategory> categories = [
      ProblemCategory(name: "Bug/Erro", icon: Icons.bug_report),
      ProblemCategory(name: "Desempenho", icon: Icons.speed),
      ProblemCategory(name: "Usabilidade", icon: Icons.accessibility),
      ProblemCategory(name: "Segurança", icon: Icons.security),
      ProblemCategory(name: "Outro", icon: Icons.more_horiz),
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: darkColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: primaryColor.withOpacity(0.5)),
          ),
          insetPadding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.report_problem, color: primaryColor, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Relatar Problema',
                        style: TextStyle(
                          color: lightColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'CATEGORIA DO PROBLEMA',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((category) {
                      final isSelected = selectedCategory == category.name;
                      return ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(category.icon, size: 18, 
                                color: isSelected ? darkColor : primaryColor),
                            const SizedBox(width: 6),
                            Text(category.name),
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = selected ? category.name : null;
                          });
                        },
                        backgroundColor: cardColor,
                        selectedColor: primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected ? darkColor : lightColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'DESCREVA O PROBLEMA*',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: problemController,
                    maxLines: 5,
                    style: TextStyle(color: lightColor),
                    decoration: InputDecoration(
                      hintText: 'Descreva detalhadamente o problema encontrado...',
                      hintStyle: TextStyle(color: lightColor.withOpacity(0.5)),
                      filled: true,
                      fillColor: cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Checkbox(
                        value: isUrgent,
                        onChanged: (value) {
                          setState(() {
                            isUrgent = value ?? false;
                          });
                        },
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(MaterialState.selected)) {
                              return primaryColor;
                            }
                            return cardColor;
                          },
                        ),
                        checkColor: darkColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Este é um problema urgente',
                        style: TextStyle(
                          color: lightColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /*Text(
                    'ANEXOS (OPCIONAL)',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.add_photo_alternate, 
                            size: 40, color: primaryColor),
                        const SizedBox(height: 8),
                        Text(
                          'Adicionar screenshots ou arquivos',
                          style: TextStyle(
                            color: lightColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),*/
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: lightColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCELAR'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: darkColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (selectedCategory == null || 
                              problemController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Por favor, selecione uma categoria e descreva o problema',
                                  style: TextStyle(color: lightColor),
                                ),
                                backgroundColor: Colors.red[800],
                              ),
                            );
                            return;
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Problema reportado com sucesso!',
                                style: TextStyle(color: lightColor),
                              ),
                              backgroundColor: Colors.green[800],
                            ),
                          );
                        },
                        child: const Text('ENVIAR'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem item) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        item.question,
        style: TextStyle(
          color: lightColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 16, 16),
          child: Text(
            item.answer,
            style: TextStyle(
              color: lightColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ),
      ],
      iconColor: primaryColor,
      collapsedIconColor: primaryColor,
      childrenPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: cardColor,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: lightColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: lightColor.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: primaryColor,
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
  }) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: cardColor,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: lightColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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