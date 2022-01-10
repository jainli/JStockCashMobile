class Checkout {

  int? id;
  String? checkout_number;
  String checkout_description;
  double checkout_amount;
  int site_id;

  Checkout({
    this.id,
    this.checkout_number,
    required this.checkout_description,
    required this.checkout_amount,
    required this.site_id,
  });

  Checkout.fromJson(Map<String, dynamic> json):
        id = json['id'],
        checkout_number = json['checkout_number'],
        checkout_description = json['checkout_description'],
        checkout_amount = json['checkout_amount'],
        site_id = json['site_id'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'checkout_number': checkout_number,
    'checkout_description': checkout_description,
    'checkout_amount': checkout_amount,
  };

}