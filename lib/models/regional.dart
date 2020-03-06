import 'package:mywb_flutter/models/team.dart';

class Regional {
  String id;
  String city;
  String country;
  DateTime endDate;
  String eventCode;
  String name;
  String shortName;
  DateTime startDate;
  int year;

  List<Team> teamsList = new List();

  Regional(Map<String, dynamic> json) {
    this.city = json["city"];
    this.country = json["country"];
    this.endDate = DateTime.parse(json["endDate"]);
    this.eventCode = json["eventCode"];
    this.id = json["id"];
    this.name = json["name"];
    this.shortName = json["shortName"];
    this.startDate = DateTime.parse(json["startDate"]);
    this.year = json["year"];

    for (int i = 0; i < json["teams"].length; i++) {
      teamsList.add(new Team(json["teams"][i]));
    }
  }

}

/*
{
  "key": "2019cadm", (or id)
  "city": "Del Mar",
  "country": "USA",
  "district": null,
  "end_date": "2019-03-03",
  "event_code": "cadm",
  "event_type": 0,
  "name": "Del Mar Regional presented by Qualcomm",
  "start_date": "2019-02-28",
  "state_prov": "CA",
  "year": 2019
}
*/
