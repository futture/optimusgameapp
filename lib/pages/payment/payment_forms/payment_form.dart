import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
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

    final Map<String, dynamic> paymentData = {
      'paymentMethod': widget.method,
      if (_refController.text.isNotEmpty) 'Entidade': _refController.text,
      if (_phoneController.text.isNotEmpty) 'phone': _phoneController.text,
      if (_amountController.text.isNotEmpty) 'amount': _amountController.text,
      if (_accountController.text.isNotEmpty)
        'account': _accountController.text,
      if (userAccountInfo?.id != null) 'id': userAccountInfo!.id,
    };

    final accountService = AccountService();

    try {
      final String rawAmount = paymentData['amount']?.toString() ?? '0';
      final double amount = double.tryParse(rawAmount) ?? 0.0;
      final String accountId = paymentData['id'] ?? '';

      final transaction = TransactionRequest(
        type: 'credit',
        amount: amount,
        account_id: accountId,
        transactionMethod: widget.method,
      );

      final response = await accountService.createTransactionAsync(transaction);

      if (response['isSuccess']) {
        if (mounted) {
          await showDialog(
            context: context,
            builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(20),
              child: SuccessDialogWidget(
                message: 'Depósito realizado com sucesso!',
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
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: ErrorDialogWidget(
              message: 'Ocorreu um erro inesperado.',
              onOk: () {
                Navigator.of(context).pop();
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
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Apenas números são permitidos';
    }
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
    String? hintText,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            enabled: !_isLoading,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: customValidator ?? _validateRequired,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFEC8D0D), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntityStatus() {
    if (_entityName == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _entityName == 'Entidade não encontrada'
            ? const Color(0xFFFEE2E2)
            : const Color(0xFFD1FAE5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _entityName == 'Entidade não encontrada'
              ? const Color(0xFFFECACA)
              : const Color(0xFFA7F3D0),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _entityName == 'Entidade não encontrada'
                ? Icons.error_outline
                : Icons.check_circle_outline,
            color: _entityName == 'Entidade não encontrada'
                ? const Color(0xFFDC2626)
                : const Color(0xFF059669),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _entityName!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _entityName == 'Entidade não encontrada'
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF059669),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFields() {
    switch (widget.method) {
      case 'Express':
        return [
          _buildTextField(
            label: 'Número de Telefone',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              MaskedInputFormatter('### ### ###'),
            ],
            customValidator: (value) {
              final clean = toNumericString(value ?? '');

              if (clean.length != 9 || !clean.startsWith('9')) {
                return 'Número inválido. Deve começar com 9 e ter 9 dígitos.';
              }

              return null;
            },
            hintText: '9XX XXX XXX',
          ),
          _buildTextField(
            label: 'Montante',
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d{0,2}'))
            ],
            customValidator: _validateAmount,
            hintText: '0,00',
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
              MaskedInputFormatter('+244 ### ### ###'),
            ],
            customValidator: (value) {
              final clean = toNumericString(value ?? '');
              if (clean.length != 12 || !clean.startsWith('2449')) {
                return 'Número inválido. Use o formato +244 9XX XXX XXX';
              }
              return null;
            },
            hintText: '+244 9XX XXX XXX',
          ),
          _buildTextField(
            label: 'Montante',
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d{0,2}'))
            ],
            customValidator: _validateAmount,
            hintText: '0,00',
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
            hintText: 'Digite o número da conta',
          ),
          _buildTextField(
            label: 'Montante',
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d{0,2}'))
            ],
            customValidator: _validateAmount,
            hintText: '0,00',
          ),
        ];
      default:
        return [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF59E0B)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber, color: Color(0xFFD97706)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Método de pagamento não suportado.",
                    style: TextStyle(
                      color: const Color(0xFF92400E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF6E6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFEC8D0D).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.payment,
                      color: const Color(0xFFEC8D0D),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Método selecionado',
                            style: TextStyle(
                              color: const Color(0xFF2D3748),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.method,
                            style: const TextStyle(
                              color: Color(0xFFEC8D0D),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ..._buildFields(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC8D0D),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shadowColor: const Color(0xFFEC8D0D).withOpacity(0.3),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.send, size: 20),
                            SizedBox(width: 12),
                            Text(
                              'Realizar Depósito',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
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

  Future<void> getUserAccountInfo(
      void Function(VoidCallback fn) setState) async {
    var result = await accountService.getAccountByUserIdAsync(user!.id);
    if (result["isSuccess"]) {
      setState(() {
        userAccountInfo = result["data"];
      });
    } else {
      Warning00ErrorUtil.showDialogMessageError(
        context,
        result["error"].detail.message,
        result["error"].detail.details,
      );
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
