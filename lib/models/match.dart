import 'package:mywb_flutter/models/match_data.dart';

class Match {
  int matchNumber;
  String regionalKey;
  int teamKey;
  String alliance;

  MatchData matchData;

  Match({this.alliance, this.teamKey, this.regionalKey, this.matchNumber});

  Map toJson() {
    Map map = new Map();
    map["matchNumber"] = this.matchNumber;
    map["regionalKey"] = this.regionalKey;
    map["teamKey"] = this.teamKey;
    map["alliance"] = this.alliance;
    map["matchData"] = matchData;
    return map;
  }
}
