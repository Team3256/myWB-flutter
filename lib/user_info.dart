import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:mywb_flutter/models/autoline.dart';
import 'package:mywb_flutter/models/cargo.dart';
import 'package:mywb_flutter/models/climb.dart';
import 'package:mywb_flutter/models/disconnect.dart';
import 'package:mywb_flutter/models/foul.dart';
import 'package:mywb_flutter/models/hatch.dart';
import 'package:mywb_flutter/models/regional.dart';
import 'package:mywb_flutter/models/scouting_state.dart';

final router = Router();

double appVersion = 2.0;
int appBuild = 3;
String appStatus = "";
String appFull = "Version $appVersion";

String authToken = "";
String dbHost = "https://mywb.vcs.net/";

String firstName = "[ERROR]";
String middleName = "";
String lastName = "[ERROR]";
String email = "[ERROR]";
String birthday = "[ERROR]";
String phone = "[ERROR]";
String gender = "[ERROR]";

String role = "[ERROR]";
String userID = "";

bool darkMode = false;
bool offlineMode = false;

String appLegal = """
MIT License
Copyright (c) 2018 FRC WarriorBorgs 3256
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

ScoutingState currState = new ScoutingState("", 0.0, 0.0, "");

int lastPage = 0;

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

List<Climb> climbList = new List();

List<Match> matchList = new List();

var matchEventList = [];