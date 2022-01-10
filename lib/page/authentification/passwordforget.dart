import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jstockcash/page/authentification/passwordforget.dart';
import 'package:jstockcash/page/widget/customTextField.dart';


class PasswordForget extends StatefulWidget {
  const PasswordForget({Key? key}) : super(key: key);

  @override
  _PasswordForgetState createState() => _PasswordForgetState();
}

class _PasswordForgetState extends State<PasswordForget> {
  TextEditingController user_email = new TextEditingController();
  // final GlobalKey<FormState> _key = GlobalKey<FormState>();
  CustomTextField user_tel_1 = new CustomTextField(
    title: "numero",
    placeholder: "Enter votre numero",
    initialValue: '',
  );
  CustomTextField user_password = new CustomTextField(
      title: "Password",
      placeholder: "***********",
      ispass: true,
      initialValue: '');
  final _key = GlobalKey<FormState>();

  Future<void> passwordForget() async {
    if (_key.currentState!.validate()) {
      Map data = {
        "email": user_email.text,
      };
      print(data);
      final response =
          await http.post(Uri.parse('http://localhost:8000/api/forgetPassUser'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
              },
              body: jsonEncode(data));
      print(response.statusCode);
      print(response.body.toString());
      print(response.request.toString());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != 1) {
          //message(data['message']);
          Navigator.pop(context);
        } else {
          // message(data['errors']);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('password reset'),
        actions: <Widget>[],
      ),
      backgroundColor: Color.fromRGBO(44, 44, 44, 0.6),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _key,
              child: Column(
                children: <Widget>[
                  const Image(
                    image: AssetImage("images/logo.png.PNG"),
                    height: 200,
                  ),
                  Card(
                    child: TextFormField(
                      controller: user_email,
                      validator: (e) =>
                          e!.isEmpty ? "veillez spécifier ce champ" : null,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20, right: 15),
                            child: Icon(
                              Icons.person,
                              size: 30,
                            ),
                          ),
                          labelText: "email",
                          hintText: "veillez entrez votre ancien Mot de passe"),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Card(
                    child: TextFormField(
                      controller: user_email,
                      validator: (e) =>
                          e!.isEmpty ? "veillez spécifier ce champ" : null,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20, right: 15),
                            child: Icon(
                              Icons.person,
                              size: 30,
                            ),
                          ),
                          labelText: "email",
                          hintText:
                              "veillez entrez votre nouveau  Mot de passe"),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    height: 44,
                    child: RaisedButton(
                      color: Colors.lightBlueAccent,
                      onPressed: passwordForget,
                      child: Text(
                        "Send",
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
