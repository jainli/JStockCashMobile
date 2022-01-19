import 'dart:convert';

import '../../page/widget/api.dart';
import '../../models/product.dart';

class ProductService {

  final callApi = CallApi();

  Future<List<Product>> getProducts() async {

    var response = await callApi.getData('productMob');

    if(response.statusCode == 200) {

      final items = jsonDecode(response.body)['products'].cast<Map<String, dynamic>>();

      List<Product> products = items.map<Product>((json) {
        return Product.fromJson(json);
      }).toList();

      return products;

    } else {

      throw Exception('Failed to load products');

    }

  }

  Future fetchProductByBarCode(String barCode) async {

    var response = await callApi.getData('showProductByBarcodeMob/$barCode');

    if(response.statusCode == 200) {

      if(jsonDecode(response.body)['product'] == null) {

        return null;

      } else {

        return Product.fromJson(jsonDecode(response.body)['product']);

      }

    } else {

      throw Exception("Erreur survenue lors de la récuperation des informations du produit");

    }
  }

  /*
  Future<void> deleteProduct(int id) async {

    final response = await http.delete(Uri.parse('$apiUrl/product/$id'));

    if(response.statusCode == 200) {

      print("Case deleted");

    } else {

      throw "Failed to delete a case.";

    }
  }

   */
}