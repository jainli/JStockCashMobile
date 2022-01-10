import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class CallApi {

  //final String _url = 'http://localhost:8000/api/';
  final String _url = 'https://apitest.jstockcash.com/api/';

  connection(data, apiUrl) async {
    var fullUrl = _url + apiUrl;

    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeaders());
  }

  logout(apiUrl) async {
    var fullUrl = _url + apiUrl;
    var head = await _setHeadersLogout();

    return await http.post(
        Uri.parse(fullUrl),
        headers: head);
  }

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    var head = await _setTokenHeaders();

    return await http.post(
      Uri.parse(fullUrl),
        headers: head,
      body: jsonEncode(data),
    );
}

  editData(data, apiUrl) async {

    var fullUrl = _url + apiUrl;
    var head = await _setTokenHeaders();
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: head);
  }

  getData(apiUrl) async {

    var fullUrl = _url + apiUrl;
    var head = await _setTokenHeaders();

    return await http.get(Uri.parse(fullUrl),
        headers: head);

  }

  deleteData(apiUrl) async {

    var fullUrl = _url + apiUrl;
    var head = await _setTokenHeaders();

    return await http.delete(Uri.parse(fullUrl),
        headers: head);

  }

  refreshToken(apiUrl) async {

    var fullUrl = _url + apiUrl;
    var head = await _setRefreshTokenHeaders();

    return await http.post(Uri.parse(fullUrl),
        headers: head);
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  _getToken() async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var token = localStorage.getString('access_token');

    return  token;

  }

  _getRefreshToken() async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var refreshToken = localStorage.getString('refresh_token');

    return  refreshToken;

  }

  _setTokenHeaders() async {

    var token = await _getToken();

    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
     };

  }

  _setHeadersLogout() async {

    var token = await _getToken();

    return {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };

  }

  _setRefreshTokenHeaders() async {

    var refreshToken = await _getRefreshToken();

    return {
      'Refreshtoken': '${refreshToken}',
    };
  }

  /*
  _getTokenVeriefied(_expiryDate) async {

    var token = await _getToken();

    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return token;
    }

    refreshSession();
    return null;
  }

   */

}