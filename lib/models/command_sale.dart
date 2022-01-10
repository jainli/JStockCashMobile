class CommandSale {

  int? id;
  int quantity_sold;
  double selling_price;
  int sale_id;
  int? product_id;
  int? product_damaged_id;

  CommandSale({
    this.id,
    required this.quantity_sold,
    required this.selling_price,
    required this.sale_id,
    this.product_id,
    this.product_damaged_id
  });
  CommandSale.fromJson(Map<String, dynamic> json):
        id = json['id'],
        quantity_sold = json['quantity_sold'],
        selling_price = json['selling_price'],
        sale_id = json['sale_id'],
        product_id = json['product_id'],
        product_damaged_id = json['product_damaged_id'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'quantity_sold': quantity_sold,
    'selling_price': selling_price,
    'sale_id': sale_id,
  };

}