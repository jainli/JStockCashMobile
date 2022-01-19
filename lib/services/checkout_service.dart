import 'dart:convert';

import '../../page/widget/api.dart';


class CheckoutService {

  final callApi = CallApi();

  Future findCheckout(int idCheckout) async {

    var response = await callApi.getData('checkoutMob/$idCheckout');


    if(response.statusCode == 200) {

      if(jsonDecode(response.body)['checkout'] == null) {

        return null;

      } else {

        Map<String, dynamic> checkoutMap = jsonDecode(response.body);

        return checkoutMap;


      }

    } else {

      throw Exception("Erreur survenue lors de la récuperation des informations de la caisse");

    }

  }

  Future amountOfCheckoutToday(int idCheckout) async {

    var response = await callApi.getData('amountOfCheckoutToday/$idCheckout');

    if(response.statusCode == 200) {


      if(jsonDecode(response.body)['amount'] == null) {

        return null;

      } else {

        Map<String, dynamic> amount = jsonDecode(response.body)['amount'];

        return amount;

      }

    } else {

      throw Exception("Erreur survenue lors de la récuperation des informations de la caisse");

    }

  }

}