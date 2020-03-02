class AutoLine {
  String matchID = "";
  String teamID = "";
  String startPosition = "";
  bool crossed = false;
  double crossTime = 0.0;
  bool trench = false;

  @override
  String toString() {
    return "$teamID ${crossed?"CROSSED":"DIDN'T CROSS"} – $crossTime FROM $startPosition";
  }
}