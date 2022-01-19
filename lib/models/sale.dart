import '../../models/CustomerModel.dart';

class Sale {

  int? id;
  String? sale_number;
  double sale_reduction;
  double sale_augmentation;
  double sale_total_amount;
  double sale_amount_has_paid;
  double sale_amount_paid;
  double sale_amount_returned;
  Customer? customer;
  int site_id;
  int checkout_id;
  int user_id;

  Sale({
    this.id,
    this.sale_number,
    required this.sale_reduction,
    required this.sale_augmentation,
    required this.sale_total_amount,
    required this.sale_amount_has_paid,
    required this.sale_amount_paid,
    required this.sale_amount_returned,
    this.customer,
    required this.site_id,
    required this.checkout_id,
    required this.user_id
  });

  Sale.fromJson(Map<String, dynamic> json):
        id = json['id'],
        sale_number = json['sale_number'],
        sale_reduction = double.parse(json['sale_reduction'].toString()),
        sale_augmentation = double.parse(json['sale_augmentation'].toString()),
        sale_total_amount = double.parse(json['sale_total_amount'].toString()),
        sale_amount_has_paid = double.parse(json['sale_amount_has_paid'].toString()),
        sale_amount_paid = double.parse(json['sale_amount_paid'].toString()),
        sale_amount_returned = double.parse(json['sale_amount_returned'].toString()),
        customer = Customer.fromJson(json),
        site_id = json['site_id'],
        checkout_id = json['checkout_id'],
        user_id = json['user_id'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'sale_number': sale_number,
    'sale_total_amount': sale_total_amount,
    'sale_amount_has_paid': sale_amount_has_paid,
  };

}