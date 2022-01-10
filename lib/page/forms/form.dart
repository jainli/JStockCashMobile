import 'package:flutter/material.dart';

class AppForm extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // AppForm({ Key? key }) : super(key: key);
  TextEditingController customer_name = new TextEditingController();
  TextEditingController customer_surname = new TextEditingController();
  TextEditingController customer_adresse = new TextEditingController();
  TextEditingController customer_city = new TextEditingController();
  TextEditingController customer_status = new TextEditingController();
  TextEditingController customer_tel = new TextEditingController();
  TextEditingController customer_email = new TextEditingController();
  TextEditingController customer_username = new TextEditingController();
  TextEditingController customer_password = new TextEditingController();

  AppForm({
    required this.formKey,
    required this.customer_name,
    required this.customer_surname,
    required this.customer_adresse,
    required this.customer_city,
    required this.customer_status,
    required this.customer_tel,
    required this.customer_email,
  });
  @override
  _AppFormState createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  final _key = GlobalKey<FormState>();
  TextEditingController customer_name = new TextEditingController();
  TextEditingController customer_surname = new TextEditingController();
  TextEditingController customer_adresse = new TextEditingController();
  TextEditingController customer_city = new TextEditingController();
  TextEditingController customer_status = new TextEditingController();
  TextEditingController customer_tel = new TextEditingController();
  TextEditingController customer_email = new TextEditingController();
  TextEditingController customer_username = new TextEditingController();
  TextEditingController customer_password = new TextEditingController();

  String _validateName(String value) {
    if (value.length < 3) return 'Name must be more than 2 charater';
    return "null";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: widget.formKey,
              //autovalidate: true,
              child: Column(
                children: <Widget>[
                  const Image(
                    image: AssetImage("images/users.png"),
                    height: 200,
                  ),
                  Card(
                    child: TextFormField(
                      controller: widget.customer_name,
                      keyboardType: TextInputType.text,
                      validator: (e) =>
                          e!.isEmpty ? "veillez spécifier ce champ" : null,
                      // validator: _validateName,
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
                      // keyboardType: TextInputType.text,
                    ),
                  ),
                  Card(
                    child: TextFormField(
                      controller: widget.customer_surname,
                      keyboardType: TextInputType.text,
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
                          hintText: "Prénom client"),
                    ),
                  ),
                  Card(
                    child: TextFormField(
                      controller: widget.customer_tel,
                      keyboardType: TextInputType.phone,
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
                          labelText: "Numéro de téléphone",
                          hintText: "Numéro de téléphone"),
                    ),
                  ),
                  Card(
                    child: TextFormField(
                      controller: widget.customer_email,
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
                          hintText: "Votre adresse email"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Card(
                    child: TextFormField(
                      controller: widget.customer_adresse,
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
                      controller: widget.customer_city,
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
                      controller: widget.customer_status,
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
                          labelText: "Status",
                          hintText: "Votre status"),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  // Card(
                  //   child: TextFormField(
                  //     validator: (e) =>
                  //         e!.isEmpty ? "veillez spécifier ce champ" : null,
                  //     decoration: InputDecoration(
                  //         contentPadding: EdgeInsets.all(20),
                  //         prefixIcon: Padding(
                  //           padding: EdgeInsets.only(left: 20, right: 15),
                  //           child: Icon(
                  //             Icons.person,
                  //             size: 30,
                  //           ),
                  //         ),
                  //         labelText: "Password",
                  //         hintText: "Votre mot de passe"),
                  //     keyboardType: TextInputType.text,
                  //   ),
                  // ),
                  // FlatButton(
                  //   onPressed: () {},
                  //   child: Text(
                  //     "Forgot Password",
                  //     style: TextStyle(
                  //         fontSize: 19,
                  //         color: Colors.lightBlueAccent,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 44,
                  //   child: RaisedButton(
                  //     color: Colors.red,
                  //     onPressed: register,
                  //     child: Text(
                  //       "Register",
                  //       style: TextStyle(fontSize: 19, color: Colors.black),
                  //     ),
                  //   ),
                  // ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     Text(
                  //       "Avez-vous un compte ?",
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //     FlatButton(
                  //         onPressed: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => AuthScreen()));
                  //         },
                  //         child: Text(
                  //           "Login",
                  //           style: TextStyle(
                  //               color: Colors.lightBlueAccent,
                  //               fontWeight: FontWeight.bold),
                  //         )),
                  //   ],
                  // )
                ],
              ),
            ),
          )),
        ));
  }
}
