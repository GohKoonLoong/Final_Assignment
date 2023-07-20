class CardModel {
  String? bankName;
  String? cardNumber;
  String? cardExpiry;
  String? cvv;

  CardModel({
    this.bankName,
    this.cardNumber,
    this.cardExpiry,
    this.cvv,
  });

  CardModel.fromJson(Map<String, dynamic> json) {
    bankName = json['bank_name'];
    cardNumber = json['card_number'];
    cardExpiry = json['card_expiry'];
    cvv = json['card_cvv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bank_name'] = bankName;
    data['card_number'] = cardNumber;
    data['card_expiry'] = cardExpiry;
    data['card_cvv'] = cvv;
    return data;
  }
}
