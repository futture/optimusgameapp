import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/utils/error_util.dart';
import 'package:projeto_game_quiz/core/api/utils/token_util.dart';
import 'package:projeto_game_quiz/core/models/requests/user_request.dart';

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

  Future<Map<String, dynamic>> sendOtp(String email) async {
    try {
      final result = await httpService.request(
        '/send_otp/',
        method: 'POST',
        body: {'email': email},
      );
      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final result = await httpService.request(
        '/verify_otp/',
        method: 'POST',
        body: {'email': email, 'otp': otp},
      );
      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final result = await httpService.request(
        '/api/v1/users/login/',
        method: 'POST',
        body: {'email': email, 'password': password},
      );

      TokenUtil.removeToken();

      TokenUtil.saveToken(result['access_token'], result['expires_in']);

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
