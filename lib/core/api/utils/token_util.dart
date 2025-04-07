import 'package:shared_preferences/shared_preferences.dart';

class TokenUtil {
  static Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');
    final int? expirationTime = prefs.getInt('expiration_time');

    if (accessToken == null || expirationTime == null) {
      return false;
    }
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    if (currentTime >= expirationTime) {
      return false;
    }
    return true;
  }

  static Future<void> saveToken(String token, int expirationTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    await prefs.setInt('expiration_time', expirationTime);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('expiration_time');
  }

  static Future<String?> getToken () async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }
}
