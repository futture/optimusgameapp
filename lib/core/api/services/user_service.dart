import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl;
  final storage = FlutterSecureStorage();
  UserService({this.baseUrl = 'http://localhost:8000'}); 
  Future<bool> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro ao criar usuário: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro ao conectar com o servidor: $e');
      return false;
    }
  }

  Future<bool> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send_otp/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro ao enviar OTP: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro ao conectar com o servidor: $e');
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify_otp/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro ao verificar OTP: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro ao conectar com o servidor: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return null;
    }

    final Map<String, String> body = {
      'email': email,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/users/login/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body); 
      final token = data['access_token'];
      final expiresIn = data['expires_in']; 
      return {
        'access_token': token,
        'expires_in': expiresIn,
      };
    } else {
      final errorData = json.decode(response.body);
      print('Erro: ${errorData['message']}');
      return null;
    }
  }  
  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  } 
}
