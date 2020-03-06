import 'match_data.dart';

class Match {
  String id = "";
  String regionalID = "";
  int matchNum = 0;
  MatchData matchData;

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'regionalID': regionalID,
        'matchNum': matchNum,
        'matchData': matchData
      };
}