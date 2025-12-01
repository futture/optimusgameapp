import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'modals_saque_model.dart';
export 'modals_saque_model.dart';

class ModalsSaqueWidget extends StatefulWidget {
  const ModalsSaqueWidget({super.key});

  @override
  State<ModalsSaqueWidget> createState() => _ModalsSaqueWidgetState();
}

class _ModalsSaqueWidgetState extends State<ModalsSaqueWidget> {
  late ModalsSaqueModel _model;

  // Cores do tema premium alinhadas com sua app
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);
  final Color _successColor = Color(0xFF10B981);
  final Color _errorColor = Color(0xFFEF4444);

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModalsSaqueModel());
    _model.textController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  // Função para formatar o valor enquanto digita (Angola: 1.000,00)
  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    
    // Remove todos os caracteres não numéricos
    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Se estiver vazio após limpar, retorna vazio
    if (digitsOnly.isEmpty) return '';
    
    // Converte para número inteiro (centavos)
    double number;
    try {
      number = double.parse(digitsOnly) / 100;
    } catch (e) {
      return value;
    }
    
    // Formata com separadores angolanos
    if (number < 1000) {
      // Para números menores que 1000, mostra com 2 decimais
      return NumberFormat("#,##0.00", "pt_AO").format(number);
    } else {
      // Para números maiores, formata com separador de milhar
      String formatted = NumberFormat("#,##0", "pt_AO").format(number.toInt());
      // Adiciona os centavos se houver
      double cents = number - number.toInt();
      if (cents > 0) {
        String centsStr = (cents * 100).round().toString().padLeft(2, '0');
        formatted += ',$centsStr';
      } else {
        formatted += ',00';
      }
      return formatted;
    }
  }

  // Função para validar o valor
  bool _isValidAmount(String value) {
    if (value.isEmpty) return false;
    
    try {
      // Remove formatação angolana
      String cleanValue = value.replaceAll('.', '').replaceAll(',', '.');
      double amount = double.parse(cleanValue);
      
      // Verifica limites
      return amount >= 100.00 && amount <= 10000.00;
    } catch (e) {
      return false;
    }
  }

  // Extrai o valor numérico do texto formatado
  double? _parseAmount(String value) {
    if (value.isEmpty) return null;
    
    try {
      String cleanValue = value.replaceAll('.', '').replaceAll(',', '.');
      return double.parse(cleanValue);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header do Modal
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, Color(0xFFF59E0B)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.payments_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'SOLICITAR SAQUE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () => context.safePop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      splashRadius: 18,
                      padding: EdgeInsets.all(6),
                    ),
                  ),
                ],
              ),
            ),

            // Conteúdo do Modal
            Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _model.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo de Valor
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Valor do Saque',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: _onSurfaceColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: _backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _outlineColor,
                              width: 1.5,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              autofocus: true,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: _onSurfaceColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Ex: 1.000,00',
                                hintStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  color: _onSurfaceColor.withOpacity(0.4),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 14),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
                                    'Kz',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: _onSurfaceColor.withOpacity(0.6),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                suffixIconConstraints: BoxConstraints(minWidth: 30),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                                signed: false,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[\d,\.]')),
                              ],
                              cursorColor: _primaryColor,
                              onChanged: (value) {
                                // Salva a posição do cursor
                                final cursorPosition = _model.textController?.selection.base.offset;
                                
                                // Formata o valor
                                final formatted = _formatCurrency(value);
                                
                                // Atualiza o texto se diferente
                                if (formatted != value) {
                                  _model.textController.text = formatted;
                                  
                                  // Tenta manter o cursor na posição correta
                                  int? newPosition = cursorPosition;
                                  if (newPosition != null) {
                                    if (value.length > formatted.length) {
                                      newPosition -= (value.length - formatted.length);
                                    } else if (value.length < formatted.length) {
                                      newPosition += (formatted.length - value.length);
                                    }
                                    
                                    // Garante que a posição está dentro dos limites
                                    newPosition = newPosition.clamp(0, formatted.length);
                                    
                                    _model.textController?.selection = TextSelection.collapsed(
                                      offset: newPosition,
                                    );
                                  }
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, informe o valor';
                                }
                                if (!_isValidAmount(value)) {
                                  return 'Valor deve estar entre 100,00 e 10.000,00 Kz';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 12),
                    
                    // Informação de limite
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _primaryColor.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: _primaryColor,
                            size: 14,
                          ),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Limite: 100,00 Kz a 10.000,00 Kz',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: _onSurfaceColor.withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Botão de Enviar
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.25),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            if (_model.formKey.currentState?.validate() ?? false) {
                              await _showSuccessDialog();
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_primaryColor, Color(0xFFF59E0B)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'ENVIAR SOLICITAÇÃO',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog() async {
    final amount = _parseAmount(_model.textController.text);
    final formattedAmount = amount != null 
        ? NumberFormat("#,##0.00", "pt_AO").format(amount) 
        : _model.textController.text;
    
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (alertDialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20),
          child: Container(
            constraints: BoxConstraints(maxWidth: 350),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _successColor.withOpacity(0.05),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _successColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Solicitação Enviada!',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: _onSurfaceColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Saque de $formattedAmount Kz',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _onSurfaceColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Seu pedido foi enviado com sucesso.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: _onSurfaceColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.25),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.pop(alertDialogContext);
                          context.safePop(); // Fecha o modal principal também
                        },
                        child: Container(
                          width: double.infinity,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_primaryColor, Color(0xFFF59E0B)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'ENTENDI',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}