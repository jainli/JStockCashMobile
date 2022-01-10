import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jstockcash/services/auth_service.dart';
import 'package:jstockcash/models/userModel.dart';
import 'package:jstockcash/page/home/home.dart';
import 'package:jstockcash/page/widget/constants.dart';

/*
class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _key = GlobalKey<FormState>();
  String err = "";
  bool _loading = false;

  void login(user_tel_1, String user_password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      err = "";
      _loading = true;
    });

    //final response = await Api.dio().post('/login', data: {"tel": user_tel_1, "pass": user_password});

    final response =
        await http.post(Uri.parse("${Env.URL_PREFIX}/loginLine"), body: {
      "user_tel_1": user_tel_1,
      "password": user_password,
    });

    print(response.body);/*
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var result = data['data'];
      // // print(result);

      String title = data['message'];
      setState(() {
        err = data['message'];
      });

      if (title == 'connexion') {
        //print(data['data']);

        err = data['message'];

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      user: data['data'],
                      login: () {},
                    )));
        _loading = false;

        // widget.login.call();
      } else {
        setState(() {
          err = data['message'];
          _loading = false;
          // print(pref.getInt("data"));
        });
      }
    }*/
  }

  // @override
  // void iniState;
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
  final _Key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    user_tel_1.err = "enter votre numero";
    user_password.err = "enter password";
    return _loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color.fromRGBO(44, 44, 44, 0.6),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(30),
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Image(
                            image: AssetImage("images/logo.png.PNG"),
                            height: 90,
                          ),
                          Text(
                            "CONNEXION",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.white24),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          user_tel_1.textfrofield(),
                          SizedBox(
                            height: 10,
                          ),
                          user_password.textfrofield(),
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  login(user_tel_1.value, user_password.value);
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              color: Colors.blueAccent[100]?.withOpacity(.7)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('mot de passe oublier? '),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PasswordForget()));
                                  },
                                  child: Text(
                                    "Forgot",
                                    style:
                                        TextStyle(color: Colors.orangeAccent),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            err,
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )),
              ),
            ),
          );
  }
}
*/



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final AuthService authService = AuthService();

  final _addFormKey = GlobalKey<FormState>();

  TextEditingController _telController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.blueAccent,
    primary: Colors.grey[300],
    minimumSize: Size(200, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );

  String? responseServeur;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    responseServeur = "";

  }

  bool _isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }

  bool _rememberMe = false;

  Widget _buildTelTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Téléphone',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          //decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _telController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(
              color: Colors.black,
                fontFamily: 'OpenSans'
            ),
            decoration: const InputDecoration(
              //border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.call,
                color: Colors.black,
              ),
              hintText: 'Entrer votre numéro de téléphone',
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              //hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              if(value?.isEmpty ?? true) {
                return 'Veuillez saisir un numéro de télephone';
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Mot de passe',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          //decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _passController,
            obscureText: true,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              //color: Colors.white,
                fontFamily: 'OpenSans'
            ),
            decoration: const InputDecoration(
              //border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              hintText: 'Entrer votre mot de passe',
                hintStyle: TextStyle(
                  color: Colors.black,
                )
              //hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              if(value?.isEmpty ?? true) {
                return 'Veuillez saisir un mot de passe';
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => print("Forgot Password Button Pressed"),
        //padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _builRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
              data: ThemeData(unselectedWidgetColor: Colors.black54),
              child: Checkbox(
                value: _rememberMe,
                checkColor: Colors.green,
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value!;
                  });
                },
              )
          ),
          Text(
            "Remember me",
            style: kLabelStyle,
          )
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: SignIn,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)
        ),
        //color: Color(0xFF1565C0),
        color: Colors.white,
        child: const Text(
          "LOGIN",
          style: TextStyle(
              color: Color(0xFF1565C0),
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        const Text(
          '- OR -',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400
          ),
        ),
        const SizedBox(height: 20.0),
        Text('Sign in with', style: kLabelStyle)
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
        onTap: () => onTap,
        child: Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0
                )
              ],
              image: DecorationImage(
                  image: logo,
              )
          ),
        )
    );
  }

  Widget _buildSocialBtnRow() {
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
                  () => print("Login with Facebook"),
              AssetImage(
                  "images/facebook.png",
              )
          ),
          _buildSocialBtn(
                  () => print("Login with Google"),
              AssetImage(
                  "images/google.png"
              )
          ),
        ],
      ),
    );
  }

  Widget _buildSingupBtn() {
    return GestureDetector(
      onTap: () => print("Sign Up Button Pressed"),
      child:  RichText(
          text: const TextSpan(
              children: [
                TextSpan(
                    text: "Don\'t have an Account ? ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400
                    )
                ),
                TextSpan(
                    text: "Sign Up ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400
                    )
                )
              ]
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _addFormKey,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white38,
                                Colors.white38,
                                Color(0xFF478DE0),
                                Color(0xFF007AC3),

                              ],
                              stops: [0.1, 0.4, 0.7, 0.9]
                          )
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 120.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Image(
                              image: AssetImage("images/logo_noir.png"),
                              height: 90,
                              width: 800,
                            ),
                            const SizedBox(height: 30.0),
                            const Text(
                              'Sign In',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            _buildTelTF(),
                            const SizedBox(height: 30.0),
                            _buildPasswordTF(),
                            _buildForgotPasswordBtn(),
                            _builRememberMeCheckbox(),
                            _buildLoginBtn(),
                            Text(
                              responseServeur!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'OpenSans',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold
                              ),
                              /*style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.red),*/
                            ),
                            _buildSignInWithText(),
                            _buildSocialBtnRow(),
                            _buildSingupBtn()
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            )
        )
    );
  }

  Future<void> SignIn() async {

    var response;
    DateTime _expiryDate;

    if(_addFormKey.currentState!.validate()) {

      if(_isNumeric(_telController.text)) {

          final SharedPreferences prefs = await _prefs;

          try {

            response = authService.connexion(UserModel(user_tel_1: int.parse(_telController.text), password: _passController.text));

            response.then((e) {

              setState(() {

                responseServeur = e['message'];

                if(e['message'] == "Success") {

                  _expiryDate = DateTime.now().add(Duration(seconds: e['expires_in']));

                  /*final userData = json.encode({
                    'isLoggedIn': true,
                    'access_token': e['access_token'],
                    'refresh_token': e['refresh_token'],
                    'userId': e['user'],
                    'expiryDate': _expiryDate.toIso8601String(),
                  });
                  prefs.setString('userData', userData);*/
                  
                  prefs.setBool("isLoggedIn", true);

                  prefs.setString('user', json.encode(e['user']));

                  prefs.setString('expires_in', _expiryDate.toIso8601String());

                  prefs.setString('token_type', e['token_type']);

                  prefs.setString('access_token', e['access_token']);

                  prefs.setString('refresh_token', e['refresh_token']);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home(
                            user: e['user'],
                          )
                      )
                  );

                }

              });

            });

          } catch(e) {

            print("Error Error");

          }


      } else {

        setState(() {

          responseServeur = "Le numéro de téléphone dois être constitue uniquement des chiffres";

        });

      }


    }

  }
}