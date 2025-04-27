import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_game_quiz/Atualiza%C3%A7%C3%A3o/tela10_deposito_e_x_p_r_e_s_s/tela10_deposito_e_x_p_r_e_s_s_widget.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_theme.dart';

class PaymentSelectionScreen extends StatelessWidget {
  final List<Map<String, String>> methods = [
    {
      'label': 'Multicaixa',
      'image': 'assets/images/multicaixa.png',
    },
    {
      'label': 'Express',
      'image': 'assets/images/express.png',
    },
    {
      'label': 'Afrimoney',
      'image': 'assets/images/afrimoney.png',
    },
    {
      'label': 'Unitel Money',
      'image': 'assets/images/unitel.png',
    },
  ];

  void _showPaymentDialog(BuildContext context, String method) {
    if (method == 'Express') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Tela10DepositoEXPRESSWidget()),
    );
    return;
  }
    showDialog(
      context: context,
      builder: (_) {
        switch (method) {
          case 'Multicaixa':
            return _multicaixaDialog(context);
          case 'Express':
            return _empressDialog(context);
          case 'Afrimoney':
          case 'Unitel Money':
            return _afrimoneyUnitelDialog(context, method);
          default:
            return AlertDialog(content: Text('Método não suportado.'));
        }
      },
    );
  }

AlertDialog _multicaixaDialog(BuildContext context) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    backgroundColor: Colors.white,
    title: Row(
      children: const [
        Icon(Icons.credit_card, color: Color(0xFFD2A739)),
        SizedBox(width: 8),
        Text(
          'Multicaixa',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Color(0xFFD2A739),
          ),
        ),
      ],
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(thickness: 1),
        const SizedBox(height: 12),
        _buildCopyableText(context, 'Entidade', '00000000'),
        const SizedBox(height: 10),
        _buildCopyableText(context, 'Referência', '000000'),
        const SizedBox(height: 24),
        const Text(
          'Como carregar via Multicaixa: ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        _buildInstructionStep('1. Vá a um  ATM.'),
        _buildInstructionStep('2. Vá até a opção “Pagamento por Referência”.'),
        _buildInstructionStep('3. Insira a Entidade e Referência fornecidas.'),
        _buildInstructionStep('4. Confirme o valor e finalize o pagamento.'),
      ],
    ),
    actions: [
      TextButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close, color: Colors.redAccent),
        label: const Text(
          'Fechar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
      ),
    ],
  );
}


  Widget _buildCopyableText(BuildContext context, String label, String value) {
  return GestureDetector(
    onTap: () {
      Clipboard.setData(ClipboardData(text: value));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label copiado para a área de transferência')),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFD2A739), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.copy, color: Color(0xFFD2A739)),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildInstructionStep(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.arrow_right, size: 20, color: Colors.black54),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}
AlertDialog _empressDialog(BuildContext context) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: Row(
      children: const [
        Icon(Icons.flash_on, color: Colors.deepPurple),
        SizedBox(width: 8),
        Text(
          'Express',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
    ),
    content: SizedBox(
      width: 350,
      child: Tela10DepositoEXPRESSWidget(), // apenas o formulário
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Fechar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    ],
  );
}
  AlertDialog _afrimoneyUnitelDialog(BuildContext context, String method) {
    return AlertDialog(
      title: Text(method,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          TextField(
              decoration: InputDecoration(
                  labelText: 'Número de Telefone',
                  labelStyle: TextStyle(color: Colors.deepPurple))),
          SizedBox(height: 12),
          TextField(
              decoration: InputDecoration(
                  labelText: 'Montante',
                  labelStyle: TextStyle(color: Colors.deepPurple))),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Fechar',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        ),
      ],
    );
  }

  Widget _buildPaymentCard(
      BuildContext context, String label, String imagePath) {
    final width = MediaQuery.of(context).size.width;
    double cardWidth = width > 600 ? 120 : 130;
    double cardHeight = width > 600 ? 120 : 140;

    return GestureDetector(
      onTap: () => _showPaymentDialog(context, label),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 6),
            ),
          ],
          // color removido
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        title: Text('Selecione um Método de Pagamento',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.normal,
                color: Color(0xFFD2A739))),
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        elevation: 4,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Escolha um método de pagamento abaixo. Toque no método desejado para mais informações detalhadas sobre como realizar o pagamento.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFD2A739),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: methods.map((m) {
                  return _buildPaymentCard(
                    context,
                    m['label']!,
                    m['image']!,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
