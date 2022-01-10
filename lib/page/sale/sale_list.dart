import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jstockcash/models/sale.dart';
import 'package:jstockcash/page/authentification/connection.dart';
import 'package:jstockcash/services/auth_service.dart';
import 'package:jstockcash/services/sale_service.dart';
import 'package:jstockcash/page/widget/navigatorDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';



class SaleList extends StatefulWidget {
  const SaleList({Key? key}) : super(key: key);

  @override
  _SaleListState createState() => _SaleListState();
}

class _SaleListState extends State<SaleList> {

  Widget appBarTitle = Text("Liste des ventes", style: TextStyle(color: Colors.white),);
  Icon actionIcon = Icon(Icons.search, color: Colors.white);
  TextEditingController _controller = TextEditingController();

  SaleService saleService = SaleService();
  final AuthService authService = AuthService();

  List<Sale> _sales = [];

  List<Sale> _foundSale = [];

  String? message;

  @override
  initState() {
    super.initState();

    loadList();

  }

  loadList() async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var expires_in = localStorage.getString('expires_in');
    var res = await authService.autoLogout(DateTime.parse(expires_in!));

    if(res == true) {

      shared().then((e) {

        if(e != null) {

          saleService.saleOfCheckout(e).then((value) => {
            setState(() {
              _sales = value;
              _foundSale = value;
            })
          });

        } else {

          setState(() {

            _sales = [];
            _foundSale = [];

            SweetAlert.show(
                context,
                title: "profil incorrect",
                subtitle: "Veuillez vous connecter avec un profil caissier",
                style: SweetAlertStyle.error
            );

          });
        }

      });

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

  Future shared() async {

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final u = _prefs.getString("user");
    final userF = jsonDecode(u!) as Map;

    if(userF['description_profils'] == "Caissier") {

      return userF['checkout_id'];

    } else {

      return null;

    }

  }

  void _runFilter(String enteredKeyword) {

    List<Sale> results = [];

    if(enteredKeyword.isEmpty) {

      results = _sales;

    } else {
      _sales.forEach((element) {

        if(element.sale_number.toString().toLowerCase().contains(enteredKeyword.toLowerCase()) ||
            element.customer!.name.toString().toLowerCase().contains(enteredKeyword.toLowerCase()) ||
            element.customer!.surname.toString().toLowerCase().contains(enteredKeyword.toLowerCase())) {

          results.add(element);

        }
      });

      /*
      results = _sales.where((sale) =>
          sale.sale_number.toString().toLowerCase().contains(enteredKeyword.toLowerCase())
      ).toList();
      */
    }

    setState(() {
      _foundSale = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des ventes"),
        backgroundColor: Color(0xFF007AC3),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                labelText: 'Search...', //suffixIcon: Icon(Icons.search),
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: _foundSale.isNotEmpty
                    ? ListView.builder(
                    itemCount: _foundSale.length,
                    itemBuilder: (context, index) => Card(
                      key: ValueKey(_foundSale[index].id),
                      color: Colors.amberAccent,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Text(
                          _foundSale[index].sale_number.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        title: Text(_foundSale[index].sale_amount_has_paid.toString()+' '+'A Payer'),
                        subtitle: Text(_foundSale[index].sale_amount_paid.toString()+' '+'Payé'),
                        trailing: Text(_foundSale[index].customer!.name.toString()+' '+_foundSale[index].customer!.surname.toString()),
                        onTap: () {
                          print(_foundSale[index].sale_number.toString());
                        },
                      ),
                    ))
                    : const SizedBox(
                        height: 30,
                        width: 30,
                        child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3.5,
                            )
                        )
                    ),
            )
          ],
        ),
      ),
      drawer: Drawers(),
    );
  }

}