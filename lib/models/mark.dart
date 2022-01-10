import 'package:flutter/cupertino.dart';

class Mark extends Table {

  final int id;
  final String? mark_title;

  Mark(
      this.id,
      this.mark_title
      );

  Mark.fromJson(Map<String, dynamic> json):
        id = json['id'],
        mark_title = json['mark_title'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'mark_title': mark_title,
  };
}