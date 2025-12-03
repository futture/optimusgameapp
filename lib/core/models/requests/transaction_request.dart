class TransactionRequest {
  final String type;
  final double amount;
  final String account_id;
  final String? reference;
  final String? transactionMethod;

  TransactionRequest({
    required this.type,
    required this.amount,
    required this.account_id,
    this.reference,
    this.transactionMethod,
  });

  Map<String, dynamic> toJson() => {
        "type": type,
        "amount": amount,
        "account_id": account_id,
        "reference": reference,
        "transactionMethod": transactionMethod,
      };
}
