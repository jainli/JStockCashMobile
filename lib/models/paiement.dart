class Paiement {

  int? id;
  String means_payment;
  double paiement_amount;
  int? sale_id;
  int? purchase_order_id ;
  int? purchase_order_site_id;
  int user_id;

  Paiement({
    this.id,
    required this.means_payment,
    required this.paiement_amount,
    this.sale_id,
    this.purchase_order_id,
    this.purchase_order_site_id,
    required this.user_id
  });

  Paiement.fromJson(Map<String, dynamic> json):
        id = json['id'],
        means_payment = json['means_payment'],
        paiement_amount = json['paiement_amount'],
        sale_id = json['sale_id'],
        purchase_order_id = json['purchase_order_id'],
        purchase_order_site_id = json['purchase_order_site_id'],
        user_id = json['user_id'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'means_payment': means_payment,
    'paiement_amount': paiement_amount,
  };

}