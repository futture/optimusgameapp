class CreateFcmTokenRequest {
  final String? fcmToken;
  final String? deviceName;
  final String? deviceId;

  CreateFcmTokenRequest(
      {required this.fcmToken,
      required this.deviceName,
      required this.deviceId});

  Map<String, String?> toJson() {
    return {
      'fcmToken': fcmToken,
      'deviceName': deviceName,
      'deviceId': deviceId
    };
  }
}


class CreateUserRequest{
  
}