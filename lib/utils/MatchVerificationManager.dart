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
  
  // Usando StreamController.broadcast para múltiplos listeners
  final _activeMatchesController = StreamController<List<MatchResponse>>.broadcast(
    onCancel: () {
      print('📡 activeMatchesStream cancelado');
    },
  );
  
  final _verificationStatusController = StreamController<bool>.broadcast(
    onCancel: () {
      print('📡 verificationStatusStream cancelado');
    },
  );
  
  Stream<List<MatchResponse>> get activeMatchesStream => 
      _activeMatchesController.stream.asBroadcastStream(
        onCancel: (subscription) {
          subscription.pause();
        }
      );
  
  Stream<bool> get verificationStatusStream => 
      _verificationStatusController.stream.asBroadcastStream(
        onCancel: (subscription) {
          subscription.pause();
        }
      );
  
  // Cache do último resultado para novos listeners
  List<MatchResponse> _lastMatches = [];
  bool _lastVerificationStatus = false;
  
  Future<void> verifyActiveMatches({
    required String userId,
    bool force = false,
    bool silent = false,
  }) async {
    if (_isVerifying && !force) {
      print("⏳ Verificação já em andamento, aguardando...");
      return;
    }
    
    if (!force && _lastVerification != null) {
      final timeSinceLast = DateTime.now().difference(_lastVerification!);
      if (timeSinceLast < Duration(seconds: 30)) {
        print("⏳ Última verificação foi há ${timeSinceLast.inSeconds}s, ignorando...");
        return;
      }
    }
    
    _isVerifying = true;
    
    if (!silent && !_verificationStatusController.isClosed) {
      try {
        _verificationStatusController.add(true);
      } catch (e) {
        print('⚠️ Erro ao adicionar status de verificação: $e');
      }
    }
    
    try {
      print("🔄 Verificando partidas ativas para usuário: $userId");
      final result = await _matchService
          .checkUserHasMatchInProgressToday(userId);
      
      if (result['isSuccess'] == true) {
        final List<MatchResponse> matches = 
            (result['matches'] as List?)?.cast<MatchResponse>() ?? [];
        
        _lastMatches = List.from(matches); // Armazenar cache
        
        if (!_activeMatchesController.isClosed) {
          _activeMatchesController.add(matches);
        }
        
        await _updateBadge(matches.isNotEmpty);
        
        print("✅ Verificação concluída: ${matches.length} partida(s) ativa(s)");
      } else {
        print("⚠️ Falha na verificação: ${result['error']}");
        _lastMatches = [];
        if (!_activeMatchesController.isClosed) {
          _activeMatchesController.add([]);
        }
        await _updateBadge(false);
      }
    } catch (e, stackTrace) {
      print('💥 Erro na verificação: $e');
      print('📄 Stack trace: $stackTrace');
      _lastMatches = [];
      if (!_activeMatchesController.isClosed) {
        _activeMatchesController.add([]);
      }
      await _updateBadge(false);
    } finally {
      _isVerifying = false;
      _lastVerification = DateTime.now();
      
      if (!silent && !_verificationStatusController.isClosed) {
        try {
          _verificationStatusController.add(false);
        } catch (e) {
          print('⚠️ Erro ao finalizar status de verificação: $e');
        }
      }
    }
  }
  
  // Método para obter o último estado (útil para novos listeners)
  List<MatchResponse> getLastMatches() => List.from(_lastMatches);
  
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
    
    // Fazer uma verificação imediata
    Future.microtask(() {
      verifyActiveMatches(
        userId: userId,
        silent: true,
      );
    });
    
    _verificationTimer = Timer.periodic(
      Duration(minutes: 5),  
      (timer) async {
        if (!timer.isActive) return;
        
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
    print("⏹️ Parando verificações periódicas...");
    _verificationTimer?.cancel();
    _verificationTimer = null;
  }
  
  void pausePeriodicVerification() {
    print("⏸️ Pausando verificações periódicas temporariamente");
    _verificationTimer?.cancel();
  }
  
  void resumePeriodicVerification(String userId) {
    print("▶️ Retomando verificações periódicas");
    startPeriodicVerification(userId);
  }
  
  void dispose() {
    print("♻️ Iniciando dispose do MatchVerificationManager");
    
    stopPeriodicVerification();
    
    // Fechar controllers apenas se não estiverem fechados
    if (!_activeMatchesController.isClosed) {
      _activeMatchesController.close();
    }
    
    if (!_verificationStatusController.isClosed) {
      _verificationStatusController.close();
    }
    
    print("✅ MatchVerificationManager disposed com sucesso");
  }
}