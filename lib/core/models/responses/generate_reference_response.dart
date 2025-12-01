class GenerateReferenceResponse {
  final String Reference;

  GenerateReferenceResponse({required this.Reference});

  factory GenerateReferenceResponse.fromJson(Map<String, dynamic> json) =>
      GenerateReferenceResponse(
        Reference: json["reference"]
      );
}
