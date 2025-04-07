class ErrorResponse {
  final String? code;
  final String? message;
  final String? details;
  final List<String>? errors;

  ErrorResponse(
      {this.code,
      this.message,
      this.details,
      this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      code: json["code"] ?? "",
      message: json["message"] ?? "",
      details: json["details"] ?? "",
      errors:
          (json["errs"] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
              [],
    );
  }

  @override
  String toString() {
    return 'Code: $code\nMessage: $message\nDetails: $details\nErrors: $errors';
  }
}
