import 'dart:convert';

import '../../models/userModel.dart';
import '../../page/widget/api.dart';


class UserService {

  final callApi = CallApi();

  Future updateUser(UserModel user) async {

    Map data = {
      'id': user.id,
      'user_name': user.user_name,
      'user_surname' : user.user_surname,
      'user_tel_1' : user.user_tel_1,
      'user_tel_2' : user.user_tel_2,
      'user_email' : user.user_email,
      'user_cni' : user.user_cni,
      'user_adresse' : user.user_adresse,
      'user_contry' : user.user_contry,
      'user_city' : user.user_city,
      'user_profil' : user.profil?.id,
    };

    var response = await callApi.editData(data, 'userUpdateMob');

    if(response.statusCode == 200) {

      Map<String, dynamic> UserMap = jsonDecode(response.body);

      return UserMap;

    } else {

      throw Exception('Failed to post a sale');

    }
  }

  Future phoneExists(int userPhone) async {

    Map data = {
      'phone': userPhone,
    };

    var response = await callApi.postData(data, 'phoneExistsMob');

    if(response.statusCode == 200) {

      return jsonDecode(response.body)['response'];

    } else {

      throw Exception('Failed to post a phone user');

    }
  }

  Future emailExists(String userEmail) async {

    Map data = {
      'email': userEmail,
    };

    var response = await callApi.postData(data, 'emailExistsMob');

    if(response.statusCode == 200) {

      return jsonDecode(response.body)['response'];

    } else {

      throw Exception('Failed to post an email user');

    }
  }

  Future cniExists(int userCni) async {

    Map data = {
      'cni': userCni,
    };

    var response = await callApi.postData(data, 'cniExistsMob');

    if(response.statusCode == 200) {

      return jsonDecode(response.body)['response'];

    } else {

      throw Exception('Failed to post a cni user');

    }
  }

}