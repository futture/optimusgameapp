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

class CreateUserRequest {
  final String name;
  final String email;
  final String phone_number;
  final String phone_number_mask;
  final RoleEnum role;
  final String password;

  CreateUserRequest({
    required this.name,
    required this.email,
    required this.phone_number,
    required this.phone_number_mask,
    required this.role,
    required this.password,
  }); 
  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone_number": phone_number,
        "phone_number_mask": phone_number_mask,
        "role": role.name.toString(),
        "password": password,
      };
}

class UpdateUserRequest {
  final String name;
  final String email;
  final String phone_number;

  UpdateUserRequest({
    required this.name,
    required this.email,
    required this.phone_number
  }); 
  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone_number": phone_number,
      };
}

enum RoleEnum {
  JOGADOR,
  ADMIN,
}

