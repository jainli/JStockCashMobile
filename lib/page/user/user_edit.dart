import 'dart:convert';

import 'package:flutter/material.dart';
import '../../models/profil.dart';
import '../../models/userModel.dart';
import '../../page/authentification/connection.dart';
import '../../page/user/user_profil.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';


class UserEdit extends StatefulWidget {

   Map user;

  UserEdit({
    required this.user
  });

  @override
  _UserEditState createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {

  final _formKey = GlobalKey<FormState>();
  final UserService userService = UserService();
  final AuthService authService = AuthService();


  TextEditingController user_name = TextEditingController();
  TextEditingController user_surname = TextEditingController();
  TextEditingController user_tel_1 = TextEditingController();
  TextEditingController user_tel_2 = TextEditingController();
  TextEditingController user_email = TextEditingController();
  TextEditingController user_adresse = TextEditingController();
  TextEditingController user_contry = TextEditingController();
  TextEditingController user_city = TextEditingController();
  TextEditingController user_status = TextEditingController();
  TextEditingController user_cni = TextEditingController();

  //UserModel userModel = {};

  @override
  void initState() {
    setState(() {
      user_name = TextEditingController(text: widget.user['user_name']);
      user_surname = TextEditingController(text: widget.user['user_surname']);
      user_adresse = TextEditingController(text: widget.user['user_adresse']);
      user_city = TextEditingController(text: widget.user['user_city']);
      user_email = TextEditingController(text: widget.user['user_email']);
      user_tel_1 = TextEditingController(text: widget.user['user_tel_1']);
      user_tel_2 = TextEditingController(text: widget.user['user_tel_2'].toString());
      user_cni = TextEditingController(text: widget.user['user_cni'].toString());
      user_status = TextEditingController(text: widget.user['user_status_user']);
      user_contry = TextEditingController(text: widget.user['user_contry']);
    });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Modification du profil"),
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
                  //autovalidate: true,
                  child: Column(
                    children: <Widget>[
                      const Image(
                        image: AssetImage("images/users.png"),
                        height: 200,
                      ),
                      Card(
                        child: TextFormField(
                          controller: user_name,
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
                              labelText: "Name",
                              hintText: "Nom utilisateur"),
                          // keyboardType: TextInputType.text,
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          controller: user_surname,
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
                              labelText: "prenom",
                              hintText: "prénom utilisateur"),
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          controller: user_tel_1,
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
                              labelText: "Numéro de téléphone 1",
                              hintText: "Numéro de téléphone 1"),
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          controller: user_tel_2,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(
                                  Icons.add_call,
                                  size: 30,
                                ),
                              ),
                              labelText: "Numéro de téléphone 2",
                              hintText: "Numéro de téléphone 2"),
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          controller: user_email,
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
                          controller: user_adresse,
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
                          controller: user_cni,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(
                                  Icons.account_balance,
                                  size: 30,
                                ),
                              ),
                              labelText: "Numéro de carte d'identité",
                              hintText: "CNI"),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          controller: user_contry,
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
                              labelText: "Pays",
                              hintText: "Pays"),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Card(
                        child: TextFormField(
                          controller: user_city,
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
                          controller: user_status,
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
                              hintText: "votre status"),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(
                          height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: editUser,
                              child: const Text("Modifier"),
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
                                        builder: (context) => Userprofil(user: widget.user)));
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

  Future editUser() async {

    if(_formKey.currentState!.validate()) {

      var phoneExists1;
      var phoneExists2;
      var emailExists;
      var cniExists;

      SharedPreferences localStorage = await SharedPreferences.getInstance();

      var expires_in = localStorage.getString('expires_in');
      var res = await authService.autoLogout(DateTime.parse(expires_in!));

      if(res == true) {

        if (user_tel_1.text == widget.user['user_tel_1']) {

          phoneExists1 = 0;

        } else {

          phoneExists1 = await userService.phoneExists(int.parse(user_tel_1.text));

        }

        if (user_tel_2.text == null.toString() || user_tel_2.text.isEmpty) {

          phoneExists2 = 0;

        } else {

          if (user_tel_2.text.toString() == widget.user['user_tel_2'].toString()) {

            phoneExists2 = 0;

          } else {

            phoneExists2 = await userService.phoneExists(int.parse(user_tel_2.text));

          }
        }


        if (user_email.text == widget.user['user_email']) {

          emailExists = 0;

        } else {

          emailExists = await userService.emailExists(user_email.text);

        }


        if (user_cni.text == null.toString() || user_cni.text.isEmpty) {

          cniExists = 0;

        } else {

          if (user_cni.text.toString() == widget.user['user_cni'].toString()) {

            cniExists = 0;

          } else {

            cniExists = await userService.cniExists(int.parse(user_cni.text));

          }
        }


        if(phoneExists1 == 0 && phoneExists2 == 0 && emailExists == 0 && cniExists == 0) {

          _formKey.currentState!.save();

          Profil profil = Profil(id: widget.user['user_profil']);

          var user = await userService.updateUser(UserModel(id: widget.user['id'], user_name: user_name.text, user_surname: user_surname.text,
              user_tel_1: int.parse(user_tel_1.text), user_tel_2: user_tel_2.text, user_email: user_email.text,
              user_cni: user_cni.text, user_adresse: user_adresse.text, user_city: user_city.text, user_contry: user_contry.text,
              user_status_user: user_status.text, profil: profil));

          localStorage.setString('user', json.encode(user['user']));

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Userprofil(user: user['user'])));

        } else {

          if(phoneExists1 == 1) {

            SweetAlert.show(
                context,
                title: "Error Error",
                subtitle: "Le numéro de téléphone 1 existe déjà",
                style: SweetAlertStyle.error
            );

          }

          if(phoneExists2 == 1) {

            SweetAlert.show(
                context,
                title: "Error Error",
                subtitle: "Le numéro de téléphone 2 existe déjà",
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


          if(cniExists == 1) {

            SweetAlert.show(
                context,
                title: "Error Error",
                subtitle: "Le numéro de CNI existe déjà",
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

    /*return await http.post(Uri.parse("${Env.URL_PREFIX}/updateuserMob"), body: {
   "id": widget.postModel.id.toString(),
   "user_name": user_name.text,
     "surname": user_surname.text,
    "adresse": user_adresse.text,
    "city": user_city.text,
     "status": user_status.text,
    "tel": user_tel_1.text,
   "tel": user_tel_2.text,
    "password": user_password.text,
    "email": user_email.text,
     "email": user_contry.text,
   });*/
  }

}
