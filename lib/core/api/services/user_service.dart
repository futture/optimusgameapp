import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/utils/error_util.dart';
import 'package:projeto_game_quiz/core/api/utils/token_util.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/user_request.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';

class UserService {
  ErrorUtil _errorUtil = ErrorUtil();
  final httpService = HttpClientService();

  Future<Map<String, dynamic>> createFcmTokenAsync(
      String userId, CreateFcmTokenRequest request) async {
    try {
      final result = await httpService.request(
        '/users/$userId/divice-info',
        method: 'POST',
        body: request.toJson(),
      );
      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> getUserInfoAsync() async {
    try {
      final successResult = await httpService.request<UserResponse>(
        '/user/me',
        method: 'GET',
        successParser: (json) => UserResponse.FromJson(json),
      );

      UserUtil.saveUserInfoData(successResult);

      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    try {
      final result = await httpService.request(
        '/users',
        method: 'POST',
        body: userData,
      );
      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<Map<String, dynamic>> sendOtp(String phone_number) async {
    try {
      final result = await httpService.request(
        '/users/send-otp',
        method: 'POST',
        body: {'phone_number': phone_number},
      );
      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phone_number, String otp) async {
    try {
      final result = await httpService.request(
        '/verify_otp',
        method: 'post',
        body: {'phone_number': phone_number, 'otp': otp},
      );
      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final result = await httpService.request(
        '/users/login',
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'password',
          'username': email,
          'password': password,
          'scope': '',
          'client_id': 'string',
          'client_secret': 'string',
        },
      );
      TokenUtil.removeToken();

      TokenUtil.saveToken(result['access_token'], result['expires_in']);

      getUserInfoAsync();

      return {
        "isSuccess": true,
        "data": {
          "access_token": result['access_token'],
          "expires_in": result['expires_in'],
        }
      };
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }
}
