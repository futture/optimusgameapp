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

  static Future<void> saveToken(String token, int expiresIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    final expirationTimestamp =
        DateTime.now().add(Duration(seconds: expiresIn)).millisecondsSinceEpoch;
    await prefs.setInt('expiration_time', expirationTimestamp);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('expiration_time');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final expirationTimestamp = prefs.getInt('expiration_time');

    if (token == null || expirationTimestamp == null) {
      return null;
    }
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    if (currentTimestamp > expirationTimestamp) {
      await prefs.remove('access_token');
      await prefs.remove('expiration_time');
      return null;
    }
    return token;
  }
}
