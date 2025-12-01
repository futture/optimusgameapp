class GenerateReferenceRequest {
  final String Amount;
  final String AccountId;
  final String? UserId;

  GenerateReferenceRequest(
      {required this.Amount, required this.AccountId, this.UserId});

  Map<String, dynamic> toJson() => {
        "userId": this.UserId,
        "amount": this.Amount,
        "accountId": this.AccountId
      };
}
