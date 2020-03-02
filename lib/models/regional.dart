class Regional {
  String id;
  String city;
  String country;
  DateTime endDate;
  String eventCode;
  String name;
  String shortName;
  DateTime startDate;
  String year;

  List<String> teamsList = new List();

  Regional(Map<String, dynamic> json) {
    this.city = json["city"];
    this.country = json["country"];
    this.endDate = DateTime.parse(json["end_date"]);
    this.eventCode = json["event_dode"];
    this.id = json["id"];
    this.name = json["name"];
    this.shortName = json["short_name"];
    this.startDate = DateTime.parse(json["start_date"]);
    this.year = json["year"];
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
