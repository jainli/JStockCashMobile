import 'dart:convert';

import '../../page/widget/api.dart';
import '../../models/product_damaged.dart';


class ProductDamagedService {

  final callApi = CallApi();

  Future fetchProductDamagedAccordingBarCode(String barCode) async {

    var response = await callApi.getData('readProductDamagedAccordingBarCodeMob/$barCode');

    if(response.statusCode == 200) {

      if(jsonDecode(response.body)['product_damaged'] == null) {

        return null;

      } else {

        return ProductDamaged.fromJson(jsonDecode(response.body)['product_damaged']);

      }

    } else {

      throw Exception("Erreur survenue lors de la récuperation des informations du produit endommagé");

    }
  }

}