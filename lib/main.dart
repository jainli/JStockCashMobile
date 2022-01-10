import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jstockcash/page/authentification/connection.dart';
import 'package:jstockcash/page/home/home.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/io_client.dart';


Future main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SharedPreferences _prefs = await SharedPreferences.getInstance();
  bool checkLogin = _prefs.getBool("isLoggedIn") ?? false;

  //HttpOverrides.global = new MyHttpOverrides();

  runApp(MyApp(checkLogin, _prefs.getString("user")));
}

class MyApp extends StatelessWidget {

  bool checkLogin;
  String? user;

  MyApp(this.checkLogin, this.user);

  static final String title = 'Navigation Drawer';

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JstockCashMob',
        initialRoute: '/',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: checkLogin ? Home(user: jsonDecode(user!) as Map) :  Login());

  }

}

/*
class MyHttpOverrides extends HttpOverrides{

  String host = "apitest.jstockcash.com";

  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, host, int port)=> true; SIGL1234
  }
}
*/