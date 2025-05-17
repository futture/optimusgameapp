import 'package:shared_preferences/shared_preferences.dart';

const String _superMatchKey = 'super_match';

class SuperMatchUtil {
  static Future<void> saveSuperMatch(String matchId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_superMatchKey, matchId);
  }

  static Future<String?> getSuperMatch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_superMatchKey);
  }

  static Future<void> removeSuperMatch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_superMatchKey);
  }
}
