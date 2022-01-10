class ProductDamaged {

  final int id;
  final String product_damaged_title;
  final String product_damaged_bar_code;
  final int? product_damaged_quantity;
  final int product_damaged_selling_price;
  final String? product_damaged_status;
  final DateTime? product_expiry_date;
  final int? product_damaged_qteSelling;
  final int? product_id;
  final int? location_id;

  ProductDamaged(
      this.id,
      this.product_damaged_title,
      this.product_damaged_bar_code,
      this.product_damaged_quantity,
      this.product_damaged_selling_price,
      this.product_damaged_status,
      this.product_expiry_date,
      this.product_damaged_qteSelling,
      this.product_id,
      this.location_id,
      );

  ProductDamaged.fromJson(Map<String, dynamic> json):
        id = json['id'],
        product_damaged_title = json['product_damaged_title'],
        product_damaged_bar_code = json['product_damaged_bar_code'],
        product_damaged_quantity = json['product_damaged_quantity'],
        product_damaged_selling_price = json['product_damaged_selling_price'],
        product_damaged_status = json['product_damaged_status'],
        product_expiry_date = json['product_expiry_date'],
        product_damaged_qteSelling = json['product_damaged_qteSelling'],
        product_id = json['product_id'],
        location_id = json['location_id'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_damaged_title': product_damaged_title,
    'product_damaged_bar_code': product_damaged_bar_code,
    'product_damaged_selling_price': product_damaged_selling_price
  };

}