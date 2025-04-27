class AccountResponse {
  final String id;
  final String iban;
  final double balance;
  final String accountNumber;
  final DateTime createdAt;
  final double availableBalance;

  AccountResponse(
      {
      required this.id,
      required this.iban,
      required this.balance,
      required this.availableBalance,
      required this.accountNumber,
      required this.createdAt});

  factory AccountResponse.fromJson(Map<String, dynamic> json) =>
      AccountResponse(
        id: json["id"],
        iban: json["iban"],
        balance: json["balance"],
        availableBalance: json["availableBalance"],
        accountNumber: json["accountNumber"],
        createdAt: DateTime.parse(json["createdAt"])
      );
}
