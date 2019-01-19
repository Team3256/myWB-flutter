import 'package:flutter/material.dart';
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

String scoutState = "";

Stopwatch stopwatch = new Stopwatch();

List<Foul> foulList = new List();

int habLevel = 0;
bool autoLine = false;
double autoTime = 0;
bool auto = false;

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

class Disconnect {
  double startTime;
  double duration;

  Disconnect(this.startTime, this.duration);
}

class Hatch {
  String pickup;
  String dropOff;
  double pickupTime;
  double cycleTime;
  String gamePart;

  Hatch(this.pickup, this.dropOff, this.pickupTime, this.cycleTime, this.gamePart);
}

class Cargo {
  String pickup;
  String dropOff;
  double pickupTime;
  double cycleTime;
  String gamePart;

  Cargo(this.pickup, this.dropOff, this.pickupTime, this.cycleTime, this.gamePart);
}

class Foul {
  String reason;
  double time;

  Foul(this.time, this.reason);
}

class Climb {
  double time;
  double cycleTime;
  int habLevel;
  bool canSupport;
  bool dropped;

  Climb(this.time, this.cycleTime, this.habLevel, this.canSupport, this.dropped);
}

class Match {
  String teamName;
  String matchNumber;
  String alliance;

}