import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluro/fluro.dart';

final router = Router();

double appVersion = 1.0;
int appBuild = 2;
String appStatus = "";
String appFull = "Version $appVersion";

String currentPage = "Home";

String authToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ5ZWV0QGV4YW1wbGUuZ292Iiwic2NvcGVzIjoiUk9MRV9TVFVERU5ULFJPTEVfVVNFUiIsImlhdCI6MTU0Njg5OTU4NiwiZXhwIjoxNTYyNjc5NTg2fQ.1W1D1UrenkUNQUIJq5B_DNAZRI67-EB9q0MPa8BoiOA";
String dbHost = "https://mywb.vcs.net/";

String firstName = "[ERROR]";
String middleName = "[ERROR]";
String lastName = "[ERROR]";
String email = "[ERROR]";
String birthday = "[ERROR]";
String phone = "[ERROR]";
String gender = "[ERROR]";

String role = "[ERROR]";

String appLegal = """
MIT License
Copyright (c) 2018 Equinox Initiative
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
""";

List<String> teamsList = new List();
List<Regional> regionalList = new List();

String currTeam = "";
String currAlliance = "";
String currMatch = "";
String currMatchKey = "";
Regional currRegional = new Regional("", "", "");

String selectedTeam = "";
String selectedMatch = "";

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

class Regional {
  String key;
  String name;
  String shortName;

  Regional(this.key, this.name, this.shortName);

  toString() {
    return ("$key - $name ($shortName)");
  }
}