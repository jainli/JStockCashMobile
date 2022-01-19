import 'dart:convert';

import '../../page/widget/api.dart';
import '../../models/command_sale.dart';


class CommandSaleService {

  final callApi = CallApi();

  Future createCommandSale(CommandSale commandSale) async {

    Map data = {
      'quantity_sold': commandSale.quantity_sold,
      'selling_price': commandSale.selling_price,
      'sale_id': commandSale.sale_id,
      'product_id': commandSale.product_id,
      'product_damaged_id': commandSale.product_damaged_id,
    };

    var response = await callApi.postData(data, 'command_saleMob');

    if(response.statusCode == 200) {

      return jsonDecode(response.body);

    } else {

      throw Exception('Failed to post a command sale');

    }
  }
}