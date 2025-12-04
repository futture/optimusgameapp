class TransactionResponse {
  final String id;
  final String type;
  final double amount;
  final String accountId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final int? reference;

  TransactionResponse({
    required this.id,
    required this.type,
    required this.amount,
    required this.accountId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.reference,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      TransactionResponse(
        id: json["id"],
        type: json["type"],
        amount: (json["amount"] as num).toDouble(),
        accountId: json["account_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        status: json["status"],
        reference: json["reference"] != null ? json["reference"] as int : null,
      );
}
