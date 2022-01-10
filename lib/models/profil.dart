import 'package:flutter/cupertino.dart';

class Profil extends Table {

  final int id;
  final String? description_profils;

  Profil({
    required this.id,
    this.description_profils,
  });

  Profil.fromJson(Map<String, dynamic> json):
        id = json['id'],
        description_profils	 = json['description_profils'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'description_profils': description_profils,
  };

}