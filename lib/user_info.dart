import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluro/fluro.dart';

final router = Router();

String currentPage = "Home";

String authToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ5ZWV0QGV4YW1wbGUuZ292Iiwic2NvcGVzIjoiUk9MRV9TVFVERU5ULFJPTEVfVVNFUiIsImlhdCI6MTU0Njg5OTU4NiwiZXhwIjoxNTYyNjc5NTg2fQ.1W1D1UrenkUNQUIJq5B_DNAZRI67-EB9q0MPa8BoiOA";

String firstName = "[ERROR]";
String middleName = "[ERROR]";
String lastName = "[ERROR]";
String email = "[ERROR]";
String birthday = "[ERROR]";
String phone = "[ERROR]";
String gender = "[ERROR]";

String role = "[ERROR]";

String currTeam = "";
String currAlliance = "";
String currMatch = "";
String currRegional = "";

String scoutState = "";

Stopwatch stopwatch = new Stopwatch();

List<Foul> foulList = new List();

int habLevel = 0;
bool autoLine = false;
AutoLine auto;

Stopwatch dcStopwatch = new Stopwatch();
List<Disconnect> dcList = List();

Stopwatch hatchStopwatch = new Stopwatch();
List<Hatch> hatchList = new List();

Stopwatch cargoStopwatch = new Stopwatch();
List<Cargo> cargoList = new List();

Stopwatch climbStopwatch = new Stopwatch();
List<Climb> climbList = new List();

List<Match> matchList = new List();

var matchEventList = [];

class AutoLine {
  int habLevel;
  double time;
  bool crossed;

  AutoLine(this.habLevel, this.time, this.crossed);

  Map toJson() {
    Map map = new Map();
    map["habLevel"] = this.habLevel;
    map["time"] = this.time;
    map["crossed"] = this.crossed;
    return map;
  }
}

class Disconnect {
  double startTime;
  double duration;

  Disconnect(this.startTime, this.duration);

  Map toJson() {
    Map map = new Map();
    map["startTime"] = this.startTime;
    map["duration"] = this.duration;
    return map;
  }
}

class Hatch {
  String pickup;
  String dropOff;
  double pickupTime;
  double cycleTime;
  String gamePart;

  Hatch(this.pickup, this.dropOff, this.pickupTime, this.cycleTime, this.gamePart);

  Map toJson() {
    Map map = new Map();
    map["pickup"] = this.pickup;
    map["dropOff"] = this.dropOff;
    map["pickupTime"] = this.pickupTime;
    map["cycleTime"] = this.cycleTime;
    return map;
  }
}

class Cargo {
  String pickup;
  String dropOff;
  double pickupTime;
  double cycleTime;
  String gamePart;

  Cargo(this.pickup, this.dropOff, this.pickupTime, this.cycleTime, this.gamePart);

  Map toJson() {
    Map map = new Map();
    map["pickup"] = this.pickup;
    map["dropOff"] = this.dropOff;
    map["pickupTime"] = this.pickupTime;
    map["cycleTime"] = this.cycleTime;
    return map;
  }
}

class Foul {
  String reason;
  double time;

  Foul(this.time, this.reason);

  Map toJson() {
    Map map = new Map();
    map["time"] = this.time;
    map["reason"] = this.reason;
    return map;
  }
}

class Climb {
  double time;
  double cycleTime;
  int habLevel;
  bool canSupport;
  bool dropped;

  Climb(this.time, this.cycleTime, this.habLevel, this.canSupport, this.dropped);

  Map toJson() {
    Map map = new Map();
    map["time"] = this.time;
    map["cycleTime"] = this.cycleTime;
    map["habLevel"] = this.habLevel;
    map["canSupport"] = this.canSupport;
    map["dropped"] = this.dropped;
    return map;
  }
}

class Match {
  int matchNumber;
  String regionalKey;
  String teamKey;
  String alliance;

  List hatches;
  double avgHatch;
  int hatchCount;

  List cargoes;
  double avgCargo;
  int cargoCount;

  List disconnects;
  List fouls;
  List climbs;
  AutoLine auto;

  Map toJson() {
    Map map = new Map();
    map["matchNumber"] = this.matchNumber;
    map["regionalKey"] = this.regionalKey;
    map["teamKey"] = this.teamKey;
    map["alliance"] = this.alliance;
    map["matchData"] = {
      "hatch": this.hatches,
      "cargo": this.cargoes,
      "disconnect": this.disconnects,
      "foul": this.fouls,
      "climb": this.climbs,
      "auto": this.auto.toJson()
    };
    map["avgHatch"] = avgHatch;
    map["avgCargo"] = avgCargo;
    map["hatchCount"] = hatchCount;
    map["cargoCount"] = cargoCount;
    return map;
  }
}