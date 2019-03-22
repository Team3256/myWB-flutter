import 'package:mywb_flutter/user_info.dart';

class MatchData {

  double avgHatch = 0;
  int hatchCount = 0;

  double avgCargo = 0;
  int cargoCount = 0;

  Map toJson() {

    Map map = new Map();
    map["auto"] = auto;
    map["hatch"] = hatchList;
    map["cargo"] = cargoList;
    map["climb"] = climbList;
    map["disconnect"] = dcList;
    map["foul"] = foulList;
    map["averageHatch"] = avgHatch;
    map["averageCargo"] = avgCargo;
    map["hatchCount"] = hatchCount;
    map["cargoCount"] = cargoCount;
    return map;
  }
}