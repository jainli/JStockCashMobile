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
        id = int.parse(json['id'].toString()),
        product_damaged_title = json['product_damaged_title'],
        product_damaged_bar_code = json['product_damaged_bar_code'],
        product_damaged_quantity = int.parse(json['product_damaged_quantity'].toString()),
        product_damaged_selling_price = int.parse(json['product_damaged_selling_price'].toString()),
        product_damaged_status = json['product_damaged_status'],
        product_expiry_date = json['product_expiry_date'],
        product_damaged_qteSelling = int.parse(json['product_damaged_qteSelling'].toString()),
        product_id = int.parse(json['product_id'].toString()),
        location_id = int.parse(json['location_id'].toString());

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_damaged_title': product_damaged_title,
    'product_damaged_bar_code': product_damaged_bar_code,
    'product_damaged_selling_price': product_damaged_selling_price
  };

}