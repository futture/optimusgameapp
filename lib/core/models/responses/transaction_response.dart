class TransactionResponse {
  final String id;
  final String type;
  final double amount;
  final String accountId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;

  TransactionResponse({
    required this.id,
    required this.type,
    required this.amount,
    required this.accountId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
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
      );
}
