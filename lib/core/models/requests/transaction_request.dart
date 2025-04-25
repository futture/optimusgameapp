class TransactionRequest {
  final String type;
  final double amount;
  final String account_id;

  TransactionRequest({
    required this.type,
    required this.amount,
    required this.account_id,
  });

  Map<String, dynamic> toJson() => {
        "type": type,
        "amount": amount,
        "account_id": account_id,
      };
}
