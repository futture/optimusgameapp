import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'tela07_financas_model.dart';
export 'tela07_financas_model.dart';

class Tela07FinancasWidget extends StatefulWidget {
  const Tela07FinancasWidget({super.key});

  static String routeName = 'Tela07Financas';
  static String routePath = '/tela07Financas';

  @override
  State<Tela07FinancasWidget> createState() => _Tela07FinancasWidgetState();
}

class _Tela07FinancasWidgetState extends State<Tela07FinancasWidget> 
    with SingleTickerProviderStateMixin {
  late Tela07FinancasModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Cores do tema premium alinhadas com sua app
  final Color _primaryColor = Color(0xFFEC8D0D);
  final Color _primaryDark = Color(0xFFD17A0A);
  final Color _backgroundColor = Color(0xFFF8FAFC);
  final Color _surfaceColor = Colors.white;
  final Color _onSurfaceColor = Color(0xFF1E293B);
  final Color _outlineColor = Color(0xFFE2E8F0);
  final Color _successColor = Color(0xFF10B981);

  // Gradientes premium
  final LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFFEC8D0D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Tela07FinancasModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.isEditingIban = _model.textController1.text.isEmpty;
    _model.isEditingConta = _model.textController2.text.isEmpty;
    _model.getUserIdAndAccountInfo(setState, context);

    // Configuração das animações
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _model.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
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
                                'DADOS FINANCEIROS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            // Ícone de finanças
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.monetization_on_rounded,
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
                      minWidth: 300.0,
                      maxWidth: 500.0,
                    ),
                    padding: EdgeInsets.all(24.0),
                    child: Form(
                      key: _model.formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Card de Apresentação Premium
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
                                    Icons.monetization_on_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Dados Bancários',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Configure suas informações financeiras para recebimentos',
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

                          // Campo IBAN
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _surfaceColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 15,
                                  offset: Offset(0, 6),
                                ),
                              ],
                              border: Border.all(
                                color: _outlineColor,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: _primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.credit_card_rounded,
                                        color: _primaryColor,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Nº DO IBAN',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _onSurfaceColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _model.textController1,
                                        focusNode: _model.textFieldFocusNode1,
                                        autofocus: false,
                                        enabled: _model.isEditingIban ||
                                            _model.textController1.text.isEmpty,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: 'Ex.: A0O600000000000000000000000000000',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            color: _onSurfaceColor.withOpacity(0.4),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _outlineColor,
                                              width: 1.5,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _primaryColor,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          filled: true,
                                          fillColor: _surfaceColor,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: _onSurfaceColor,
                                          fontSize: 14,
                                        ),
                                        validator: _model.textController1Validator
                                            .asValidator(context),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    if (!_model.isCreate)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: _model.isEditingIban 
                                              ? _successColor 
                                              : _primaryColor,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: (_model.isEditingIban 
                                                  ? _successColor 
                                                  : _primaryColor).withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          shape: CircleBorder(),
                                          child: InkWell(
                                            customBorder: CircleBorder(),
                                            onTap: () async {
                                              if (_model.isEditingIban) {
                                                await _model.createAccountInfoAsync();
                                              }

                                              setState(() {
                                                _model.isEditingIban =
                                                    !_model.isEditingIban;
                                              });

                                              if (_model.isEditingIban) {
                                                Future.delayed(
                                                    Duration(milliseconds: 100), () {
                                                  FocusScope.of(context).requestFocus(
                                                      _model.textFieldFocusNode1);
                                                });
                                              } else {
                                                FocusScope.of(context).unfocus();
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Icon(
                                                _model.isEditingIban
                                                    ? Icons.check_rounded
                                                    : Icons.edit_rounded,
                                                size: 16.0,
                                                color: Colors.white,
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
                          SizedBox(height: 20),

                          // Campo Nº de Conta
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _surfaceColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 15,
                                  offset: Offset(0, 6),
                                ),
                              ],
                              border: Border.all(
                                color: _outlineColor,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: _primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.account_balance_rounded,
                                        color: _primaryColor,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Nº DE CONTA',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _onSurfaceColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _model.textController2,
                                        focusNode: _model.textFieldFocusNode2,
                                        autofocus: false,
                                        enabled: _model.isEditingConta ||
                                            _model.textController2.text.isEmpty,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: 'Ex.: 000000000000',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            color: _onSurfaceColor.withOpacity(0.4),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _outlineColor,
                                              width: 1.5,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _primaryColor,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          filled: true,
                                          fillColor: _surfaceColor,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: _onSurfaceColor,
                                          fontSize: 14,
                                        ),
                                        validator: _model.textController2Validator
                                            .asValidator(context),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    if (!_model.isCreate)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: _model.isEditingConta 
                                              ? _successColor 
                                              : _primaryColor,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: (_model.isEditingConta 
                                                  ? _successColor 
                                                  : _primaryColor).withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          shape: CircleBorder(),
                                          child: InkWell(
                                            customBorder: CircleBorder(),
                                            onTap: () async {
                                              if (_model.isEditingConta) {
                                                await _model.createAccountInfoAsync();
                                              }

                                              setState(() {
                                                _model.isEditingConta =
                                                    !_model.isEditingConta;
                                              });

                                              if (_model.isEditingConta) {
                                                Future.delayed(
                                                    Duration(milliseconds: 100), () {
                                                  FocusScope.of(context).requestFocus(
                                                      _model.textFieldFocusNode2);
                                                });
                                              } else {
                                                FocusScope.of(context).unfocus();
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Icon(
                                                _model.isEditingConta
                                                    ? Icons.check_rounded
                                                    : Icons.edit_rounded,
                                                size: 16.0,
                                                color: Colors.white,
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
                          SizedBox(height: 30),

                          // Botão Salvar (apenas para criação)
                          if (_model.isCreate)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: _primaryColor.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () async {
                                    await _model.createAccountInfoAsync();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: _primaryGradient,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.save_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'SALVAR DADOS FINANCEIROS',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}