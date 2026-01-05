import 'dart:async';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:projeto_game_quiz/core/api/services/match_service.dart';
import 'package:projeto_game_quiz/core/models/responses/match_response.dart';

class MatchVerificationManager {
  static final MatchVerificationManager _instance = 
      MatchVerificationManager._internal();
  
  factory MatchVerificationManager() => _instance;
  MatchVerificationManager._internal();
  
  final MatchService _matchService = MatchService();
  Timer? _verificationTimer;
  bool _isVerifying = false;
  DateTime? _lastVerification;
   
  final _activeMatchesController = StreamController<List<MatchResponse>>();
  final _verificationStatusController = StreamController<bool>();
  
  Stream<List<MatchResponse>> get activeMatchesStream => 
      _activeMatchesController.stream;
  Stream<bool> get verificationStatusStream => 
      _verificationStatusController.stream;
  
  Future<void> verifyActiveMatches({
    required String userId,
    bool force = false,
    bool silent = false,
  }) async {
    if (_isVerifying && !force) return;
    
    if (!force && _lastVerification != null) {
      final timeSinceLast = DateTime.now().difference(_lastVerification!);
      if (timeSinceLast < Duration(seconds: 30)) return;
    }
    
    _isVerifying = true;
    
    if (!silent) {
      _verificationStatusController.add(true); 
    }
    
    try {
      final result = await _matchService
          .checkUserHasMatchInProgressToday(userId);
      
      if (result['isSuccess'] == true) {
        final List<MatchResponse> matches = 
            (result['matches'] as List?)?.cast<MatchResponse>() ?? [];
        _activeMatchesController.add(matches);
         
        await _updateBadge(matches.isNotEmpty);
        
        print("✅ Verificação concluída: ${matches.length} partida(s) ativa(s)");
      } else {
        print("⚠️ Falha na verificação: ${result['error']}");
        _activeMatchesController.add([]);
        await _updateBadge(false);
      }
    } catch (e) {
      print('💥 Erro na verificação: $e');
      _activeMatchesController.add([]);
      await _updateBadge(false);
    } finally {
      _isVerifying = false;
      _lastVerification = DateTime.now();
      
      if (!silent) {
        _verificationStatusController.add(false);  
      }
    }
  }
   
  Future<void> _updateBadge(bool hasActiveMatch) async {
    try {
      if (hasActiveMatch) {
        await FlutterAppBadger.updateBadgeCount(1);
        print("🟡 Badge atualizado: 1 partida ativa");
      } else {
        await FlutterAppBadger.removeBadge();
        print("🟢 Badge removido: sem partidas ativas");
      }
    } catch (e) {
      print("⚠️ Erro ao atualizar badge: $e");
    }
  }
  
  void startPeriodicVerification(String userId) {
    _verificationTimer?.cancel();
    
    _verificationTimer = Timer.periodic(
      Duration(minutes: 5),  
      (_) async {
        print("⏰ Verificação periódica iniciada");
        await verifyActiveMatches(
          userId: userId,
          silent: true, 
        );
      },
    );
    
    print("🔄 Verificações periódicas iniciadas (intervalo: 5 minutos)");
  }
  
  void stopPeriodicVerification() {
    _verificationTimer?.cancel();
    _verificationTimer = null;
    print("⏹️ Verificações periódicas paradas");
  }
  
  void dispose() {
    _verificationTimer?.cancel();
    _activeMatchesController.close();
    _verificationStatusController.close();
    print("♻️ MatchVerificationManager disposed");
  }
}