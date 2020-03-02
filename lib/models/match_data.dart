import 'package:mywb_flutter/models/auto_line.dart';
import 'package:mywb_flutter/models/climb.dart';
import 'package:mywb_flutter/models/disconnect.dart';
import 'package:mywb_flutter/models/power_cell.dart';

class MatchData {
  String matchID = "";
  String teamID = "";
  String scouterID = "";
  String alliance = "";

  AutoLine auto;
  int preload = 0;
  bool park = false;
  List<PowerCell> powercells = new List();
  List<Climb> climbs = new List();
  List<Disconnect> disconnects = new List();
}