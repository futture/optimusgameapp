class TransactionResponse {
  final String type;
  final double amount;
  final String account_id;

  TransactionResponse({
    required this.type,
    required this.amount,
    required this.account_id,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      TransactionResponse(
        type: json["type"],
        amount: json["amount"],
        account_id: json["account_id"]
    );
  }