import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projeto_game_quiz/core/api/common/http_client_api.dart';
import 'package:projeto_game_quiz/core/api/utils/error_util.dart';
import 'package:projeto_game_quiz/core/api/utils/token_util.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/user_request.dart';
import 'package:projeto_game_quiz/core/models/responses/otp_code_response.dart';
import 'package:projeto_game_quiz/core/models/responses/user_response.dart';

class UserService {
  ErrorUtil _errorUtil = ErrorUtil();
  final httpService = HttpClientService();

  Future<List<Contact>> fetchContactsAsync() async {
    if (!kIsWeb) {
      final status = await Permission.contacts.request();

      if (!status.isGranted) {
        print("Permissão negada para acessar contatos");
        return List.empty();
      }
      final fetchedContacts =
          await FlutterContacts.getContacts(withProperties: true);

      return fetchedContacts;
    }
    return List.empty();
  }

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

  Future<dynamic> getPlayerByIdAsync(String playerId) async {
    try {
      final successResult = await httpService.request<UserResponse>(
        '/users/$playerId',
        method: 'GET',
        successParser: (json) => UserResponse.FromJson(json),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> getPlayerByMatchIdAsync(String matchId) async {
    try {
      final successResult = await httpService.request<List<UserResponse>>(
        '/users/match/$matchId',
        method: 'GET',
        successParser: (json) =>
            (json as List).map((item) => UserResponse.FromJson(item)).toList(),
      );
      return {"isSuccess": true, "data": successResult};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<dynamic> getUserByPhoneNumbrAsync(String phoneNumber) async {
    try {
      final successResult = await httpService.request<UserResponse>(
        '/users/phone-number/$phoneNumber',
        method: 'GET',
        successParser: (json) => UserResponse.FromJson(json),
      );
      return {"isSuccess": true, "data": successResult};
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

  Future<dynamic> createUser(CreateUserRequest userRequest) async {
    try {
      final obj = userRequest.toJson();
      print(obj);
      final response = await httpService.request('/users/register',
          method: 'POST', body: obj);

      if (response != null && response["id"] != null) {
        final userResponse = UserResponse.FromJson(response);
        return {"isSuccess": true, "data": userResponse};
      } else {
        return {"isSuccess": false, "message": "Erro ao criar usuário"};
      }
    } catch (e) {
      return {"isSuccess": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateUser(
      String user_id, UpdateUserRequest userRequest) async {
    try {
      final requestBody = userRequest.toJson();
      print('Dados enviados para atualização: $requestBody');
      final response = await httpService.request(
        '/user/update/${user_id}',
        method: 'PUT',
        body: requestBody,
      );
      if (response != null && response["id"] != null) {
        print('Usuário atualizado com sucesso: $response');
        final userResponse = UserResponse.FromJson(response);
        await UserUtil.saveUserInfoData(userResponse);
        return {
          "isSuccess": true,
          "data": userResponse,
        };
      } else {
        final errorMessage = response?["message"] ?? "Resposta inválida da API";
        print('Erro ao atualizar usuário: $errorMessage');
        return {
          "isSuccess": false,
          "error": {
            "detail": {
              "message": errorMessage,
              "details": "Verifique os dados e tente novamente"
            }
          }
        };
      }
    } catch (e) {
      print('Erro durante a atualização do usuário: $e');
      return {"isSuccess": false, "message": e.toString()};
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

  Future<Map<String, dynamic>> verifyOtp(
      String phone_number, String otp) async {
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

  Future<Map<String, dynamic>> validateOtp(String code) async {
    try {
      final result = await httpService.request<OtpCodeResponse>(
        '/otp/$code',
        method: 'GET',
        successParser: (json) => OtpCodeResponse.fromJson(json),
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
      await TokenUtil.removeToken();

      print(result);
      await TokenUtil.saveToken(result['access_token'], result['expires_in']);

      await getUserInfoAsync();

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

  Future<Map<String, dynamic>> logoutAsync(String userId) async {
    try { 
      final result = await httpService.request(
        '/users/${userId}/logout',
        method: 'PATCH',
        body: {},
      ); 
      await TokenUtil.removeToken();

      return {"isSuccess": true, "data": result};
    } catch (e) {
      return _errorUtil.handleError(e);
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String user_id,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final encodedParams = Uri(
        queryParameters: {
          'user_id': user_id,
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      ).query;
      final response = await httpService.request(
        '/users/change-password?$encodedParams',
        method: 'POST',
      );
      print(response['success']);
      if (response != null && response['success'] == true) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      return {
        "isSuccess": false,
        "error": {
          "detail": {
            "message": "Erro na comunicação com o servidor",
            "details": e.toString()
          }
        }
      };
    }
  }
}
