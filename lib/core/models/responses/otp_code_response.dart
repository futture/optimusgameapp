class OtpCodeResponse {
  final String phoneNumber;
  final String code;
  final bool isValid;
  final DateTime? expirationDate;

  OtpCodeResponse({
    required this.phoneNumber,
    required this.code,
    required this.isValid,
    required this.expirationDate,
  });

  factory OtpCodeResponse.fromJson(Map<String, dynamic> json) {
    return OtpCodeResponse(
      phoneNumber: json['phone_number'],
      code: json['code'],
      isValid: json['isValid'],
      expirationDate: json['expiration_data'] != null
          ? DateTime.parse(json['expiration_data'])
          : null,
    );
  }
}
