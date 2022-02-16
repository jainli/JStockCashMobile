import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/checkout.dart';
import '../../page/authentification/connection.dart';
import '../../page/widget/navigatorDrawer.dart';
import '../../services/auth_service.dart';
import '../../services/checkout_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CheckoutShow extends StatefulWidget {
  const CheckoutShow({Key? key}) : super(key: key);

  @override
  _CheckoutShowState createState() => _CheckoutShowState();
}

class _CheckoutShowState extends State<CheckoutShow> {

  CheckoutService checkoutService = CheckoutService();
  final AuthService authService = AuthService();

  var user;
  var _amountCheckout;
  var _amountCheckoutToday;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    user = {};
    _amountCheckoutToday = null;
    _amountCheckout = null;

    shared().then((value) {
      setState(() {
        user = value;
      });
    });

    loadInfo();

  }

  Future shared() async {

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final u = _prefs.getString("user");
    final userF = jsonDecode(u!) as Map;

    return userF;

  }

  loadInfo() async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var expires_in = localStorage.getString('expires_in');
    var res = await authService.autoLogout(DateTime.parse(expires_in!));

    if(res == true) {

      if(user['description_profils'] == "Caissier") {

        var amountFinal;

        var amount = await checkoutService.amountOfCheckoutToday(int.parse(user['checkout_id'].toString()));

        if (amount['montant'] == null) {

          amountFinal = 0;

        } else {

          amountFinal = amount['montant'];

        }

        setState(() {

          _amountCheckoutToday =  amountFinal.toString();

        });


        var val = await checkoutService.findCheckout(int.parse(user['checkout_id'].toString()));

        setState(() {

          _amountCheckout =  val['checkout']['checkout_amount'].toString();

        });

      } else {

        _amountCheckoutToday = 0.toString();
        _amountCheckout = 0.toString();

      }

    } else {

      setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Login()
            )
        );
      });

    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.deepPurple,
        backgroundColor: Color(0xFF007AC3),
        title: const Text('Somme Totale Encaissé', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
     body:  Stack(
       children: [
         Container(height: 1000),
         Positioned(
           top: 0,
           child: Container(
             color: Color(0xFF007AC3),
             width: MediaQuery.of(context).size.width,
             height: MediaQuery.of(context).size.height * .35,
           ),
         ),
         Positioned(
           top: MediaQuery.of(context).size.height * .25,
           left: 15,
           right: 15,
           child: Card(
             elevation: 8,
             color: Colors.white,
             shape:
             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
             child: Container(
               width: MediaQuery.of(context).size.height * .90,
               height: 220,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: <Widget>[
                   Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       const Icon(
                         Icons.money_rounded,
                         color: Colors.deepOrangeAccent,
                         size: 45,
                       ),
                       const Text("Encaissement journalier"),
                       const SizedBox(
                         height: 20,
                       ),
                       Text(_amountCheckoutToday ?? 'Loading...', style: const TextStyle(fontSize: 20)),
                     ],
                   ),
                   Container(
                     height: 100,
                     width: 2,
                     color: Colors.deepPurple,
                   ),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       const Icon(
                         Icons.monetization_on,
                         color: Colors.deepOrangeAccent,
                         size: 45,
                       ),
                       const Text("Somme total encaissé"),
                       const SizedBox(
                         height: 20,
                       ),
                       Text(_amountCheckout ?? 'Loading...', style: const TextStyle(fontSize: 20)),
                     ],
                   )

                 ],
               ),
             ),
           ),
         ),
       ],
     ),
      drawer: Drawers(),
    );
  }
}

