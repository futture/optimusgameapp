import 'package:projeto_game_quiz/core/models/responses/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserUtil {
  
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("name");
  }

  static Future<UserResponse?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString("userId");
    final email = prefs.getString("email");
    final name = prefs.getString("name");
    final phone_number = prefs.getString("phone_number");
    final phone_number_mask = prefs.getString("phone_number_mask");


    return UserResponse(
        id: userId!,
        name: name!,
        email: email!,
        phone_number:phone_number!,
        phone_number_mask:  phone_number_mask!
       );
  }

  static Future<void> saveUserInfoData(UserResponse userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userInfo.id);
    await prefs.setString('name', userInfo.name);
    await prefs.setString('email', userInfo.email);
    await prefs.setString('phone_number', userInfo.phone_number);
    await prefs.setString('phone_number_mask', userInfo.phone_number_mask);
  }
}
