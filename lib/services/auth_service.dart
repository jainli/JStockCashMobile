import 'dart:async';
import 'dart:convert';

import 'package:jstockcash/models/userModel.dart';
import 'package:jstockcash/page/widget/api.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {

  final callApi = CallApi();
  Timer? _authTimer;
  bool result = true;

  Future connexion(UserModel user) async {

      Map data = {
        'user_tel_1': user.user_tel_1,
        'password': user.password,
      };

      var response = await callApi.connection(data, 'loginMobile');

      if(response.statusCode == 200) {

        Map<String, dynamic> userMap = jsonDecode(response.body);

        return userMap;

      } else {

        Map<String, dynamic> userMap = jsonDecode(response.body);

        return userMap;

      }

  }

  Future lagout() async {

      SharedPreferences p = await SharedPreferences.getInstance();

      var response = await callApi.logout('logoutMob');

      if(response.statusCode == 200) {

        p.setBool("isLoggedIn", false);

        p.setString('user', null.toString());

        p.setString('expires_in', null.toString());

        p.setString('token_type', null.toString());

        p.setString('access_token', null.toString());

        p.setString('refresh_token', null.toString());

        return true;

      } else {

        return false;

      }

  }

  Future autoLogout(DateTime expiryDate) async {

    final timeToExpiry = expiryDate.difference(DateTime.now()).inSeconds;

     //print(timeToExpiry);

     if(timeToExpiry > 0) {

       _authTimer?.cancel();

       return true;

     } else {

       //_authTimer = Timer(Duration(seconds: timeToExpiry), refreshToken);

       return await refreshToken();

     }

  }

  Future refreshToken() async {

    SharedPreferences p = await SharedPreferences.getInstance();

    final response = await callApi.refreshToken('refreshtoken');

    //print(response.body);

    if(jsonDecode(response.body)['error'].toString().toLowerCase().contains('invalid_request'.toLowerCase())) {

      await lagout();

      return false;

    } else {

      final _expiryDate = DateTime.now().add(Duration(seconds: jsonDecode(response.body)['expires_in']));

      p.setString('expires_in', _expiryDate.toIso8601String());

      p.setString('token_type', jsonDecode(response.body)['token_type']);

      p.setString('access_token', jsonDecode(response.body)['access_token']);

      p.setString('refresh_token', jsonDecode(response.body)['refresh_token']);

      return true;

    }


  }

}