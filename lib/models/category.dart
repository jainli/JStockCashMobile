import 'package:flutter/cupertino.dart';

class Category extends Table {

  final int id;
  final String? category_title;
  final String? category_description;

  Category(
      this.id,
      this.category_title,
      this.category_description,
      );

  Category.fromJson(Map<String, dynamic> json):
        id = int.parse(json['id'].toString()),
        category_title = json['category_title'],
        category_description = json['category_description'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'category_title': category_title,
    'category_description': category_description,
  };

}