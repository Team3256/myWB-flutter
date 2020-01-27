import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:mywb_flutter/models/event.dart';
import 'models/user.dart';

User currUser;

bool darkMode = false;
bool darkAppBar = false;

Event selectedEvent;
bool autoCheckIn = false;
String autoCheckOut = "";