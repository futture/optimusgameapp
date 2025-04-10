class CreateAccountRequest{
      final String iban;
      final String accountNumber;
      
      CreateAccountRequest({required this.iban, required this.accountNumber});

      Map<String, dynamic> toJson()
        =>{
          "iban": iban,
          "accountNumber": accountNumber
        };
}

class DepositAmountAccountRequest{
      final double amount;
      
      DepositAmountAccountRequest({required this.amount});

      Map<String, dynamic> toJson()
        =>{
          "amount": amount,
        };
}


