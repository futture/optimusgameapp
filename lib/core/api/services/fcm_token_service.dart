import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';
import 'package:projeto_game_quiz/core/api/utils/user_util.dart';
import 'package:projeto_game_quiz/core/models/requests/user_request.dart';

class FcmTokenService {
  String? _token;
  String? _deviceName;
  String? _deviceId;
  final UserService _userService = UserService();

  Future<void> initFirebaseMessaging(BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    var _userId = await UserUtil.getUserId();
    
    _token = await messaging.getToken();
    print("Token FCM: $_token");

    await _getDeviceInfo(context);

    if (_userId != null &&
        _token != null &&
        _deviceName != null &&
        _deviceId != null) {
      _sendTokenToServer(_userId, _token!, _deviceName!, _deviceId!);
    }
  }

  Future<void> _getDeviceInfo(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _deviceName = androidInfo.model;
      _deviceId = androidInfo.id;
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _deviceName = iosInfo.utsname.machine;
      _deviceId = iosInfo.identifierForVendor;
    }

    print("Nome do dispositivo: $_deviceName");
    print("ID do dispositivo: $_deviceId");
  }

  Future<void> _sendTokenToServer(String userId, String tokenFcm,
      String deviceName, String deviceId) async {
    await _userService.createFcmTokenAsync(
        userId,
        CreateFcmTokenRequest(
            fcmToken: tokenFcm, deviceName: deviceName, deviceId: deviceId));
  }
}
