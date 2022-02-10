import 'dart:convert';

import 'package:flutter/material.dart';
import '../../page/article/product_list.dart';
import '../../page/authentification/connection.dart';
import '../../page/checkout/checkout_show.dart';
import '../../page/customer/customer_list.dart';
import '../../page/home/home.dart';
import '../../page/user/user_profil.dart';
import '../../page/sale/sale_create.dart';
import '../../page/sale/sale_list.dart';
import '../../services/auth_service.dart';
import '../../page/widget/environnement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';


class Drawers extends StatefulWidget {

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<Drawers> {

  final String _urlImage = Environnement.URL_PREFIX_IMAGE;

  AuthService authService = AuthService();

  var user;

  bool _log = true;

  @override
  void initState() {
    super.initState();
    user = {};

    // TODO: implement initState
    super.initState();
    shared().then((value) {
      setState(() {
        user = value;

        if(user['user_image_user'].toString() == null.toString()) {

          setState(() {

            _log = false;

          });

        }

      });
    });
  }

  Future shared() async {

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final u = _prefs.getString("user");
    final userF = jsonDecode(u!) as Map;

    return userF;

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

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Login()
            )
        );

      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(144),
            child:  UserAccountsDrawerHeader(
              accountName:  Text(
                '${user['user_name']}'+' '+'${user['user_surname']}',
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                '${user!['user_email']}',
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: _log
                        ? Image.network(
                          _urlImage+'/${user!['user_image_user']}',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        )
                        : Image.network(
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        )
                  )),
              decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1636483528119-b6dfd7f687c9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=387&q=80'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(
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
                leading: const Icon(
                    Icons.account_box,
                    color: Colors.deepOrangeAccent
                ),
                title: const Text('Mon Profil'),
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
                leading: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.deepOrangeAccent
                ),
                title: const Text('Ouverture de la caisse'),
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
                leading: const Icon(
                    Icons.local_library,
                    color: Colors.deepOrangeAccent
                ),
                title: const Text('Articles'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProductList()));
                },
              ),
              ListTile(
                leading: const Icon(
                    Icons.sell,
                    color: Colors.deepOrangeAccent
                ),
                title: const Text('Journal des Ventes'),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SaleList()));
                },
              ),
              ListTile(
                leading: const Icon(
                    Icons.money,
                    color: Colors.deepOrangeAccent
                ),
                title: const Text('encaissement'),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => CheckoutShow()));
                },
              ),
              ListTile(
                leading: const Icon(
                    Icons.dvr_sharp,
                    color: Colors.deepOrangeAccent
                ),
                title: const Text('Fiche Client'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerList()));
                },
              ),
              ListTile(
                  leading: const Icon(
                      Icons.logout_outlined,
                      color: Colors.deepOrangeAccent
                  ),
                  title: const Text('Deconnexion'),
                  onTap: logout
              ),
            ],
          ),
          bottomNavigationBar: Container(
            color: Colors.deepOrangeAccent,
            height: 70,
            child: Column(
              children: [
                const SizedBox(height: 5.0),
                Image.asset(
                  'images/icone.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 5.0),
                const Text(
                    "© 2021 - 2022 JStockCashMobile V1.0",
                    style: TextStyle(
                        fontSize: 10.0, fontStyle: FontStyle.italic
                    )
                ),
                const SizedBox(height: 5.0),
                const Text(
                    "All Rights Reserved",
                    style: TextStyle(
                        fontSize: 10.0, fontStyle: FontStyle.italic
                    )
                ),
                /*
                ListTile(
                  title: Text("Settings"),
                  leading: Icon(Icons.settings_outlined),
                  onTap: () {},
                ),
                ListTile(
                  title: Text("Help"),
                  leading: Icon(Icons.help_outline_outlined),
                  onTap: () {},
                ),
                ListTile(
                  title: Text("Log Out"),
                  leading: Icon(Icons.logout_outlined),
                  onTap: () {},
                ),

                 */
              ],
            ),
          )),
    );
    /*
    return Drawer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              child: ConstrainedBox(
                constraints: constraints.copyWith(
                  minHeight: constraints.maxHeight,
                  maxHeight: double.infinity,
                ),
                child: IntrinsicHeight(
                  child: SafeArea(
                    child: Column(
                      children: [
                        Column(
                          children: <Widget>[
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
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://images.unsplash.com/photo-1636483528119-b6dfd7f687c9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=387&q=80'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
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
                              leading: const Icon(
                                  Icons.account_box,
                                  color: Colors.deepOrangeAccent
                              ),
                              title: const Text('Mon Profil'),
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
                              leading: const Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: Colors.deepOrangeAccent
                              ),
                              title: const Text('Ouverture de la caisse'),
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
                              leading: const Icon(
                                  Icons.local_library,
                                  color: Colors.deepOrangeAccent
                              ),
                              title: const Text('Articles'),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => ProductList()));
                              },
                            ),
                            ListTile(
                              leading: const Icon(
                                  Icons.sell,
                                  color: Colors.deepOrangeAccent
                              ),
                              title: const Text('Journal des Ventes'),
                              onTap: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => SaleList()));
                              },
                            ),
                            ListTile(
                              leading: const Icon(
                                  Icons.money,
                                  color: Colors.deepOrangeAccent
                              ),
                              title: const Text('encaissement'),
                              onTap: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => CheckoutShow()));
                              },
                            ),
                            ListTile(
                              leading: const Icon(
                                  Icons.dvr_sharp,
                                  color: Colors.deepOrangeAccent
                              ),
                              title: const Text('Fiche Client'),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CustomerList()));
                              },
                            ),
                            ListTile(
                                leading: const Icon(
                                    Icons.phonelink_erase_sharp,
                                    color: Colors.deepOrangeAccent
                                ),
                                title: const Text('Deconnexion'),
                                onTap: logout
                            ),
                          ],
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              color: Colors.deepOrangeAccent,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'images/icone.png',
                                        height: 40,
                                        width: 40,
                                      ),
                                      const SizedBox(height: 5.0),
                                      const Text(
                                          "© 2021 - 2022 JStockCashMobile V1.0",
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold
                                          )
                                      ),
                                      const SizedBox(height: 5.0),
                                      const Text(
                                          "All Rights Reserved",
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold
                                          )
                                      ),
                                    ],
                                  ),
                                )
                            )
                            /*
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'images/logo_noir.png',
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 5.0),
                                const Text(
                                    "© 2021 - 2022 JStockCashMobile V1.0",
                                    style: TextStyle(
                                        fontSize: 10.0, fontStyle: FontStyle.italic
                                    )
                                ),
                                const SizedBox(height: 5.0),
                                const Text(
                                    "All Rights Reserved",
                                    style: TextStyle(
                                        fontSize: 10.0, fontStyle: FontStyle.italic
                                    )
                                ),
                                const SizedBox(height: 5.0),
                              ],
                            ),*/
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

     */
  }
}
