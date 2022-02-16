// ignore: file_names
import '../../models/profil.dart';

class UserModel {

  int? id;
  String? user_name;
  String? user_surname;
  String? user_tel_1;
  String? user_tel_2;
  String? password;
  String? user_email;
  String? user_cni;
  String? user_adresse;
  String? user_city;
  String? user_contry;
  String? user_status_user;
  Profil? profil;

  UserModel({
    this.id,
    this.user_name,
    this.user_surname,
    required this.user_tel_1,
    this.user_tel_2,
    this.password,
    this.user_email,
    this.user_cni,
    this.user_adresse,
    this.user_city,
    this.user_contry,
    this.user_status_user,
    this.profil
  });

  factory UserModel.fromJson(Map<String, dynamic> i) => UserModel(
        id: int.parse(i['id'].toString()),
        user_name: i['user_name'],
        user_surname: i['user_surname'],
        user_tel_1: i['user_tel_1'],
        user_tel_2: i['user_tel_2'],
        password: i['password'],
        user_email: i['user_email'],
        user_cni: i['user_cni'],
        user_adresse: i['user_adresse'],
        user_city: i['user_city'],
        user_contry: i['user_contry'],
        user_status_user: i['user_status_user'],
        profil: Profil.fromJson(i)
      );

  Map toMap() {
    return {
      user_name: 'user_name',
      user_surname: 'user_surname',
      user_tel_1: 'user_tel_1',
      user_tel_2: 'user_tel_2',
      user_email: 'user_email',
      user_cni: 'user_cni',
      user_contry: 'user_contry',
      user_city: 'user_city',
      profil: 'user_profil',
      password: 'password',
      user_status_user: 'user_status_user'
    };
  }
}
