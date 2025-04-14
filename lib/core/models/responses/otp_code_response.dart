class OtpCodeResponse {
  final String phoneNumber;
  final String code;
  final DateTime expirationDate;

  OtpCodeResponse({
    required this.phoneNumber,
    required this.code,
    required this.expirationDate,
  });

  factory OtpCodeResponse.fromJson(Map<String, dynamic> json) {
    return OtpCodeResponse(
      phoneNumber: json['phone_number'],
      code: json['code'],
      expirationDate: DateTime.parse(json['expiration_data']),
    );
  }
}
