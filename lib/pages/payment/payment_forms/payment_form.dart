import 'dart:async';
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
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _accountController = TextEditingController();
  AccountResponse? userAccountInfo;
  UserResponse? user;
  final AccountService accountService = AccountService();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _mensagemStatus = '';
  bool _mostrarMensagem = false;
  Color _corMensagem = Colors.transparent;
  Timer? _timerMensagem;
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _accountFocusNode = FocusNode();

  // Cores EXATAMENTE iguais ao MulticaixaDialog
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _cardColor = Colors.white;
  final Color _textPrimary = Color(0xFF1E293B);
  final Color _textSecondary = Color(0xFF64748B);
  final Color _borderColor = Color(0xFFE2E8F0);
  final Color _successColor = Color(0xFF10B981);
  final Color _errorColor = Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
    getUserInfoAndAccountInfoAsync(setState, context);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    _accountController.dispose();
    _phoneFocusNode.dispose();
    _amountFocusNode.dispose();
    _accountFocusNode.dispose();
    _timerMensagem?.cancel();
    super.dispose();
  }

  void _mostrarMensagemTemporaria(String mensagem, Color cor) {
    _timerMensagem?.cancel();

    setState(() {
      _mensagemStatus = mensagem;
      _corMensagem = cor;
      _mostrarMensagem = true;
    });

    _timerMensagem = Timer(Duration(seconds: 3), () {
      if (mounted) setState(() => _mostrarMensagem = false);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final rawAmount = _amountController.text;
      final amount = double.tryParse(rawAmount.replaceAll(',', '.')) ?? 0.0;

      if (userAccountInfo?.id == null) {
        throw Exception('Informações da conta não disponíveis');
      }

      final transaction = TransactionRequest(
        type: 'credit',
        amount: amount,
        account_id: userAccountInfo!.id,
        transactionMethod: widget.method,
      );

      final response = await accountService.createTransactionAsync(transaction);

      if (response['isSuccess']) {
        _mostrarMensagemTemporaria('Depósito realizado!', _successColor);
        await Future.delayed(Duration(seconds: 1));
        if (mounted) {
          context.pushNamed(Tela03PrincipalWidget.routeName);
        }
      } else {
        final error = response['message'] ?? 'Erro ao criar transação.';
        _mostrarMensagemTemporaria(error, _errorColor);
      }
    } catch (e) {
      _mostrarMensagemTemporaria('Erro inesperado', _errorColor);
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
    if (!RegExp(r'^\d+$').hasMatch(value.replaceAll(RegExp(r'[^\d]'), ''))) {
      return 'Apenas números são permitidos';
    }
    return null;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório';
    if (!RegExp(r'^\d+([.,]\d{1,2})?$').hasMatch(value)) {
      return 'Valor decimal inválido';
    }
    final valor = double.tryParse(value.replaceAll(',', '.'));
    if (valor == null || valor <= 0) return 'Valor deve ser positivo';
    if (valor < 500) return 'Mínimo 500 Kz';
    return null;
  }

  Widget _buildCompactField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    String? hintText,
    Widget? prefixIcon,
    String? prefixText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 4),
            child: Text(
              label,
              style: TextStyle(
                color: _textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            enabled: !_isLoading,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: _textSecondary.withOpacity(0.5),
                fontSize: 13,
              ),
              filled: true,
              fillColor: _backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _primaryColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _errorColor),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              prefixIcon: prefixIcon,
              prefixText: prefixText,
              prefixStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _textPrimary,
              ),
              errorStyle: TextStyle(
                fontSize: 11,
                color: _errorColor,
                height: 0.8,
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
          _buildCompactField(
            label: 'Telefone',
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            keyboardType: TextInputType.phone,
            inputFormatters: [MaskedInputFormatter('### ### ###')],
            validator: (value) {
              final clean = toNumericString(value ?? '');
              if (clean.length != 9 || !clean.startsWith('9')) {
                return 'Número inválido (9 dígitos, começa com 9)';
              }
              return null;
            },
            hintText: '9XX XXX XXX',
            prefixIcon: Icon(Icons.phone, size: 18, color: _textSecondary),
          ),
          _buildCompactField(
            label: 'Montante',
            controller: _amountController,
            focusNode: _amountFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d{0,2}'))
            ],
            validator: _validateAmount,
            hintText: '0,00',
            prefixText: 'Kz ',
            prefixIcon: Icon(Icons.attach_money, size: 18, color: _textSecondary),
          ),
        ];
      case 'Unitel Money':
      case 'Afrimoney':
        return [
          _buildCompactField(
            label: 'Telefone',
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            keyboardType: TextInputType.phone,
            inputFormatters: [MaskedInputFormatter('+244 ### ### ###')],
            validator: (value) {
              final clean = toNumericString(value ?? '');
              if (clean.length != 12 || !clean.startsWith('2449')) {
                return 'Formato: +244 9XX XXX XXX';
              }
              return null;
            },
            hintText: '+244 9XX XXX XXX',
            prefixIcon: Icon(Icons.phone, size: 18, color: _textSecondary),
          ),
          _buildCompactField(
            label: 'Montante',
            controller: _amountController,
            focusNode: _amountFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d{0,2}'))
            ],
            validator: _validateAmount,
            hintText: '0,00',
            prefixText: 'Kz ',
            prefixIcon: Icon(Icons.attach_money, size: 18, color: _textSecondary),
          ),
        ];
      case 'Pay Pay':
        return [
          _buildCompactField(
            label: 'Conta',
            controller: _accountController,
            focusNode: _accountFocusNode,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _validatePhone,
            hintText: 'Número da conta',
            prefixIcon: Icon(Icons.account_balance_wallet, size: 18, color: _textSecondary),
          ),
          _buildCompactField(
            label: 'Montante',
            controller: _amountController,
            focusNode: _amountFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+[\.,]?\d{0,2}'))
            ],
            validator: _validateAmount,
            hintText: '0,00',
            prefixText: 'Kz ',
            prefixIcon: Icon(Icons.attach_money, size: 18, color: _textSecondary),
          ),
        ];
      default:
        return [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFF59E0B)),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, size: 16, color: Color(0xFFD97706)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Método não suportado",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF92400E),
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
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mensagem de status (igual ao Multicaixa)
          if (_mostrarMensagem)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: _corMensagem.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _corMensagem.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    _corMensagem == _successColor ? Icons.check_circle : Icons.error,
                    color: _corMensagem,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _mensagemStatus,
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Header (igual ao Multicaixa)
          Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _borderColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _primaryColor.withOpacity(0.2)),
                  ),
                  child: Center(
                    child: Icon(Icons.payment, color: _primaryColor, size: 20),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Método',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        widget.method,
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Formulário
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._buildFields(),

                // Informação do valor mínimo (igual ao Multicaixa)
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Icon(Icons.info, size: 14, color: _primaryColor),
                      SizedBox(width: 6),
                      Text(
                        'Mínimo: 500 Kz',
                        style: TextStyle(
                          fontSize: 11,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Botões (mesmo layout do Multicaixa)
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: OutlinedButton(
                          onPressed: () {
                            _phoneController.clear();
                            _amountController.clear();
                            _accountController.clear();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            side: BorderSide(color: _borderColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh, size: 16, color: _textSecondary),
                              SizedBox(width: 6),
                              Text('Limpar', style: TextStyle(fontSize: 13, color: _textSecondary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send, size: 16),
                                    SizedBox(width: 6),
                                    Text(
                                      'Depositar',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getUserAccountInfo(void Function(VoidCallback fn) setState) async {
    var result = await accountService.getAccountByUserIdAsync(user!.id);
    if (result["isSuccess"]) {
      setState(() => userAccountInfo = result["data"]);
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
    setState(() => user = _user);
  }
}