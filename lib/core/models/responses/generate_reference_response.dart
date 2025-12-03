class GenerateReferenceResponse {
  final int Reference;

  GenerateReferenceResponse({required this.Reference});

  factory GenerateReferenceResponse.fromJson(Map<String, dynamic> json) =>
      GenerateReferenceResponse(
        Reference: json["reference"]
      );
}
