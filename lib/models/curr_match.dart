import 'package:firebase_database/firebase_database.dart';

class CurrMatch {
  String key;
  String match;
  String team;
  String alliance;
  String scoutedBy;

  CurrMatch(DataSnapshot snapshot) {
    this.key = snapshot.key;
    this.match = snapshot.value["match"].toString();
    this.team = snapshot.value["team"].toString();
    this.alliance = snapshot.value["alliance"];
    this.scoutedBy = snapshot.value["scoutedBy"];
  }

}