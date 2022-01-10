import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jstockcash/page/article/product_list.dart';
import 'package:jstockcash/page/authentification/connection.dart';
import 'package:jstockcash/page/checkout/checkout_show.dart';
import 'package:jstockcash/page/customer/customer_list.dart';
import 'package:jstockcash/page/home/home.dart';
import 'package:jstockcash/page/user/user_profil.dart';
import 'package:jstockcash/page/sale/sale_create.dart';
import 'package:jstockcash/page/sale/sale_list.dart';
import 'package:jstockcash/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';



class Drawers extends StatefulWidget {
  //Drawers() : super(key: key);
  //Map user;
  //final VoidCallback login;

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<Drawers> {

  AuthService authService = AuthService();

  var user;

  @override
  void initState() {

    user = {};

    // TODO: implement initState
    super.initState();
    shared().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  Future shared() async {

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final u = _prefs.getString("user");
    final userF = jsonDecode(u!) as Map;

    return userF;
    //print(user);
  }

  void logout() {

    final response;

    response = authService.lagout();

    response.then((e) {

      if(e == true) {

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Login()
            )
        );

      } else {

        SweetAlert.show(
            context,
            title: "Erreur Erreur",
            subtitle: "Impossible de se déconnecter",
            style: SweetAlertStyle.error
        );

      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        UserAccountsDrawerHeader(
          accountName:  Text('${user['user_name']}'+' '+'${user['user_surname']}'), /*Text(user['user_name']!=null?user['user_name']:'default value'),Text(user['user_name']?
              ),*/
          accountEmail: Text('${user!['user_email']}'
              ),
          currentAccountPicture: CircleAvatar(
              child: ClipOval(
            child: Image.network(
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          )),
          decoration: BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1636483528119-b6dfd7f687c9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=387&q=80'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        ListTile(
          leading: Icon(
              Icons.home,
              color: Colors.deepOrangeAccent
          ),
          title: Text('Acceuil'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home(
                          user: user,
                        )));
          },
        ),
        ListTile(
          leading: Icon(
              Icons.account_box,
            color: Colors.deepOrangeAccent
          ),
          title: Text('Mon Profil'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Userprofil(
                          user: user,
                        )));
          },
        ),
        ListTile(
          leading: Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.deepOrangeAccent
          ),
          title: Text('Ouverture de la caisse'),
          onTap: () {
            if(user['description_profils'] != "Caissier") {

              SweetAlert.show(
                  context,
                  title: "Accès impossible",
                  subtitle: "Votre profil ne vous permet pas d'acceder à cette page",
                  style: SweetAlertStyle.error
              );

            } else {

              Navigator.push(context, MaterialPageRoute(builder: (context) => SaleCreate()));

            }
          },
        ),
        ListTile(
          leading: Icon(
              Icons.local_library,
              color: Colors.deepOrangeAccent
          ),
          title: Text('Articles'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProductList()));
          },
        ),
        ListTile(
          leading: Icon(
              Icons.sell,
              color: Colors.deepOrangeAccent
          ),
          title: Text('Journal des Ventes'),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SaleList()));
          },
        ),
        ListTile(
          leading: Icon(
              Icons.money,
              color: Colors.deepOrangeAccent
          ),
          title: Text('encaissement'),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CheckoutShow()));
          },
        ),
        ListTile(
          leading: Icon(
              Icons.dvr_sharp,
              color: Colors.deepOrangeAccent
          ),
          title: Text('Fiche Client'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerList()));
          },
        ),
        ListTile(
            leading: Icon(
                Icons.phonelink_erase_sharp,
                color: Colors.deepOrangeAccent
            ),
            title: Text('Deconnexion'),
            onTap: logout
        ),
        /*
        SizedBox(
          height: 44,
          child: RaisedButton(
            color: Colors.lightBlueAccent,
            onPressed: logout,
            child: Text(
              "Deconnexion",
              style: TextStyle(fontSize: 19, color: Colors.white),
            ),
          ),
        )

         */
      ]),
    );
  }
}
