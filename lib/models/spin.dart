class Spin {
  String matchID = "";
  String teamID = "";
  double rotationTime = 0.0;
  bool rotation = false;
  double positionTime = 0.0;
  bool position = false;

  @override
  String toString() {
    return "";
  }

  Map<String, dynamic> toJson() =>
      {
        'matchID': matchID,
        'teamID': teamID,
        'rotationTime': rotationTime,
        'rotation': rotation,
        'positionTime': positionTime,
        'position': position
      };
}