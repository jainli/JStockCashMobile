import '../../models/category.dart';
import '../../models/mark.dart';
import '../../models/sub_category.dart';

class Product {

  final int id;
  final String product_title;
  final double product_buying_price;
  final double product_selling_price;
  final String product_designation;
  final String product_bar_code;
  final String product_unit;
  final int product_damage;
  final String? product_image;
  final Mark mark;
  final Category category;
  final SubCategory? sub_category_id;

  Product(
      this.id,
      this.product_title,
      this.product_buying_price,
      this.product_selling_price,
      this.product_designation,
      this.product_bar_code,
      this.product_unit,
      this.product_damage,
      this.product_image,
      this.mark,
      this.category,
      this.sub_category_id
      );

  Product.fromJson(Map<String, dynamic> json):
        id = int.parse(json['id'].toString()),
        product_title = json['product_title'],
        product_buying_price = double.parse(json['product_buying_price'].toString()),
        product_selling_price = double.parse(json['product_selling_price'].toString()),
        product_designation = json['product_designation'],
        product_bar_code = json['product_bar_code'],
        product_unit = json['product_unit'],
        product_damage = int.parse(json['product_damage'].toString()),
        product_image = json['product_image'],
        mark = Mark.fromJson(json),
        category = Category.fromJson(json),
        sub_category_id = SubCategory.fromJson(json);

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_title': product_title,
    'product_buying_price': product_buying_price,
    'product_selling_price': product_selling_price
  };

}