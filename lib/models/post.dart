import 'dart:convert';

class Post {
  String id;
  String title;
  String authorID;
  DateTime date;
  String body;

  User(Map<String, dynamic> json) {
    id = json["id"];
  }
}