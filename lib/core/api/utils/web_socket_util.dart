import 'package:shared_preferences/shared_preferences.dart';

class WebSocketUtil {
  static const String _matchKeyPrefix = 'match_';

  static Future<void> setConnected(String matchId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key(matchId), true);
  }

  static Future<bool> isConnected(String matchId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key(matchId)) ?? false;
  }

  static Future<void> disconnect(String matchId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(matchId));
  }

  static String _key(String matchId) => '$_matchKeyPrefix$matchId';
}

