import 'package:flutter/cupertino.dart';

class SubCategory extends Table {

  final int? id;
  final String? sub_category_title;
  final String? sub_category_description;

  SubCategory(
      this.id,
      this.sub_category_title,
      this.sub_category_description,
      );

  SubCategory.fromJson(Map<String, dynamic> json):
        id = int.parse(json['id'].toString()),
        sub_category_title = json['sub_category_title'],
        sub_category_description = json['sub_category_description'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'sub_category_title': sub_category_title,
    'sub_category_description': sub_category_description,
  };

}