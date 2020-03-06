import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:mywb_flutter/models/event.dart';
import 'package:mywb_flutter/models/match.dart';
import 'package:mywb_flutter/models/regional.dart';
import 'models/power_cell.dart';
import 'models/team.dart';
import 'models/user.dart';

User currUser;

bool darkMode = false;
bool darkAppBar = false;

bool offlineMode = false;

List<Regional> regionalList = new List();

Event selectedEvent;
bool autoCheckIn = false;
String autoCheckOut = "";

Stopwatch stopwatch = new Stopwatch();

Regional currRegional;
Match currMatch;
Team currTeam;

Stopwatch powercellStopwatch = new Stopwatch();

Stopwatch climbStopwatch = new Stopwatch();

Stopwatch dcStopwatch = new Stopwatch();