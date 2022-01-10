import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jstockcash/page/authentification/connection.dart';
import 'package:jstockcash/page/customer/customer_list.dart';
import 'package:jstockcash/page/user/user_profil.dart';
import 'package:jstockcash/page/widget/navigatorDrawer.dart';
import 'package:jstockcash/page/article/product_list.dart';
import 'package:jstockcash/page/sale/sale_create.dart';
import 'package:jstockcash/page/sale/sale_list.dart';
import 'package:jstockcash/page/checkout/checkout_show.dart';
import 'package:jstockcash/services/auth_service.dart';
import 'package:sweetalert/sweetalert.dart';


class Home extends StatefulWidget {

  Home({
    required this.user,
  });

  Map user;
  // Home();

  @override
  State<Home> createState() => _HomeState();
}

@override
Widget build(BuildContext context) {
  return Scaffold();
}

class _HomeState extends State<Home> {

  AuthService authService = AuthService();

  void initState() {
    // TODO: implement initState
    super.initState();
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Page d'accueil"),
          backgroundColor: Color(0xFF007AC3),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(
                  FontAwesomeIcons.signOutAlt,
                  color: Colors.white,
                ),
                onPressed: logout
                ),
            /*IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  UserModel.getUser();
                }),*/
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Userprofil(
                              user: widget.user,
                            )
                        )
                    );
                  },
                  splashColor: Colors.blue,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.account_box, size: 70.0, color: Colors.orange),
                        Text("Profil", style: new TextStyle(fontSize: 17.0)),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    if(widget.user['description_profils'] != "Caissier") {

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
                  splashColor: Colors.blue,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.account_balance_wallet_outlined, size: 70.0, color: Colors.brown),
                        Text("Ouverture de la caisse", style: new TextStyle(fontSize: 17.0)),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductList()));
                  },
                  splashColor: Colors.blue,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.local_library, size: 70.0, color: Colors.red),
                        Text("Articles", style: new TextStyle(fontSize: 17.0)),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SaleList()));
                  },
                  splashColor: Colors.blue,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.sell, size: 70.0, color: Colors.blueGrey),
                        Text("Journal des ventes", style: new TextStyle(fontSize: 17.0)),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutShow()));
                  },
                  splashColor: Colors.blue,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.money, size: 70.0, color: Colors.green),
                        Text("Encaissement", style: new TextStyle(fontSize: 17.0)),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerList()));
                  },
                  splashColor: Colors.blue,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.dvr_sharp, size: 70.0, color: Colors.yellow),
                        Text("Fiche client", style: new TextStyle(fontSize: 17.0)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: Drawers(),
    );
  }
}