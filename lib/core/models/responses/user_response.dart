class UserResponse {
  final String id;
  final String name;
  final String email;
  final String phone_number;
  final String phone_number_mask;
  final RoleResponse? role;

  UserResponse(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone_number,
      required this.phone_number_mask,
      required this.role});

  factory UserResponse.FromJson(Map<String, dynamic> json) => UserResponse(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone_number: json["phone_number"],
      phone_number_mask: json["phone_number_mask"],
      role: json['role'] != null
        ? RoleResponse.FromJson(json['role'])
        : null);
}

class RoleResponse {
  final String id;
  final String designation;

  RoleResponse({required this.id, required this.designation});

  factory RoleResponse.FromJson(Map<String, dynamic> json) => RoleResponse(
      id: json["id"],
      designation: json["designation"]);
}
