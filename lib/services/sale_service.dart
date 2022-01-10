import 'dart:convert';

import 'package:jstockcash/page/widget/api.dart';
import 'package:jstockcash/models/sale.dart';


class SaleService {

  final callApi = CallApi();

  Future createSale(Sale sale) async {

    Map data = {
      'sale_reduction': sale.sale_reduction,
      'sale_augmentation': sale.sale_augmentation,
      'sale_total_amount': sale.sale_total_amount,
      'sale_amount_has_paid': sale.sale_amount_has_paid,
      'sale_amount_paid': sale.sale_amount_paid,
      'sale_amount_returned':  sale.sale_amount_returned,
      'site_id': sale.site_id,
      'checkout_id': sale.checkout_id,
      'user_id': sale.user_id,
      'customer_id': sale.customer?.id
    };

    var response = await callApi.postData(data, 'saleMob');

    if(response.statusCode == 200) {

      Map<String, dynamic> saleMap = jsonDecode(response.body);

      return saleMap;

    } else {

      throw Exception('Failed to post a sale');

    }
  }

  Future<List<Sale>> saleOfCheckout(int idCheckout) async {

    var response = await callApi.getData('saleOfCheckout/$idCheckout');

    if(response.statusCode == 200) {

      final items = jsonDecode(response.body)['sales'].cast<Map<String, dynamic>>();

      List<Sale> sales = items.map<Sale>((json) {
        return Sale.fromJson(json);
      }).toList();

      return sales;

      //return jsonDecode(response.body);

    } else {

      throw Exception('Failed to load sales');

    }

  }
}