import 'dart:convert';

class Event {
  String id;
  DateTime date;
  DateTime startTime;
  DateTime endTime;
  String type;
  String name;
  String desc;
  double latitude;
  double longitude;
  int radius;

  Event(Map<String, dynamic> json) {
    id = json["id"];
    date = DateTime.parse(json["date"]);
    startTime = DateTime.parse(json["startTime"]);
    endTime = DateTime.parse(json["endTime"]);
    type = json["type"];
    name = json["name"];
    desc = json["desc"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    radius = json["radius"];
  }

  Map<String, dynamic> toJson() =>
      {};

}