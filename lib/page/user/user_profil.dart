import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jstockcash/page/widget/environnement.dart';
import '../../models/userModel.dart';
import '../../page/user/user_edit.dart';
import '../../page/widget/navigatorDrawer.dart';
import '../../services/auth_service.dart';
import 'package:sweetalert/sweetalert.dart';
import '../../page/authentification/connection.dart';


class Userprofil extends StatefulWidget {

  Map? user;

  Userprofil({required this.user,});

  @override
  _UserprofilState createState() => _UserprofilState();
}

class _UserprofilState extends State<Userprofil> {

  AuthService authService = AuthService();

  final String _urlImage = Environnement.URL_PREFIX_IMAGE;

  bool _log = true;


  @override
  void initState() {
    super.initState();

    if(widget.user!['user_image_user'].toString() == null.toString()) {

      setState(() {

        _log = false;

      });

    }
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
        title: Text("Profill Utilisateur"),
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
          /*
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                UserModel.getUser();
              }),

           */
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(35),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(5),

                  width: double.infinity,
                ),
              ),
              _log
                  ? ClipOval(
                      child: Image.network(
                        _urlImage+'/${widget.user!['user_image_user']}',
                        height: 200,
                      ),
                    )
                  : const Image(
                      image:   AssetImage("images/users.png"),
                      height: 200,
                    ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "Name : " + '${widget.user!['user_name']}',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "prenom : " + '${widget.user!['user_surname']}',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "telephone 1 : " + '${widget.user!['user_tel_1']}',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "telephone 2 : " + '${widget.user!['user_tel_2']}',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "Email : " + '${widget.user!['user_email']}',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "Adresse : " + '${widget.user!['user_adresse']}',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),

              Text(
                "Ville : " + '${widget.user!['user_city']}',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "pays : " + '${widget.user!['user_contry']}',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "cni : " + '${widget.user!['user_cni']}',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),

              Text(
                "Statut : " + '${widget.user!['user_status_user']}',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),

              // Text(
              //   "Password :" + '${widget.user['password']}',
              //   style: TextStyle(
              //     fontSize: 15,
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              // Text(
              //   "Dernièrer mise a jour  : " + widget.user!['updated_at'],
              //   style: TextStyle(fontSize: 15),
              // ),
              // Text(
              //   "Enregistré le :" + widget.user!['created_at'],
              //   style: TextStyle(
              //     fontSize: 15,
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.all(5),
              // )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserEdit(user: widget.user!,)
              )
          )
        },
      ),
      drawer: Drawers(),
    );
  }
}
