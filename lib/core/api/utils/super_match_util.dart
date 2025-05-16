import 'package:shared_preferences/shared_preferences.dart';

class SuperMatchUtil {
  static Future<void> savePreference(String matchId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('super_match');
    await prefs.setString('super_match', matchId);
  }
  static Future<void> removePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('super_match');
  }
  static Future<String?> getPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final superMatch = prefs.getString('super_match');
   
    if (superMatch == null ) {
      return null;
    }
    return superMatch;
  }
}
