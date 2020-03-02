class Climb {
  String matchID = "";
  String teamID = "";
  double startTime = 0.0;
  double climbTime = 0.0;
  bool dropped = false;
  bool level = false;

  @override
  String toString() {
    return dropped ? ("$teamID CLIMBED AT $startTime IN $climbTime") : "$teamID DROPPED WHILE CLIMBING AT $startTime";
  }
}