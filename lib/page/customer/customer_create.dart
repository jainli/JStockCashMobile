import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/CustomerModel.dart';
import '../../page/authentification/connection.dart';
import '../../page/forms/form.dart';
import '../../services/auth_service.dart';
import '../../services/customer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';

import 'customer_list.dart';




message(String msg) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}


class CustomerCreate extends StatefulWidget {
  const CustomerCreate({Key? key}) : super(key: key);

  @override
  _CustomerCreateState createState() => _CustomerCreateState();
}

class _CustomerCreateState extends State<CustomerCreate> {

  final _formKey = GlobalKey<FormState>();

  CustomerService customerService = CustomerService();
  final AuthService authService = AuthService();


  TextEditingController customer_name = TextEditingController();
  TextEditingController customer_surname = TextEditingController();
  TextEditingController customer_tel = TextEditingController();
  TextEditingController customer_email = TextEditingController();
  TextEditingController customer_adresse = TextEditingController();
  TextEditingController customer_city = TextEditingController();
  TextEditingController customer_status = TextEditingController();


  @override
  void initState() {
    setState(() {
      customer_status = TextEditingController(text: "INSCRIT");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Enregistrement d'un client "),
          backgroundColor: Color(0xFF007AC3),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const Image(
                        image: AssetImage("images/users.png"),
                        height: 200,
                      ),
                      Card(
                        child: TextFormField(
                          controller: customer_name,
                          validator: (e) =>
                          e!.isEmpty ? "veillez spécifier ce champ" : null,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                ),
                              ),
                              labelText: "Nom",
                              hintText: "Nom client"),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          controller: customer_surname,
                          validator: (e) =>
                          e!.isEmpty ? "veillez spécifier ce champ" : null,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(
                                  Icons.account_circle_outlined,
                                  size: 30,
                                ),
                              ),
                              labelText: "Prénom",
                              hintText: "prénom client"),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          controller: customer_tel,
                          validator: (e) =>
                          e!.isEmpty ? "veillez spécifier ce champ" : null,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(
                                  Icons.add_call,
                                  size: 30,
                                ),
                              ),
                              labelText: "Numéro téléphone",
                              hintText: "téléphone"),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          controller: customer_email,
                          validator: (e) =>
                          e!.isEmpty ? "veillez spécifier ce champ" : null,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(
                                  Icons.alternate_email_rounded,
                                  size: 30,
                                ),
                              ),
                              labelText: "Email",
                              hintText: "votre adresse email"),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          controller: customer_adresse,
                          validator: (e) =>
                          e!.isEmpty ? "veillez spécifier ce champ" : null,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(
                                  Icons.account_balance,
                                  size: 30,
                                ),
                              ),
                              labelText: "Adresse",
                              hintText: "Adresse"),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          controller: customer_city,
                          validator: (e) =>
                          e!.isEmpty ? "veillez spécifier ce champ" : null,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(
                                  Icons.apartment_outlined,
                                  size: 30,
                                ),
                              ),
                              labelText: "Ville",
                              hintText: "Ville"),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          controller: customer_status,
                          enabled: false,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(
                                  Icons.assignment_outlined,
                                  size: 30,
                                ),
                              ),
                              labelText: "status",
                              hintText: "votre status"),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(
                          height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 44,
                            child:  ElevatedButton(
                              onPressed: register,
                              child: const Text("Enregistrer"),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue
                              ),
                            ),
                          ),
                         SizedBox(
                           height: 44,
                           child:  ElevatedButton(
                             onPressed: () {
                               Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context) => CustomerList()));
                             },
                             child: const Text("Annuler"),
                             style: ElevatedButton.styleFrom(
                                 primary: Colors.red
                             ),
                           ),
                         )

                        ],
                      ),
                      const SizedBox(
                          height: 20.0),
                    ],
                  ),
                ),
              )),
        ));
  }

  Future<void> register() async {

    if (_formKey.currentState!.validate()) {

      SharedPreferences localStorage = await SharedPreferences.getInstance();

      var expires_in = localStorage.getString('expires_in');
      var res = await authService.autoLogout(DateTime.parse(expires_in!));

      if(res == true) {

        var phoneExists = await customerService.phoneExists(int.parse(customer_tel.text));
        var emailExists = await customerService.emailExists(customer_email.text);

        if(phoneExists == 0 && emailExists == 0) {

          _formKey.currentState!.save();

          customerService.createCustomer(Customer(name: customer_name.text, surname: customer_surname.text, tel: customer_tel.text,
              email: customer_email.text, adresse: customer_adresse.text, city: customer_city.text, status: customer_status.text));

          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomerList())
          );

        } else {

          if(phoneExists == 1) {

            SweetAlert.show(
                context,
                title: "Error Error",
                subtitle: "Le numéro de téléphone existe déjà",
                style: SweetAlertStyle.error
            );

          }

          if(emailExists == 1) {

            SweetAlert.show(
                context,
                title: "Error Error",
                subtitle: "L'email existe déjà",
                style: SweetAlertStyle.error
            );

          }
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
  }
}
