import 'dart:convert';

import 'package:jstockcash/page/widget/api.dart';
import 'package:jstockcash/models/paiement.dart';


class PaiementService {

  final callApi = CallApi();


  Future createPaiement(Paiement paiement) async {

    Map data = {
      'means_payment': paiement.means_payment,
      'paiement_amount': paiement.paiement_amount,
      'sale_id': paiement.sale_id,
      'purchase_order_id': paiement.purchase_order_id,
      'purchase_order_site_id': paiement.purchase_order_site_id,
      'user_id': paiement.user_id
    };

    var response = await callApi.postData(data, 'paiementMob');

    if(response.statusCode == 200) {

      return jsonDecode(response.body);

    } else {

      throw Exception('Failed to post a paiement');

    }
  }
}