import 'package:mywb_flutter/models/auto_line.dart';
import 'package:mywb_flutter/models/climb.dart';
import 'package:mywb_flutter/models/disconnect.dart';
import 'package:mywb_flutter/models/power_cell.dart';
import 'package:mywb_flutter/models/spin.dart';

class MatchData {
  String matchID = "";
  String teamID = "";
  String scouterID = "";
  String alliance = "";
  int preload = 0;
  bool park = false;

  AutoLine auto;
  Spin spin;
  List<PowerCell> powercells = new List();
  List<Climb> climbs = new List();
  List<Disconnect> disconnects = new List();

  bool level = false;

  Map<String, dynamic> toJson() =>
      {
        'matchID': matchID,
        'teamID': teamID,
        'scouterID': scouterID,
        'alliance': alliance,
        'preload': preload,
        'park': park,
        'auto': auto,
        'spin': spin,
        'powercells': powercells,
        'climbs': climbs,
        'disconnects': disconnects,
        'level': level
      };

}