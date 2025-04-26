import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:projeto_game_quiz/components/warnings/warning00_campo_vazio/warning00_campo_vazio_widget.dart';
import 'package:projeto_game_quiz/core/api/services/account_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/transaction_request.dart';
import 'package:projeto_game_quiz/core/models/responses/account_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:projeto_game_quiz/dialogs/error-dialog-widget.dart';
import 'package:projeto_game_quiz/dialogs/success-dialog-widget.dart';
import 'package:projeto_game_quiz/flutter_flow/flutter_flow_util.dart';
import 'package:projeto_game_quiz/index.dart';

class PaymentForm extends StatefulWidget {
  final String method;

  const PaymentForm({Key? key, required this.method}) : super(key: key);

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _refController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _accountController = TextEditingController();
  AccountResponse? userAccountInfo;
  UserResponse? user;
  final AccountService accountService = AccountService();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _entityName;

  @override
  void initState() {
    super.initState();
    _refController.addListener(_onRefChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
    getUserInfoAndAccountInfoAsync(setState, context);
  }

  @override
  void dispose() {
    _refController.removeListener(_onRefChanged);
    _refController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  void _onRefChanged() async {
    final ref = _refController.text;

    if (ref.isEmpty) {
      setState(() => _entityName = null);
      return;
    }

    await Future.delayed(const Duration(milliseconds: 300));

    final mockEntities = {
      '101': 'Ministério da Saúde',
      '102': 'Administração Geral Tributária',
      '103': 'Universidade Agostinho Neto',
    };

    setState(() {
      _entityName = mockEntities[ref] ?? 'Entidade não encontrada';
    });
  }

  Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);
 
 print(userAccountInfo?.id);
  final Map<String, dynamic> paymentData = {
    'paymentMethod': widget.method,
    if (_refController.text.isNotEmpty) 'Entidade': _refController.text,
    if (_phoneController.text.isNotEmpty) 'phone': _phoneController.text,
    if (_amountController.text.isNotEmpty) 'amount': _amountController.text,
    if (_accountController.text.isNotEmpty) 'account': _accountController.text,
    if (userAccountInfo?.id != null)
      'id': userAccountInfo!.id,
  };

  final accountService = AccountService();

  try {
    final String type = paymentData['paymentMethod'] ?? 'unknown';
    final String rawAmount = paymentData['amount']?.toString() ?? '0';
    final double amount = double.tryParse(rawAmount) ?? 0.0;
    final String accountId = paymentData['id'] ?? '';

    final transaction = TransactionRequest(
      type: 'credit',
      amount: amount,
      account_id: accountId,
    );
    print(jsonEncode(transaction.toJson()));
    final response = await accountService.createTransactionAsync(transaction);

    if (response['isSuccess']) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: SuccessDialogWidget(
              message: 'Deposito feito com sucesso!',
              onOk: () {
                context.pushNamed(Tela03PrincipalWidget.routeName);
              },
            ),
          ),
        );
      }
    } else {
      final error = response['message'] ?? 'Erro ao criar transação.';
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: ErrorDialogWidget(
              message: error,
              onOk: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
          ),
        );
      }
    }
  } catch (e) {
    print('Erro ao enviar transação: $e');
    if (mounted) {
      await showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: ErrorDialogWidget(
            message: 'Ocorreu um erro inesperado.',
            onOk: () {
              Navigator.of(context).pop(); // Fecha o diálogo
            },
          ),
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}


  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório';
    if (!RegExp(r'^\d+$').hasMatch(value))
      return 'Apenas números são permitidos';
    return null;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório';
    if (!RegExp(r'^\d+([.,]\d{1,2})?$').hasMatch(value)) {
      return 'Insira um valor decimal válido';
    }
    return null;
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? customValidator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        enabled: !_isLoading,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: customValidator ?? _validateRequired,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFEC8D0D)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFEC8D0D)),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  List<Widget> _buildFields() {
    switch (widget.method) {
      case 'Express':
        return [
          _buildTextField(label: 'Entidade', controller: _refController),
          if (_entityName != null)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                _entityName!,
                style: TextStyle(
                  fontSize: 14,
                  color: _entityName == 'Entidade não encontrada'
                      ? Colors.red
                      : Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          _buildTextField(
            label: 'Montante',
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d{0,2}'))
            ],
            customValidator: _validateAmount,
          ),
        ];
      case 'Unitel Money':
      case 'Afrimoney':
        return [
          _buildTextField(
            label: 'Número de Telefone',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              MaskedInputFormatter('+244 ### ### ###'), // Máscara personalizada
            ],
            customValidator: (value) {
              final clean = toNumericString(value ?? '');
              if (clean.length != 12 || !clean.startsWith('2449')) {
                return 'Número inválido. Use o formato +244 9XX XXX XXX';
              }
              return null;
            },
          ),
          _buildTextField(
            label: 'Montante',
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d{0,2}'))
            ],
            customValidator: _validateAmount,
          ),
        ];
      case 'Pay Pay':
        return [
          _buildTextField(
            label: 'Conta',
            controller: _accountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            customValidator: _validatePhone,
          ),
          _buildTextField(
            label: 'Montante',
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d{0,2}'))
            ],
            customValidator: _validateAmount,
          ),
        ];
      default:
        return [const Text("Método não suportado.")];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._buildFields(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC8D0D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.send, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Enviar',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor insira um número de telefone';
    }
    final clean = toNumericString(value);
    if (clean.length != 9) {
      return 'O número de telefone deve ter exatamente 9 dígitos';
    }
    if (!clean.startsWith('9')) {
      return 'O número de telefone deve começar com 9';
    }
    return null;
  }

  Future<void> getUserAccountInfo(
      void Function(VoidCallback fn) setState) async {
    var result = await accountService.getAccountByUserIdAsync(user!.id);
    if (result["isSuccess"]) {
      setState(() {
        userAccountInfo = result["data"];
      });
    } else {
      Warning00ErrorUtil.showDialogMessageError(context,
          result["error"].detail.message, result["error"].detail.details);
    }
  }

  Future<void> getUserInfoAndAccountInfoAsync(
      void Function(VoidCallback fn) setState, BuildContext context) async {
    await getUserInfo(setState);
    await getUserAccountInfo(setState);
  }

  Future<void> getUserInfo(void Function(VoidCallback fn) setState) async {
    var _user = await UserUtil.getUserInfo();
    setState(() {
      user = _user!;
    });
  }
}
